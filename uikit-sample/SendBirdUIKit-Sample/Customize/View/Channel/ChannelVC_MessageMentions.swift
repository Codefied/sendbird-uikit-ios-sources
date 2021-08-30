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
  
  private var membersNicknames: Set<String> {
    guard let members = channel?.members as? [SBDMember] else { return Set<String>([]) }
    let membersNicknames = members.compactMap { $0.nickname }
    return Set<String>(membersNicknames)
  }
  
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
      userIDsToMention = mentionResult.map { String($0.dropFirst()) }
      guard let textStorage = messageInputView.textView?.textStorage else { return }
      
      func removeAttributes() {
        textStorage.removeAttribute(.foregroundColor, range: NSMakeRange(0, textStorage.length))
        textStorage.removeAttribute(.backgroundColor, range: NSMakeRange(0, textStorage.length))
      }
      
      func addAttributes(in range: NSRange) {
        textStorage.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        textStorage.addAttribute(.backgroundColor, value: UIColor.systemTeal, range: range)
      }
      
      if !userIDsToMention.isEmpty {
        let mentionsCandidates = Set<String>(userIDsToMention.map { $0.lowercased() })
        let mentions = mentionsCandidates.intersection(membersNicknames.map { $0.lowercased() })
          
        if !mentions.isEmpty {
          textStorage.beginEditing()
          removeAttributes()
          for mention in mentions {
            textStorage.string.ranges(of: "@\(mention)", options: .caseInsensitive).forEach { range in
              addAttributes(in: NSRange(range, in: textStorage.string))
            }
          }
          textStorage.endEditing()
        } else {
          removeAttributes()
        }
      } else {
        removeAttributes()
      }
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
