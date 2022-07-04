//
//  PhotoPickerViewController.swift
//  SVGOverlayApp
//
//  Created by 김부성 on 2022/07/04.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources
import RxKingfisher
import RxFlow
import Then

import SVGOverlayUI
import SVGOverlayKit

final class PhotoPickerViewController: BaseViewController, ReactorKit.View, RxFlow.Stepper {
  
  var steps: PublishRelay<Step> = .init()
  typealias Reactor = PhotoPickerReactor
  
  fileprivate struct Metric {
    static let collectionMarginTop: CGFloat = 24
    static let collectionMarginBottom: CGFloat = 24
    static let collectionMarginSide: CGFloat = 16
    static let collectionInteritemSpacing: CGFloat = 8
    static let collectionLineSpacing: CGFloat = 16
  }
  
  // MARK: - UI
  fileprivate let topBarView = UIView.init()
  fileprivate let topBarBottomLine = UIView().then {
    $0.backgroundColor = SVGOverlayUIAsset.overlayTopbarGray.color
  }
  
  fileprivate var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    
    layout.scrollDirection = .vertical
    layout.sectionInset = .zero
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .systemBackground
    cv.register(PhotoSelectCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoSelectCollectionViewCell")
    
    return cv
  }()
  
  lazy var dataSource = RxCollectionViewSectionedReloadDataSource<Reactor.ImageSectionModel> { dataSource, collectionView, indexPath, item in
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoSelectCollectionViewCell", for: indexPath) as? PhotoSelectCollectionViewCell else { return UICollectionViewCell() }
    
    self.reactor?.photoService.loadImage(asset: item, size: CGSize(width: cell.frame.width, height: cell.frame.height)) {
      cell.assetImageView.image = $0
    }
    
    return cell
  }
  
  
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
    
    self.view.addSubview(self.collectionView)
    
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    self.topBarView.pin
      .top(self.view.pin.safeArea.top)
      .left()
      .right()
      .height(60)
    
    self.topBarBottomLine.pin
      .below(of: self.topBarView)
      .left()
      .right()
      .height(1)
    
    self.collectionView.pin
      .below(of: self.topBarBottomLine)
      .left()
      .right()
      .bottom(self.view.pin.safeArea.bottom)
    
  }
  
  func bind(reactor: Reactor) {
    self.rx.viewDidLoad.asObservable()
      .map { Reactor.Action.fetchAlbum }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    self.collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.imageSection }
      .distinctUntilChanged()
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }
  
  
}

extension PhotoPickerViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width: CGFloat = ( UIScreen.main.bounds.width - Metric.collectionMarginSide * 2 - Metric.collectionInteritemSpacing * 2 ) / 3
    return CGSize(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return Metric.collectionLineSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return Metric.collectionInteritemSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: Metric.collectionMarginTop, left: Metric.collectionMarginSide, bottom: Metric.collectionMarginTop, right: Metric.collectionMarginSide)
  }
  
  //  //collection VC section 마진값
  //  func collectionCellUI(){
  //    let flowLayout: UICollectionViewFlowLayout
  //    flowLayout = UICollectionViewFlowLayout()
  //    flowLayout.sectionInset = UIEdgeInsets.init(top: Metric.spaceInterval , left: Metric.spaceInterval, bottom: 0, right: Metric.spaceInterval)
  //    self.collectionView.collectionViewLayout = flowLayout
  //  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ViewController_Preview: PreviewProvider {
  static var previews: some SwiftUI.View {
    PhotoPickerViewController(reactor: PhotoPickerReactor()).showPreview(.iPhoneSE2)
  }
}
#endif

