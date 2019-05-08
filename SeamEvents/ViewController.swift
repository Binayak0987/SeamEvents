//
//  ViewController.swift
//  SeamEvents
//
//  Created by Binayak Dash on 07/05/19.
//  Copyright © 2019 Binayak_Dash. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    //Array for retrived data
    var postData = [String]()
    // Limit used for setting the number of record to fetch
    var limit = 19
    
    @IBOutlet weak var dataCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataCollectionView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
        
        getNextRecords(toLimit: limit)
        
    }
    
    /* Get the records from Firebase Realtime Database */
    /* Data retrive according to the Limit-- how many records need for call*/
    
    
    func getNextRecords(toLimit :Int) {
        
        let ref = Database.database().reference().child("Posts")
        
        _ = ref.queryLimited(toFirst: UInt(toLimit)).observe(.value, with: { snapshot in
            
            self.postData.removeAll()
            for item in snapshot.children{
                self.postData.append((item as? DataSnapshot)?.value as? String ?? "")
            }
            print("Array is - \(self.postData)")
            //reload the collection view
            DispatchQueue.main.async(execute: {
                self.dataCollectionView.reloadData()
            })
            self.dataCollectionView.reloadData()
            
            
        })
    }
    
}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.cellData.text = self.postData[indexPath.row]
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 30.0 {
            limit += 10
            self.getNextRecords(toLimit: limit)
        }
    }
    
    
}

