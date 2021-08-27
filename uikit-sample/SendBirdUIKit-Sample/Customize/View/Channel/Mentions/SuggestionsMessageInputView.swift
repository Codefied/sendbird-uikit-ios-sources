//
//  SuggestionsMessageInputView.swift
//  SendBirdUIKit-Sample
//
//  Created by Robert Sobolewski on 26/08/2021.
//  Copyright © 2021 SendBird, Inc. All rights reserved.
//

import UIKit

final class SuggestionsMessageInputView: SBUMessageInputView {
  
  // MARK: - Views
  
  private(set) lazy var mentionsSuggestionsView = { Subviews.mentionsSugestionsView }()
  
  // MARK: - Initialization
  
  init() {
    super.init(frame: .zero)
    setupSelf()
  }
  
  // MARK: - Setup
  
  private func setupSelf() {
    mentionsSuggestionsView.isUserInteractionEnabled = true
  }
  
  func showSuggestions() {
    if mentionsSuggestionsView.superview == nil {
      inputHStackView.addSubview(mentionsSuggestionsView)
      mentionsSuggestionsView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        mentionsSuggestionsView.bottomAnchor.constraint(equalTo: inputHStackView.topAnchor, constant: -4.0),
        mentionsSuggestionsView.leadingAnchor.constraint(equalTo: inputHStackView.leadingAnchor),
        mentionsSuggestionsView.trailingAnchor.constraint(equalTo: inputHStackView.trailingAnchor),
        mentionsSuggestionsView.heightAnchor.constraint(equalToConstant: 140.0)
      ])
      mentionsSuggestionsView.alpha = 0.0
      UIView.animate(withDuration: 0.1) { [weak mentionsSuggestionsView] in
        mentionsSuggestionsView?.alpha = 1.0
      }
    }
  }
  
  func hideSuggestions() {
    if mentionsSuggestionsView.superview != nil {
      UIView.animate(withDuration: 0.1) { [weak mentionsSuggestionsView] in
        mentionsSuggestionsView?.alpha = 0.0
      } completion: { [weak mentionsSuggestionsView] _ in
        mentionsSuggestionsView?.removeFromSuperview()
      }
    }
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    if isPoint(point, inside: mentionsSuggestionsView, with: event) {
      let convertedPoint = convert(point, to: mentionsSuggestionsView)
      return mentionsSuggestionsView.hitTest(convertedPoint, with: event)
    } else {
      return super.hitTest(point, with: event)
    }
  }
}

private enum Subviews {
  static var mentionsSugestionsView: MessageUserMentionsSuggestionsView {
    MessageUserMentionsSuggestionsView()
  }
}
