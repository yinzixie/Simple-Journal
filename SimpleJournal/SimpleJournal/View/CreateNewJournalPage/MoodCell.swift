//
//  MoodCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 21/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class MoodCell: UITableViewCell{
    var ParentView:UIViewController? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func showCollectionView(_ sender: Any) {
        
        //jump to admin page through segue"goToSettingScreen"
        ParentView?.performSegue(withIdentifier:"showMoodCollection", sender: self)
        
    }
    
  /*  func setMood(mood: String) {
        print("this is ",mood)
    }*/
    
}
