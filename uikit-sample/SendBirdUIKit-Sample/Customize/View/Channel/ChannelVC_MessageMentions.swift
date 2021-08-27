//
//  ChannelVC_MessageParam.swift
//  SendBirdUIKit-Sample
//
//  Created by Tez Park on 2020/07/04.
//  Copyright © 2020 SendBird, Inc. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChannelVC_MessageMentions: SBUChannelViewController {
  
  // MARK:- Views
  
  private var suggestionsMessageInputView: SuggestionsMessageInputView? {
    messageInputView as? SuggestionsMessageInputView
  }
  
  // MARK:- Properties
  
  var userIDsToMention: [String] = []
  
  // MARK: - Lifecycle
  
  override func loadView() {
    messageInputView = SuggestionsMessageInputView()
    super.loadView()
  }
  
  override func messageInputView(_ messageInputView: SBUMessageInputView, didSelectSend text: String) {
    guard text.count > 0 else { return }
    let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let messageParam = SBDUserMessageParams(message: text) else { return }
    messageParam.mentionedUserIds = userIDsToMention

    self.sendUserMessage(messageParams: messageParam)
    userIDsToMention = []
  }

  func matches(for regex: String, in text: String) -> [String] {
    do {
      let regex = try NSRegularExpression(pattern: regex)
      let results = regex.matches(
        in: text,
        range: NSRange(text.startIndex..., in: text)
      )
      return results.map {
        String(text[Range($0.range, in: text)!])
      }
    } catch let error {
      print("invalid regex: \(error.localizedDescription)")
      return []
    }
  }
  
  func messageDidChange(_ messageInputView: SBUMessageInputView) {
    
    suggestionsMessageInputView?.mentionsSuggestionsView.suggestedUsers = channel?.members?.sbu_convertUserList()
    
    if let text = messageInputView.textView?.text {
      let mentionPattern = #"\B@\S+"#
      let mentionResult = matches(for: mentionPattern, in: text)
      // let hasMentions = (mentionResult.count > 0)
      userIDsToMention = mentionResult.map { String($0.dropFirst()) }
    } else {
      userIDsToMention = []
    }
  }
}

extension ChannelVC_MessageMentions { // SBUMessageInputViewDelegate
  
  override func messageInputViewDidStartTyping() {
    super.messageInputViewDidStartTyping()
    suggestionsMessageInputView?.showSuggestions()
  }
  
  override func messageInputViewDidEndTyping() {
    super.messageInputViewDidEndTyping()
    suggestionsMessageInputView?.hideSuggestions()
  }
}
