//
//  OverlayViewController.swift
//  SVGOverlayApp
//
//  Created by 김부성 on 2022/07/05.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources
import RxFlow
import Then
import RxGesture

import SVGOverlayUI
import Photos

final class OverlayViewController: BaseViewController, ReactorKit.View, RxFlow.Stepper {
  
  var steps: PublishRelay<Step> = .init()
  typealias Reactor = OverlayReactor
  
  fileprivate struct Metric {
    static let collectionMarginTop: CGFloat = 24
    static let collectionMarginBottom: CGFloat = 24
    static let collectionMarginSide: CGFloat = 40
    static let collectionInteritemSpacing: CGFloat = 16
    
    static let tableMarginTop: CGFloat = 14
    static let tableMarginBottom: CGFloat = 14
    static let tableMarginSide: CGFloat = 0
    
    static let topBarHeight: CGFloat = 60
    static let topBarBottomLineHeight: CGFloat = 1
    
    static let titleLabelBottom: CGFloat = 16
    
    static let tableViewCellHeight: CGFloat = 84
    
    static let dropImageViewLeft: CGFloat = 15
    
    static let buttonWidth: CGFloat = 103
    static let buttonHeight: CGFloat = 33
    
    static let collectionViewHeight: CGFloat = 150
    
    static let collectionViewCellSize: CGFloat = 80
    
    static let overlayButtonRight: CGFloat = 20
    static let overlayButtonBottom: CGFloat = 15
    
    static let closeButtonSize: CGFloat = 12
    static let closeButtonBottom: CGFloat = 22
    static let closeButtonLeft: CGFloat = 30
    
    static let svgViewSide: CGFloat = 60
  }
  
  fileprivate struct Font {
    static let titleFont = UIFont.systemFont(ofSize: 16, weight: .medium)
  }
  
  // MARK: - UI
  fileprivate let topBarView = UIView.init().then {
    $0.backgroundColor = .systemBackground
  }
  fileprivate let topBarBottomLine = UIView().then {
    $0.backgroundColor = SVGOverlayUIAsset.Colors.overlayTopbarGray.color
  }
  fileprivate let overlayButton = OverlayBlackButton(type: .system).then {
    $0.setTitle("Overlay", for: .normal)
    $0.layer.cornerRadius = Metric.buttonHeight / 2
  }
  
  fileprivate let closeButton = UIButton(type: .system).then {
    $0.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
    $0.tintColor = .black
  }
  
  fileprivate let backgroundImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  fileprivate let svgView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  fileprivate var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    
    layout.scrollDirection = .horizontal
    layout.sectionInset = .zero
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .systemBackground
    cv.register(SVGSelectCollectionViewCell.self, forCellWithReuseIdentifier: "SVGSelectCollectionViewCell")
    
    return cv
  }()
  
  lazy var collectionDataSource = RxCollectionViewSectionedReloadDataSource<Reactor.ImageSectionModel> { dataSource, collectionView, indexPath, item in
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SVGSelectCollectionViewCell", for: indexPath) as? SVGSelectCollectionViewCell else { return UICollectionViewCell() }
    
    cell.assetImageView.image = item
    return cell
  }
  
  fileprivate let cacheManager = PHCachingImageManager()
  
  
  // MARK: - Inintializing
  init(reactor: Reactor) {
    super.init()
    defer {
      self.reactor = reactor
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func setupLayout() {
    self.view.addSubview(self.topBarView)
    
    self.topBarView.addSubview(self.overlayButton)
    
    self.topBarView.addSubview(self.closeButton)
    
    self.view.addSubview(self.topBarBottomLine)
    
    self.view.addSubview(self.backgroundImageView)
    
    self.backgroundImageView.addSubview(self.svgView)
    
    self.view.addSubview(self.collectionView)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    self.topBarView.pin
      .top(self.view.pin.safeArea.top)
      .left()
      .right()
      .height(Metric.topBarHeight)
    
    self.overlayButton.pin
      .right(Metric.overlayButtonRight)
      .bottom(Metric.overlayButtonBottom)
      .width(Metric.buttonWidth)
      .height(Metric.buttonHeight)
    
    self.closeButton.pin
      .size(Metric.closeButtonSize)
      .bottom(Metric.closeButtonBottom)
      .left(Metric.closeButtonLeft)
    
    self.topBarBottomLine.pin
      .below(of: self.topBarView)
      .left()
      .right()
      .height(Metric.topBarBottomLineHeight)
    
    self.collectionView.pin
      .left()
      .right()
      .height(Metric.collectionViewHeight)
      .bottom(self.view.pin.safeArea.bottom)
    
    self.backgroundImageView.pin
      .verticallyBetween(topBarBottomLine, and: collectionView)
      .left()
      .right()
    
    self.svgView.pin
      .left(Metric.svgViewSide)
      .right(Metric.svgViewSide)
      .height(self.svgView.frame.width)
      .vCenter()
  }
  
  // MARK: - Binding
  func bind(reactor: Reactor) {
    
    self.collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    self.collectionView.rx.itemSelected
      .map { Reactor.Action.chooseSVG($0.row) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    self.closeButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.steps.accept(OverlayStep.dismiss)
      }).disposed(by: disposeBag)
    
    self.overlayButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        UIImageWriteToSavedPhotosAlbum(self.backgroundImageView.asImage(), self, #selector(self.saveCompleted), nil)
      }).disposed(by: disposeBag)
    
    reactor.state.map { $0.imageSection }
      .distinctUntilChanged()
      .bind(to: self.collectionView.rx.items(dataSource: self.collectionDataSource))
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.backgroundImage }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        let option = PHImageRequestOptions()
        option.version = .current
        option.isNetworkAccessAllowed = true
        self.cacheManager.requestImage(for: $0, targetSize: .zero, contentMode: .aspectFill, options: option) { [weak self] image, _ in
          self?.backgroundImageView.image = image
        }
      }).disposed(by: disposeBag)
    
    reactor.state.map { $0.selectedImage }
      .distinctUntilChanged()
      .bind(to: self.svgView.rx.image)
      .disposed(by: disposeBag)
  }
  
  @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    let alert = UIAlertController(title: "이미지 저장 성공!", message: nil, preferredStyle: .alert)
    let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in self?.steps.accept(OverlayStep.dismiss) }
    alert.addAction(action)
    self.present(alert, animated: true)
  }
  
}

// MARK: - UITableView Extension
extension OverlayViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: Metric.collectionViewCellSize, height: Metric.collectionViewCellSize)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return Metric.collectionInteritemSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: Metric.collectionMarginTop, left: Metric.collectionMarginSide, bottom: Metric.collectionMarginTop, right: Metric.collectionMarginSide)
  }
  
}

extension UIView {
  func asImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
}
