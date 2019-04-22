//
//  TextCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 21/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
    var ParentView:UIViewController? = nil
    @IBOutlet var TextDisplayField: UITextView!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.TextDisplayField.delegate = self
       // let TapController = UITapGestureRecognizer(target: self, action: #selector(showText))
      //  self.TextDisplayField.addGestureRecognizer(TapController)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func showText() {
      
    }
}
