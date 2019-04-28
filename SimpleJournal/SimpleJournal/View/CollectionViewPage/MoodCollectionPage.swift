//
//  CollectionView.swift
//  SimpleJournal
//
//  Created by yinzixie on 23/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

protocol PassMoodData {
    func passMood(mood:String)
}
protocol PassMoodDataToCell {
    //func passMood(mood:String)
}

class MoodCollectionPage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var passMoodData: PassMoodData?
    var ChoosenMood: String = "MoodNone"
    
    let Moods = MoodList.Moods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Moods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoodCollectionCell", for: indexPath) as! MoodCollectionCell
        
        // Configure the cell...
        if let MoodCell = cell as? MoodCollectionCell
        {
            MoodCell.MoodLabel.text = Moods[indexPath.item]
            MoodCell.MoodImageView.image =  UIImage(contentsOfFile: AppFile.getMoodImageFullPath(imageName: Moods[indexPath.item]))
            MoodCell.layer.cornerRadius = 5
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.backgroundColor = UIColor.gray.cgColor
        
        self.ChoosenMood = Moods[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
        cell?.layer.backgroundColor = UIColor.white.cgColor
        //cell?.layer.borderColor = UIColor.lightGray.cgColor
    }
    @IBAction func saveAndBack(_ sender: Any) {
        passMoodData?.passMood(mood:ChoosenMood)
        self.dismiss(animated: true, completion: nil)
    }
}
