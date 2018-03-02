//
//  UserDetailView.swift
//  SocialApp
//
//  Created by Siroson Mathuranga Sivarajah on 01/03/18.
//  Copyright © 2018 Siroson Mathuranga Sivarajah. All rights reserved.
//

import UIKit

protocol UserDetailViewDelegate: class {
    func isShowing(fullView: Bool)
    func didFollow(userDetail: UserDetail)
    func didChangePosition(y: CGFloat)
}

class UserDetailView: UIView {
    
    // MARK:- Types
    
    private struct LocalConstants {
        static let followingTag = 25
        static let notFollowingTag = 26
        
        static let initialHeight: CGFloat = 300.0
        static let followButtonColor = UIColor.red
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
    
    @IBOutlet private var mainContainerView: UIView!
    
    @IBOutlet private var namePlaceView: UIView!
    
    @IBOutlet private var stackView: UIStackView!
    
    @IBOutlet private var followButtonWidthConstraint: NSLayoutConstraint!
    
    // MARK:- Properties
    
    weak var delegate: UserDetailViewDelegate?
    
    private var userDetail: UserDetail! {
        didSet {
            followersLabel.text = userDetail.followers
            followingLabel.text = userDetail.following
            postsLabel.text = userDetail.posts
            nameLabel.text = userDetail.name
            placeLabel.text = userDetail.place
            aboutLabel.text = userDetail.about
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialSetup()
    }
}

// MARK:- Helper Methods

extension UserDetailView {
    /// Initial setup
    private func initialSetup() {
        // Add pan gesture to base view
        addGestureRecognizer(panGesture)
        
        // Set top cornered
        if mainContainerView != nil {
            mainContainerView.topCornered(radius: 35.0)
        }
        
        // CollectionView properties and behaviours setup
        setupPhotoCollectionView()
        
        // Setup follow button
        setupFollowButton()
    }
    
    /// Setup initial photos collection view behaviuors, proeprties and layouts.
    private func setupPhotoCollectionView() {
        // Skip incase collection view is nil
        if photosCollectionView == nil {
            return
        }
        
        // Setup datasource and layout behaviours
        photosCollectionView.dataSource = self
        
        if let layout = photosCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 125.0, height: 125.0)
        }
    }
    
    /// Setup initial follow button behaviors and properties.
    func setupFollowButton() {
        followButton.setImage(nil, for: .normal)
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = UIColor.clear
        followButton.tag = LocalConstants.notFollowingTag
        followButton.cornered(radius: followButton.bounds.height/2)
        followButton.addBorder(color: LocalConstants.followButtonColor)
    }
    
    /// Gets called from MainViewControler when new profile page is scrolled through.
    ///
    /// - Parameters:
    ///     - detail: The UserDetail model.
    ///
    func update(detail: UserDetail) {
        // Update UserDetail model and respective labels and update follow button state
        userDetail = detail
        userDetail.isFollowing ? shrinkFollowButton(animate: false) : expandFollowButton(animate: false)
    }
    
    /// Animates stackview position and alpha values.
    ///
    /// - Parameters:
    ///     - fade: This determines if labels should be animated fade in or fade out.
    ///
    func animateLabels(fade: Bool) {
        if fade {
            UIView.animate(withDuration: Constants.animationDuration, animations: {
                self.stackView.frame.origin.y = self.stackView.frame.origin.y + self.stackView.frame.size.height/2
                self.stackView.alpha = 0
                self.namePlaceView.frame.origin.y = self.namePlaceView.frame.origin.y + self.namePlaceView.frame.size.height/2
                self.namePlaceView.alpha = 0
            })
            
        } else {
            UIView.animate(withDuration: Constants.animationDuration, animations: {
                self.stackView.frame.origin.y = self.stackView.frame.origin.y - self.stackView.frame.size.height/2
                self.stackView.alpha = 1.0
                self.namePlaceView.frame.origin.y = self.namePlaceView.frame.origin.y - self.namePlaceView.frame.size.height/2
                self.namePlaceView.alpha = 1.0
            })
        }
    }
    
