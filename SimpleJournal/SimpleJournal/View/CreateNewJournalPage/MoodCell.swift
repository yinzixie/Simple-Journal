//
//  MoodCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 21/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class MoodCell: UITableViewCell, PassMoodDataToCell{

    var ParentView:UIViewController? = nil
    
    @IBOutlet var MoodImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        MoodImageView.image = UIImage(named: "MoodNone")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func showCollectionView(_ sender: Any) {
        
        //jump to admin page through segue"showMoodCollectionSegue"
        ParentView?.performSegue(withIdentifier:"showMoodCollectionSegue", sender: self)
        
    }
    
    func passMood(mood: String) {
        MoodImageView.image = UIImage(named: mood)
    }
}
