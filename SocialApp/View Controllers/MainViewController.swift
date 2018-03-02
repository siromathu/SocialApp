//
//  MainViewController.swift
//  SocialApp
//
//  Created by Siroson Mathuranga Sivarajah on 28/02/18.
//  Copyright © 2018 Siroson Mathuranga Sivarajah. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK:- Types
    
    private struct LocalConstants {
        static let userDetailViewShortHeight: CGFloat = 295.0
        static let userDetailViewFullHeight: CGFloat = 560.0
    }
    
    // MARK:- Outlets
    
    @IBOutlet var profilesCollection: UICollectionView!
    
    @IBOutlet var userDetailView: UserDetailView!
    
    // MARK:- Propeties
    
    private var users = [UserDetail]()
    
    private var oldIndex = 0
    
    
    // MARK:- View Lidecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dummy data for presention
        let ronaldo = UserDetail(id: 1, name: "Chris Ronaldo", posts: "135", followers: "869", following: "485", place: "Portugal, Lisbon", about: "Football Player, Model", profilePhoto: "ronaldo.jpg", photos: ["img_1.jpg", "img_2.jpg", "img_3.jpg", "img_4.jpg", "img_5.jpg"], isFollowing: false)
        let tom = UserDetail(id: 3, name: "Tom Cruise", posts: "374", followers: "5784", following: "654", place: "India, Chennai", about: "Actor, Writer, Dancer", profilePhoto: "tom.jpg", photos: ["img_1.jpg", "img_2.jpg", "img_3.jpg", "img_4.jpg", "img_5.jpg"], isFollowing: false)
        let lewis = UserDetail(id: 4, name: "Lewis Hamilton", posts: "20", followers: "420", following: "285", place: "United Kingdom, Lanchanshire", about: "Formula 1 Racer, Model", profilePhoto: "lewis.jpg", photos: ["img_1.jpg", "img_2.jpg", "img_3.jpg", "img_4.jpg", "img_5.jpg"], isFollowing: false)
        let messi = UserDetail(id: 2, name: "Lionel Messi", posts: "204", followers: "1045", following: "156", place: "Argentina, Buenos Aires", about: "Football Player, Golfer, Human Rights Activists", profilePhoto: "messi.jpg", photos: ["img_1.jpg", "img_2.jpg", "img_3.jpg", "img_4.jpg", "img_5.jpg"], isFollowing: false)
        let nolan = UserDetail(id: 5, name: "Christopher Nolan", posts: "987", followers: "2492", following: "354", place: "United Kingdom, London", about: "Director, Producer, Script Writer", profilePhoto: "nolan.jpg", photos: ["img_1.jpg", "img_2.jpg", "img_3.jpg", "img_4.jpg", "img_5.jpg"], isFollowing: false)
        users.append(ronaldo)
        users.append(tom)
        users.append(lewis)
        users.append(messi)
        users.append(nolan)
        
        // Setup profiles collection view
        setupProfileCollectionView()
        
        // Setup delegate, initial `y` position and disable autolayout contraints behaviours
        userDetailView.delegate = self
        userDetailView.translatesAutoresizingMaskIntoConstraints = true
        userDetailView.frame.origin.y = view.frame.size.height - LocalConstants.userDetailViewShortHeight
        
        // Update userdetail view with first user's details
        if !users.isEmpty {
            userDetailView.update(detail: users.first!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK:- Helper Methods

extension MainViewController {
    
    /// Setup Profiles collection view.
    func setupProfileCollectionView() {
        // Setup delegate and datasource
        profilesCollection.delegate = self
        profilesCollection.dataSource = self
        
        // Enable paging property for page control look and feel.
        profilesCollection.isPagingEnabled = true
        
        // Tweak layout behaviours
        if let layout = profilesCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = view.frame.size
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }
}


// MARK:- Collection View

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        cell.profileImage.image = UIImage(named: users[indexPath.row].profilePhoto)
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}

// MARK:- ScrollView Delegate

extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Fade out detail labels irrespective of index
        userDetailView.animateLabels(fade: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Fade in detail labels only if different page is moved to and also update label details
        userDetailView.animateLabels(fade: false)
        let currentIndex = Int(profilesCollection.contentOffset.x / profilesCollection.frame.size.width)
        if oldIndex != currentIndex {
            oldIndex = currentIndex
            userDetailView.update(detail: users[Int(currentIndex)])
        }
    }
}


// MARK:- UserDetailView Delegate

extension MainViewController: UserDetailViewDelegate {
    
    /// Disable/enable profiles collection view user interaction property.
    ///
    /// - Parameters:
    ///     - fullView: If fullView is `true` disable user interaction and vice versa.
    ///
    func isShowing(fullView: Bool) {
        // Disable user interaction of Collection view if full user detail view is presented. It avoids some awkward animations
        profilesCollection.isUserInteractionEnabled = !fullView
    }
    
    /// Update/replace new/updated user detail model.
    ///
    /// - Parameters:
    ///     - userDetail: UserDetail model thats passed on.
    ///
    func didFollow(userDetail: UserDetail) {
        // Update users with new userdetail if follow button is clicked.
        for (index, user) in users.enumerated() {
            if user.id == userDetail.id {
                users.remove(at: index)
                users.insert(userDetail, at: index)
                break
            }
        }
    }
    
    /// Updated bottom constraint of profile image inside cell.
    ///
    /// - Parameters:
    ///     - y: the `y` position that the user detail view is currently moved to.
    ///
    func didChangePosition(y: CGFloat) {
        let cell = profilesCollection.cellForItem(at: NSIndexPath(item: oldIndex, section: 0) as IndexPath) as! ProfileCollectionViewCell
        cell.profileImageBottomConstraint.constant = (self.view.frame.size.height - LocalConstants.userDetailViewShortHeight) - y
        UIView.animate(withDuration: 0.0) {
            self.view.layoutIfNeeded()
        }
    }
}
