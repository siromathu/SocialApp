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
    
    @IBOutlet var photosCollection: UICollectionView!
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet var followers: UILabel!
    
    @IBOutlet var posts: UILabel!
    
    @IBOutlet var following: UILabel!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var place: UILabel!
    
    @IBOutlet var about: UILabel!
    
    // MARK:- Propeties
    
    private var users = [UserDetails]()
    
    
    // MARK:- View Lidecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lori = UserDetails(name: "Lori Perez", posts: "135", followers: "869", following: "485", place: "France, Nantes", about: "Photographer, blogger, freelance journalist", profilePhoto: "ronaldo.jpg", photos: ["img_1.jpg", "img_2.jpg", "img_3.jpg", "img_4.jpg", "img_5.jpg"])
        let siro = UserDetails(name: "Siroson", posts: "35", followers: "169", following: "285", place: "India, Chennai", about: "Software Developer", profilePhoto: "messi.jpg", photos: ["img_1.jpg", "img_2.jpg", "img_3.jpg", "img_4.jpg", "img_5.jpg"])
        users.append(lori)
        users.append(siro)
        
        setupProfileCollectionView()
        setupPhotoCollectionView()
        setupUserDetails(index: 0)
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
    
    func setupPhotoCollectionView() {
        photosCollection.delegate = self
        photosCollection.dataSource = self
        
        if let layout = photosCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 125.0, height: 125.0)
//            layout.minimumLineSpacing = 0
//            layout.minimumInteritemSpacing = 0
        }
    }
    
    func setupUserDetails(index: Int) {
        followers.text = users[index].followers
        posts.text = users[index].posts
        following.text = users[index].following
        name.text = users[index].name
        place.text = users[index].place
        about.text = users[index].about
    }
}


// MARK:- Collection View

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == profilesCollection {
            return users.count
        }
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == profilesCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
            cell.profileImage.image = UIImage(named: users[indexPath.row].profilePhoto)
            
//            if indexPath.row % 2 == 0 {
//                cell.backgroundColor = UIColor.blue
//            } else {
//                cell.backgroundColor = UIColor.green
//            }
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
            return cell
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if heightConstraint.constant == 130.0 {
            heightConstraint.constant = 304.0
        } else {
            heightConstraint.constant = 130.0
        }
    }
}

// MARK:- ScrollView Delegate

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = profilesCollection.contentOffset.x / profilesCollection.frame.size.width
        print(currentIndex)
        setupUserDetails(index: Int(currentIndex))
    }
}
