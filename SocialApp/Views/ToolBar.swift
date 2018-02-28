//
//  ToolBar.swift
//  SocialApp
//
//  Created by Siroson Mathuranga Sivarajah on 28/02/18.
//  Copyright © 2018 Siroson Mathuranga Sivarajah. All rights reserved.
//

import UIKit

class ToolBar: UIStackView {
    
    // MARK:- Properties
    
    
    
    // MARK:- Initializers
    
    override init(frame: CGRect) {
        self.init()
    }
    
    convenience init(frame: CGRect, images: [UIImage]) {
        self.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- Helper Methods

extension ToolBar {
    func setup() {
        
    }
}
