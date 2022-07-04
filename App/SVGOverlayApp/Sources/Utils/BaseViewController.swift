//
//  BaseViewController.swift
//  SocarAssignmentApp
//
//  Created by 김부성 on 2022/06/07.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
  
  // MARK: - UI
  
  // MARK: - Initializing
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Rx
  var disposeBag = DisposeBag.init()
  
  // MARK: - View Life Cycle
  deinit {
    print("deinit : \(type(of: self)): \(#function)")
  }
  
  // MARK: - Layout Constraint
  private(set) var didSetupConstraints = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.setNeedsUpdateConstraints()
    
    self.setupLayout()
    self.setupStyle()
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupConstraints()
  }
  
  func setupLayout() {
    // add Views
    
  }
  
  func setupConstraints() {
    // Constraints
    
  }
  
  func setupLocalization() {
    // localizations
  }
  
  // MARK: - Setup
  fileprivate func setupStyle() {
    self.view.backgroundColor = .white
  }
  
}
  
