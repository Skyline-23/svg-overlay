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
    
    static let tableMarginTop: CGFloat = 14
    static let tableMarginBottom: CGFloat = 14
    static let tableMarginSide: CGFloat = 0
    
    static let topBarHeight: CGFloat = 60
    static let topBarBottomLineHeight: CGFloat = 1
    
    static let titleLabelBottom: CGFloat = 16
    
    static let tableViewCellHeight: CGFloat = 84
  }
  
  fileprivate struct Font {
    static let titleFont = UIFont.systemFont(ofSize: 16, weight: .medium)
  }
  
  // MARK: - UI
  fileprivate let topBarView = UIView.init()
  fileprivate let topBarBottomLine = UIView().then {
    $0.backgroundColor = SVGOverlayUIAsset.overlayTopbarGray.color
  }
  fileprivate let titleLabel = UILabel().then {
    $0.font = Font.titleFont
    $0.textColor = .black
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
  
  fileprivate let tableView: UITableView = {
    let tableView = UITableView.init(frame: .zero, style: .plain)
    tableView.backgroundColor = .systemBackground
    tableView.register(AlbumSelectTableViewCell.self, forCellReuseIdentifier: "AlbumSelectTableViewCell")
    tableView.contentInset = UIEdgeInsets(top: Metric.tableMarginTop, left: Metric.tableMarginSide, bottom: Metric.tableMarginBottom, right: Metric.tableMarginSide)
    tableView.separatorStyle = .none
    return tableView
  }()
  
  lazy var collectionDataSource = RxCollectionViewSectionedAnimatedDataSource<Reactor.ImageSectionModel> { dataSource, collectionView, indexPath, item in
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoSelectCollectionViewCell", for: indexPath) as? PhotoSelectCollectionViewCell else { return UICollectionViewCell() }
    
    self.reactor?.photoService.loadImage(asset: item, size: CGSize(width: cell.frame.width, height: cell.frame.height)) {
      cell.assetImageView.image = $0
    }
    
    return cell
  }
  
  lazy var tableDataSource = RxTableViewSectionedAnimatedDataSource<Reactor.AlbumSectionModel> { dataSource, tableView, indexPath, item in
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumSelectTableViewCell", for: indexPath) as? AlbumSelectTableViewCell else { return UITableViewCell() }
    
    if let asset = item.coverAsset {
      self.reactor?.photoService.loadImage(asset: asset, size: CGSize(width: cell.frame.width, height: cell.frame.height)) {
        cell.albumImageView.image = $0
      }
    }
    cell.albumTitleLabel.text = item.name
    
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
    
    self.topBarBottomLine.addSubview(self.titleLabel)
    
    self.view.addSubview(self.collectionView)
    
    self.view.addSubview(self.tableView)
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
    
    self.titleLabel.pin
      .hCenter()
      .bottom(Metric.titleLabelBottom)
      .sizeToFit()
    
    self.collectionView.pin
      .below(of: self.topBarBottomLine)
      .left()
      .right()
      .bottom(self.view.pin.safeArea.bottom)
    
    self.tableView.pin
      .below(of: self.topBarBottomLine)
      .left()
      .right()
      .bottom(self.view.pin.safeArea.bottom)
    
  }
  
  // MARK: - Binding
  func bind(reactor: Reactor) {
    self.rx.viewDidLoad.asObservable()
      .map { Reactor.Action.fetchAlbum }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    self.collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    self.tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.imageSection }
      .distinctUntilChanged()
      .bind(to: self.collectionView.rx.items(dataSource: self.collectionDataSource))
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.albumSection }
      .distinctUntilChanged()
      .bind(to: self.tableView.rx.items(dataSource: self.tableDataSource))
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.title }
      .distinctUntilChanged()
      .bind(to: self.titleLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  
}

// MARK: - UITableView Extension
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
    return UIEdgeInsets(top: Metric.collectionMarginTop, left: Metric.collectionMarginSide, bottom: -Metric.collectionMarginTop, right: -Metric.collectionMarginSide)
  }
  
}

// MARK: - UICollectionView Extension
extension PhotoPickerViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Metric.tableViewCellHeight
  }
}
