//
//  MessageUserMentionSuggestionsTableViewDelegate.swift
//  SendBirdUIKit-Sample
//
//  Created by Robert Sobolewski on 25/08/2021.
//  Copyright © 2021 SendBird, Inc. All rights reserved.
//

import UIKit.UICollectionView
import Combine

final class MessageUserMentionSuggestionsTableViewDelegate: NSObject, UITableViewDelegate {
  
  // MARK: - Delegate
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath)
  }
}
