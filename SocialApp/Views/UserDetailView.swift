//
//  UserDetailView.swift
//  SocialApp
//
//  Created by Siroson Mathuranga Sivarajah on 01/03/18.
//  Copyright © 2018 Siroson Mathuranga Sivarajah. All rights reserved.
//

import UIKit

class UserDetailView: UIView {
    
    // MARK:- Types
    
    private struct LocalConstants {
        static let initialHeight: CGFloat = 310.0
    }
    
    // MARK:- Outlets
    
    @IBOutlet private var photosCollectionView: UICollectionView!
    
    @IBOutlet private var followersLabel: UILabel!
    
    @IBOutlet private var postsLabel: UILabel!
    
    @IBOutlet private var followingLabel: UILabel!
    
    @IBOutlet private var nameLabel: UILabel!
    
    @IBOutlet private var placeLabel: UILabel!
    
    @IBOutlet private var aboutLabel: UILabel!
    
    @IBOutlet private var followButton: UIButton!
    
    @IBOutlet private var containerView: UIView!
    
    // MARK:- Properties
    
    private var userDetail: UserDetail? {
        didSet {
            followersLabel.text = userDetail?.followers
            followingLabel.text = userDetail?.following
            postsLabel.text = userDetail?.posts
            nameLabel.text = userDetail?.name
            placeLabel.text = userDetail?.place
            aboutLabel.text = userDetail?.about
        }
    }
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(move(sender:)))
        return pan
    }()
    
    // MARK:- Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSetup()
    }
}

// MARK:- Helper Methods

extension UserDetailView {
    private func initialSetup() {
        
        // Setup properties and behaviours
//        frame.origin.y = AppDelegate.shared().window!.bounds.height - LocalConstants.initialHeight
        
        if containerView != nil {
            containerView.topCornered(radius: 35.0)
        }
        
        // Add pan gesture to base view
        addGestureRecognizer(panGesture)
        
        // CollectionView properties and behaviours setup
        setupPhotoCollectionView()
    }
    
    private func setupPhotoCollectionView() {
        if photosCollectionView == nil {
            return
        }
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        if let layout = photosCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 125.0, height: 125.0)
        }
    }
    
    func update(detail: UserDetail) {
        userDetail = detail
    }
}

// MARK:- Pan Gesture

extension UserDetailView {
    @objc func move(sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
        
        let translation = sender.translation(in: self)
        view.center.y = view.center.y + translation.y
        
        if view.frame.origin.y <= 200 {
            view.frame.origin.y = 200
        } else if view.frame.origin.y >= AppDelegate.shared().window!.bounds.height - LocalConstants.initialHeight {
            view.frame.origin.y = AppDelegate.shared().window!.bounds.height - LocalConstants.initialHeight
        }
        
        sender.setTranslation(CGPoint.zero, in: self)
        
        if sender.state == .ended {
            if view.frame.origin.y <= AppDelegate.shared().window!.center.y {
                UIView.animate(withDuration: 0.3, animations: {
                    view.frame.origin.y = 200
                })
                
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    view.frame.origin.y = AppDelegate.shared().window!.bounds.height - LocalConstants.initialHeight
                })
            }
        }
    }
}

// MARK:- Collection View

extension UserDetailView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let userDetail = userDetail else { return 0 }
        return userDetail.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        if let userDetail = userDetail {
            cell.thumbnail.image = UIImage(named: userDetail.photos[indexPath.row])
        }
        
        return cell
    }
}

extension UserDetailView: UICollectionViewDelegate {
    
}
