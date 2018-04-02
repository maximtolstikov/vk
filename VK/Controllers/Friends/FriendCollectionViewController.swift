//
//  FriendCollectionViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 06/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import VK_ios_sdk
import RealmSwift

class FriendCollectionViewController: UICollectionViewController {
    
    var url_foto: String = ""
    var imageCell: Data? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        loadImage(url: url_foto)
    }
    
    //Загрузка изображения
    func loadImage(url: String) {
        
        let urlImage = URL(string: url)
        URLSession.shared.dataTask(with: urlImage!){(data, responds, error) in
            guard data != nil else {
                print("request whithout data")
                return}
            self.imageCell = data
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }.resume()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "frendCollectionCell", for: indexPath) as! FriendCollectionViewCell

        guard imageCell != nil else {return cell}
        cell.imageCollectionCell.image = UIImage(data: imageCell!)
   
        return cell
    }

}
