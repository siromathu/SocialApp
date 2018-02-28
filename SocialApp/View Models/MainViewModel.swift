//
//  MainViewModel.swift
//  SocialApp
//
//  Created by Siroson Mathuranga Sivarajah on 28/02/18.
//  Copyright © 2018 Siroson Mathuranga Sivarajah. All rights reserved.
//

import Foundation
import UIKit

class MainViewModel: NSObject {
    
    // MARK:- Properties
    
    private var profilesCollection: UICollectionView!
    
    
    // MARK:- Initializers
    
    override init() {
        super.init()
    }
    
    convenience init(collectionView: UICollectionView) {
        self.init()
    }
}

