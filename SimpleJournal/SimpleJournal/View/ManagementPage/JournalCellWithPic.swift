//
//  JournalCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 14/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class JournalCellWithPic: UITableViewCell {

    var parentView:JournalListScreen?
    
    var journal:Journal!
    
    @IBOutlet var BackGroundCardView: UIView!
    
    @IBOutlet var YearLabel: UILabel!
    @IBOutlet var DateLabel: UILabel!
    @IBOutlet var MonthLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ContentLabel: UITextView!
    @IBOutlet var MoodView: UIImageView!
    @IBOutlet var ImageView: UIImageView!
    
    @IBOutlet var WeatherView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        BackGroundCardView.backgroundColor = UIColor.white
        BackGroundCardView.layer.cornerRadius = 3.0
        BackGroundCardView.layer.masksToBounds = false
        BackGroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        BackGroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        BackGroundCardView.layer.shadowOpacity = 0.8
        
        
        
        var DayString = String(journal.Day)
        if(journal.Day < 10) {
            DayString = "0" + String(journal.Day)
        }
        YearLabel.text = String(journal.Year)
        DateLabel.text = DayString
       MonthLabel.text = Journal.MonthString[journal.Month - 1]
        TitleLabel.text = journal.Title
        ContentLabel.text = journal.TextContent
       WeatherView.image = UIImage(named:journal.Weather)
        ImageView.image = UIImage(contentsOfFile: AppFile.getImageFullPath(imageName: journal.DisplayPic))
        MoodView.image = UIImage(named:journal.Mood)
        ContentLabel.isUserInteractionEnabled = false
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func editJournal(_ sender: Any) {
        
        //jump segue"fromManagementEditJournalSegue"
        parentView?.performSegue(withIdentifier:"fromManagementEditJournalSegue", sender: journal)
        
    }
    
    @IBAction func deleteJournal(_ sender: Any) {
        #warning("弹出确认窗口")
        
        JournalListCache.deleteJournal(journal: parentView?.journals[self.indexPath.row], indexPathInTable:indexPathh)
        
    }
}
