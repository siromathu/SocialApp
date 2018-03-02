//
//  Extensions.swift
//  SocialApp
//
//  Created by Siroson Mathuranga Sivarajah on 01/03/18.
//  Copyright © 2018 Siroson Mathuranga Sivarajah. All rights reserved.
//

import Foundation
import UIKit


// UIView

extension UIView {
    func cornered(radius: CGFloat = 15.0) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func topCornered(radius: CGFloat = 30.0) {
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        let roundedLayer = CAShapeLayer()
        roundedLayer.path = bezierPath.cgPath
        self.layer.mask = roundedLayer
    }
}
