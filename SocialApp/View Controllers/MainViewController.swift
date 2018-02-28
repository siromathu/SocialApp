//
//  MainViewController.swift
//  SocialApp
//
//  Created by Siroson Mathuranga Sivarajah on 28/02/18.
//  Copyright © 2018 Siroson Mathuranga Sivarajah. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK:- Propeties
    
    @IBOutlet var profilesCollection: UICollectionView!
    
    
    // MARK:- View Lidecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK:- Helper Methods

extension MainViewController {
    func setupCollectionView() {
        profilesCollection.delegate = self
        profilesCollection.dataSource = self
    }
}


// MARK:- Collection View

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.blue
        } else {
            cell.backgroundColor = UIColor.green
        }
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.frame.size
    }
}
