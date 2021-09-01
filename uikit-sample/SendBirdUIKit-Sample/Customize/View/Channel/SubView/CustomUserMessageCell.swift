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

    #warning("self.mainContainerView transparent background is not working consistently")
    self.mainContainerView.leftBackgroundColor = .clear
    self.mainContainerView.leftPressedBackgroundColor = .clear
    self.mainContainerView.rightBackgroundColor = .clear
    self.mainContainerView.rightPressedBackgroundColor = .clear
  }

  override func setupViews() {
    super.setupViews()
    self.mainContainerView.insertSubview(bubbleImageView, at: 0)

    #warning("Find a way to override SBUUserMessageTextView -> Metric -> textLeftRightMargin to 23.f")
  }

  override func setupAutolayout() {
    super.setupAutolayout()

    self.bubbleImageView.setConstraint(from: self.mainContainerView, leading: 0, trailing: 0, left: 0, right: 0, top: 0, bottom: 0, priority: .required)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    setCustomCornerRadius()
  }

  override func setMessageGrouping() {
    guard SBUGlobals.UsingMessageGrouping else { return }
    // Show sender profiles also
    self.profileView.isHidden = false
    let profileImageView = (self.profileView as? SBUMessageProfileView)?.imageView
    let timeLabel = (self.stateView as? SBUMessageStateView)?.timeLabel

    self.contentsStackView.arrangedSubviews.forEach(
      self.contentsStackView.removeArrangedSubview(_:)
    )

    switch self.position {
      case .left:
        self.userNameStackView.alignment = .leading
        self.bubbleImageView.image = getBubbleImage("chat_bubble_received")
        self.contentsStackView.addArrangedSubview(self.profileView)
        self.contentsStackView.addArrangedSubview(self.mainContainerView)
        self.contentsStackView.addArrangedSubview(self.stateView)

      case .right:
        self.userNameStackView.alignment = .trailing
        self.bubbleImageView.image = getBubbleImage("chat_bubble_sent")
        self.contentsStackView.addArrangedSubview(self.stateView)
        self.contentsStackView.addArrangedSubview(self.mainContainerView)
        self.contentsStackView.addArrangedSubview(self.profileView)

      case .center:
        break
    }

    switch self.groupPosition {
      case .top:
        self.userNameView.isHidden = self.position == .right
        self.bubbleImageView.image = self.position == .right
          ? getBubbleImage("chat_bubble_sent_tailless")
          : getBubbleImage("chat_bubble_received_tailless")
        profileImageView?.isHidden = true
        timeLabel?.isHidden = true
      case .middle:
        self.userNameView.isHidden = true
        self.bubbleImageView.image = self.position == .right
          ? getBubbleImage("chat_bubble_sent_tailless")
          : getBubbleImage("chat_bubble_received_tailless")
        profileImageView?.isHidden = true
        timeLabel?.isHidden = true
      case .bottom:
        self.userNameView.isHidden = true
        profileImageView?.isHidden = false
        timeLabel?.isHidden = false
      case .none:
        self.userNameView.isHidden = self.position == .right
        profileImageView?.isHidden = false
        timeLabel?.isHidden = false
    }

    self.updateTopAnchorConstraint()
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
