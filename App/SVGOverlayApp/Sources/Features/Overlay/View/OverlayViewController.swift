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
  }
  
  fileprivate struct Font {
    static let titleFont = UIFont.systemFont(ofSize: 16, weight: .medium)
  }
  
  // MARK: - UI
  fileprivate let topBarView = UIView.init()
  fileprivate let topBarBottomLine = UIView().then {
    $0.backgroundColor = SVGOverlayUIAsset.Colors.overlayTopbarGray.color
  }
  fileprivate let backgroundImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
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
    
    self.view.addSubview(self.topBarBottomLine)
    
    self.topBarView.addSubview(self.backgroundImageView)
    
    self.view.addSubview(self.collectionView)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    self.topBarView.pin
      .top(self.view.pin.safeArea.top)
      .left()
      .right()
      .height(Metric.topBarHeight)
    
    self.topBarBottomLine.pin
      .below(of: self.topBarView)
      .left()
      .right()
      .height(Metric.topBarBottomLineHeight)
    
    self.collectionView.pin
      .left()
      .right()
      .height(150)
      .bottom(self.view.pin.safeArea.bottom)
    
    self.backgroundImageView.pin
      .below(of: topBarBottomLine)
      .above(of: collectionView)
      .left()
      .right()
    
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
    
    reactor.state.map { $0.imageSection }
      .distinctUntilChanged()
      .bind(to: self.collectionView.rx.items(dataSource: self.collectionDataSource))
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.backgroundImage }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.cacheManager.requestImage(for: $0, targetSize: CGSize(width: self.backgroundImageView.frame.width * UIScreen.main.scale, height: self.backgroundImageView.frame.height * UIScreen.main.scale), contentMode: .aspectFill, options: nil) { [weak self] image, _ in
          self?.backgroundImageView.image = image
        }
      }).disposed(by: disposeBag)
  }
  
}

// MARK: - UITableView Extension
extension OverlayViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 80, height: 80)
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
