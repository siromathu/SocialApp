//
//  MainViewController.swift
//  SocialApp
//
//  Created by Siroson Mathuranga Sivarajah on 28/02/18.
//  Copyright © 2018 Siroson Mathuranga Sivarajah. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK:- Outlets
    
    @IBOutlet var profilesCollection: UICollectionView!
    
    @IBOutlet var userDetailView: UserDetailView!
    
    // MARK:- Propeties
    
    private var users = [UserDetail]()
    
    
    // MARK:- View Lidecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ronaldo = UserDetail(name: "Chris Ronaldo", posts: "135", followers: "869", following: "485", place: "France, Nantes", about: "Photographer, blogger, freelance journalist", profilePhoto: "ronaldo.jpg", photos: ["img_1.jpg", "img_2.jpg", "img_3.jpg", "img_4.jpg", "img_5.jpg"])
        let messi = UserDetail(name: "Lionel Messi", posts: "35", followers: "169", following: "285", place: "India, Chennai", about: "Software Developer", profilePhoto: "messi.jpg", photos: ["img_1.jpg", "img_2.jpg", "img_3.jpg", "img_4.jpg", "img_5.jpg"])
        let beckham = UserDetail(name: "David Beckham", posts: "35", followers: "169", following: "285", place: "India, Chennai", about: "Software Developer", profilePhoto: "ronaldo.jpg", photos: ["img_1.jpg", "img_2.jpg", "img_3.jpg", "img_4.jpg", "img_5.jpg"])
        let siro = UserDetail(name: "Siroson", posts: "35", followers: "169", following: "285", place: "India, Chennai", about: "Software Developer", profilePhoto: "messi.jpg", photos: ["img_1.jpg", "img_2.jpg", "img_3.jpg", "img_4.jpg", "img_5.jpg"])
        let brit = UserDetail(name: "Brito", posts: "35", followers: "169", following: "285", place: "India, Chennai", about: "Software Developer", profilePhoto: "ronaldo.jpg", photos: ["img_1.jpg", "img_2.jpg", "img_3.jpg", "img_4.jpg", "img_5.jpg"])
        users.append(ronaldo)
        users.append(messi)
        users.append(beckham)
        users.append(siro)
        users.append(brit)
        
        // Setup profiles collection view
        setupProfileCollectionView()
        
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
    func setupProfileCollectionView() {
        profilesCollection.delegate = self
        profilesCollection.dataSource = self
        
        profilesCollection.bounces = false
        profilesCollection.isPagingEnabled = true
        
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

// MARK:- ScrollView Delegate

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = profilesCollection.contentOffset.x / profilesCollection.frame.size.width
        userDetailView.update(detail: users[Int(currentIndex)])
    }
}
