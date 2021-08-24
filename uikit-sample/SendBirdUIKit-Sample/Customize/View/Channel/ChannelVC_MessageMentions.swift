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
    if let text = messageInputView.textView?.text {
      let mentionPattern = #"\B@\S+"#
      let mentionResult = matches(for: mentionPattern, in: text)
      let hasMentions = (mentionResult.count > 0)

      print("mentions:", mentionResult)
      print("hasMentions: \(hasMentions)")
    }
  }
}