    /// Scaling animtion from a button with a title to squared image button.
    ///
    /// - Parameters:
    ///     - animate: This determines if buttton should be animated. Default is `true`.
    ///
    func shrinkFollowButton(animate: Bool = true) {
        followButton.tag = LocalConstants.followingTag
        followButton.setTitle(nil, for: .normal)
        followButton.backgroundColor = LocalConstants.followButtonColor
        
        self.followButtonWidthConstraint.constant = followButton.frame.size.height
        
        if animate {
            UIView.animate(withDuration: Constants.animationDuration, animations: {
                self.layoutIfNeeded()
            }, completion: { finished in
                self.followButton.setImage(#imageLiteral(resourceName: "follow"), for: .normal)
                self.userDetail.isFollowing = true
                self.delegate?.didFollow(userDetail: self.userDetail)
            })
        } else {
            self.followButton.setImage(#imageLiteral(resourceName: "follow"), for: .normal)
            self.userDetail.isFollowing = true
            self.delegate?.didFollow(userDetail: self.userDetail)
        }
    }
    
    /// Scaling animtion from an squared image button to button with a title.
    ///
    /// - Parameters:
    ///     - animate: This determines if buttton should be animated. Default is `true`.
    ///
    func expandFollowButton(animate: Bool = true) {
        followButton.tag = LocalConstants.notFollowingTag
        followButton.setImage(nil, for: .normal)
        followButton.backgroundColor = UIColor.clear
        
        self.followButtonWidthConstraint.constant = followButton.frame.size.height * 3
        
        if animate {
            UIView.animate(withDuration: Constants.animationDuration, animations: {
                self.layoutIfNeeded()
            }, completion: { finished in
                self.followButton.setTitle("Follow", for: .normal)
                self.userDetail.isFollowing = false
                self.delegate?.didFollow(userDetail: self.userDetail)
            })
        } else {
            self.followButton.setTitle("Follow", for: .normal)
            self.userDetail.isFollowing = false
            self.delegate?.didFollow(userDetail: self.userDetail)
        }
    }
}

// MARK:- Button Actions

extension UserDetailView {
    /// Follow button action, Will only do shrink/expand functionalities for now.
    ///
    /// - Parameters:
    ///     - sender: UIButton object.
    ///
    @IBAction func follow(sender: UIButton) {
        if sender.tag == LocalConstants.notFollowingTag {
            shrinkFollowButton()
            
        } else {
            expandFollowButton()
        }
    }
}

// MARK:- Pan Gesture

extension UserDetailView {
    /// This fuction is responsible for moving/panning detailed view. At the same time it will notifify `MainViewController` through delegate about the changes in position.
    ///
    /// - Parameters:
    ///     - sender: `UIPanGestureRecognizer` object thats passed on.
    ///
    @objc func move(sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
        
        let translation = sender.translation(in: self)
        view.center.y = view.center.y + translation.y
        
        if view.frame.origin.y <= AppDelegate.shared().window!.bounds.height - self.frame.size.height {
            view.frame.origin.y = AppDelegate.shared().window!.bounds.height - self.frame.size.height
        } else if view.frame.origin.y >= AppDelegate.shared().window!.bounds.height - LocalConstants.initialHeight {
            view.frame.origin.y = AppDelegate.shared().window!.bounds.height - LocalConstants.initialHeight
        }
        
        sender.setTranslation(CGPoint.zero, in: self)
        
        delegate?.didChangePosition(y: view.frame.origin.y)
        
        if sender.state == .ended {
            if view.frame.origin.y <= AppDelegate.shared().window!.center.y {
                UIView.animate(withDuration: Constants.animationDuration, animations: {
                    view.frame.origin.y = AppDelegate.shared().window!.bounds.height - self.frame.size.height
                    self.delegate?.didChangePosition(y: view.frame.origin.y)
                }, completion: { finished in
                    self.delegate?.isShowing(fullView: true)
                })
                
            } else {
                UIView.animate(withDuration: Constants.animationDuration, animations: {
                    view.frame.origin.y = AppDelegate.shared().window!.bounds.height - LocalConstants.initialHeight
                    self.delegate?.didChangePosition(y: view.frame.origin.y)
                }, completion: { finished in
                    self.delegate?.isShowing(fullView: false)
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
        return userDetail.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.thumbnail.image = UIImage(named: userDetail.photos[indexPath.row])
        return cell
    }
}
