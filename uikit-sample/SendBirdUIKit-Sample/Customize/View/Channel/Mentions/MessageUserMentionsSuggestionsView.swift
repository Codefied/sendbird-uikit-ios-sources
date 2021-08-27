//
//  MessageUserMentionsSuggestionsView.swift
//  SendBirdUIKit-Sample
//
//  Created by Robert Sobolewski on 25/08/2021.
//  Copyright © 2021 SendBird, Inc. All rights reserved.
//

import UIKit

final class MessageUserMentionsSuggestionsView: UIView {
  
  // MARK: - Views
  
  private let mentionsSuggestionsTableView = Subviews.mentionsSuggestionsTableView
  
  // MARK: - Properties
  
  var suggestedUsers: [SBUUser]? {
    didSet {
      mentionsSuggestionsTableViewDataSource.suggestedUsers = suggestedUsers ?? []
      mentionsSuggestionsTableView.reloadData()
    }
  }
  
  private let mentionsSuggestionsTableViewDataSource = MessageUserMentionSuggestionsTableViewDataSource()
  private let mentionsSuggestionsTableViewDelegate = MessageUserMentionSuggestionsTableViewDelegate()
  
  // MARK: - Initialization
  
  init() {
    super.init(frame: .zero)
    setupSelf()
    setupLayout()
    setupCollectionView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    return nil
  }
  
  // MARK: - Setup
  
  private func setupSelf() {
    backgroundColor = .white
    layer.borderColor = UIColor.gray.cgColor
    layer.borderWidth = 0.5
    layer.cornerRadius = 8.0
    clipsToBounds = true
  }
  
  private func setupLayout() {
    addSubview(mentionsSuggestionsTableView)
    mentionsSuggestionsTableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mentionsSuggestionsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
      mentionsSuggestionsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
      mentionsSuggestionsTableView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
      mentionsSuggestionsTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8.0)
    ])
  }
  
  private func setupCollectionView() {
    mentionsSuggestionsTableView.dataSource = mentionsSuggestionsTableViewDataSource
    mentionsSuggestionsTableView.delegate = mentionsSuggestionsTableViewDelegate
  }
}

private enum Subviews {
  static var mentionsSuggestionsTableView: UITableView {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.backgroundColor = .clear
    tableView.alwaysBounceVertical = true
    tableView.register(SBUUserCell.self, forCellReuseIdentifier: String(describing: SBUUserCell.self))
    return tableView
  }
}
