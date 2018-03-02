//
//  ToolBar.swift
//  SocialApp
//
//  Created by Siroson Mathuranga Sivarajah on 28/02/18.
//  Copyright © 2018 Siroson Mathuranga Sivarajah. All rights reserved.
//

import UIKit

class ToolBar: UIView {
    
    // MARK:- Properties
    
    private let images = [#imageLiteral(resourceName: "notes"), #imageLiteral(resourceName: "search"), #imageLiteral(resourceName: "add"), #imageLiteral(resourceName: "notification"), #imageLiteral(resourceName: "docs")]
    
    private var stackButtons = [UIButton]()
    
    private lazy var stack: UIStackView = {
        let s = UIStackView(frame: self.bounds)
        s.axis = .horizontal
        s.distribution = .fillEqually
        s.alignment = .fill
        s.spacing = 0
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return s
    }()
    
    
    // MARK:- Initializers
    
    override init(frame: CGRect) {
        self.init()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        
        // initialize view from staoryboard
        setup()
    }
}

// MARK:- Helper Methods

extension ToolBar {
    func setup() {
        // Setup base view behaviours
        topCornered()
        
        // Add stackview to base view
        addSubview(stack)
        
        // Add views in stack
        for (index, image) in images.enumerated() {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 0, y: 0, width: 125, height: 125)
            btn.setImage(image, for: .normal)
            btn.tag = index
            btn.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
            
            stackButtons.append(btn)
            stack.addArrangedSubview(btn)
        }
    }
    
    @objc func action(sender: UIButton) {
        // Loop through stack buttons and change tintcolor
        for (index, button) in stackButtons.enumerated() {
            let image = images[index].withRenderingMode(.alwaysTemplate)
            button.setImage(image, for: .normal)
            button.tintColor = button.tag == sender.tag ? UIColor.red : UIColor.black
        }
    }
}
