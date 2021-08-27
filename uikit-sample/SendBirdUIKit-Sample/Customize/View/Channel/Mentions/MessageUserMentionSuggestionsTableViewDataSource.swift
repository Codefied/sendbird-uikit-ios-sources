//
//  MessageUserMentionSuggestionsTableViewDataSource.swift
//  SendBirdUIKit-Sample
//
//  Created by Robert Sobolewski on 25/08/2021.
//  Copyright © 2021 SendBird, Inc. All rights reserved.
//

import UIKit.UICollectionView

final class MessageUserMentionSuggestionsTableViewDataSource: NSObject, UITableViewDataSource {
  
  // MARK: - Properties
  
  var suggestedUsers = [SBUUser]()
  
  // MARK: - Data source

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    suggestedUsers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SBUUserCell.self), for: indexPath)
    if let cell = cell as? SBUUserCell, suggestedUsers.indices.contains(indexPath.row) {
      let suggestedUser = suggestedUsers[indexPath.row]
      cell.configure(type: .channelMembers, user: suggestedUser)
    }
    return cell
  }
}
