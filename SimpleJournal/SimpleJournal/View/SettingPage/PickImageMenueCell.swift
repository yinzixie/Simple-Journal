//
//  PickImageMenueCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 19/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class PickImageMenueCell: UITableViewCell {
    
    lazy var MenuView:UIView = {
        let view = UIView(frame: CGRect(x:15,y:0,width: self.frame.width, height: 50))
        return view
    }()
    
    lazy var Label: UILabel = {
        let label = UILabel(frame: CGRect(x:(45*screen.screenw)/CGFloat(screen.Xscreenw),y:0,width: self.frame.width, height: 50))
        label.textAlignment = .center
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        addSubview(MenuView)
        addSubview(Label)
        
    }

}
