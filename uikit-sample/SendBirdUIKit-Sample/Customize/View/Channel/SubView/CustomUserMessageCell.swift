//
//  CustomUserMessageCell.swift
//  SendBirdUIKit-Sample
//
//  Created by Tez Park on 2020/07/07.
//  Copyright © 2020 SendBird, Inc. All rights reserved.
//

import UIKit
import SendBirdSDK

class CustomUserMessageCell: SBUUserMessageCell {
  var bubbleImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleToFill
    return imageView
  }()

  override func setupStyles() {
    super.setupStyles()

    // TODO: This is not working consistently
    #warning("self.mainContainerView transparent background is not working consistently")
    self.mainContainerView.leftBackgroundColor = .clear
    self.mainContainerView.leftPressedBackgroundColor = .clear
    self.mainContainerView.rightBackgroundColor = .clear
    self.mainContainerView.rightPressedBackgroundColor = .clear

    switch self.position {
      case .left:
        bubbleImageView.image = getBubbleImage("chat_bubble_received")
      case .right:
        bubbleImageView.image = getBubbleImage("chat_bubble_sent")
      default:
        return
    }
  }

  override func setupViews() {
    super.setupViews()
    self.mainContainerView.insertSubview(bubbleImageView, at: 0)
  }

  override func setupAutolayout() {
    super.setupAutolayout()

    self.bubbleImageView.setConstraint(from: self.mainContainerView, leading: 0, trailing: 0, left: 0, right: 0, top: 0, bottom: 0, priority: .required)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    setCustomCornerRadius()
  }

  func getBubbleImage(_ name: String) -> UIImage? {
    guard let image = UIImage(named: name) else { return nil }

    let insets = self.position == .left
      ? UIEdgeInsets(top: 16, left: 27, bottom: 16, right: 16)
      : UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 27)

    return image.resizableImage(withCapInsets: insets, resizingMode: .stretch)
  }

  private func setCustomCornerRadius() {
    guard let layerToUpdate = messageTextView.superview?.superview?.layer else { return }

    layerToUpdate.cornerRadius = 0
  }
}
