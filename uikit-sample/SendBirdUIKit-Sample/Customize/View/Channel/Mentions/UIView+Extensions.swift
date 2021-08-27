//
//  UIView+Extensions.swift
//  SendBirdUIKit-Sample
//
//  Created by Robert Sobolewski on 27/08/2021.
//  Copyright © 2021 SendBird, Inc. All rights reserved.
//

import UIKit.UIView

extension UIView {
  func isPoint(_ point: CGPoint, inside subview: UIView, with event: UIEvent?) -> Bool {
    guard subview.isUserInteractionEnabled else { return false }
    guard subview.superview != nil else { return false }
    guard !subview.isHidden else { return false }
    return subview.point(inside: convert(point, to: subview), with: event)
  }
}
