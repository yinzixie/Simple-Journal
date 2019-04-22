//
//  DateCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 21/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {
    
    var ParentView:UIViewController? = nil
    @IBOutlet var YearDisplayButton: UIButton!
    @IBOutlet var DateDisplayButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func chooseYear(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Year", message: "Choose Year")
        
        let YearRange = [Int](1980...2200)
        let pickerViewValues: [[String]] = [YearRange.map { Int($0).description }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: YearRange.index(of: DateInfo.currentYear()) ?? 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            self.YearDisplayButton.setTitle(String(YearRange[index.row]), for: .normal)
        }
        alert.addAction(title: "Done", style: .cancel)
        ParentView?.present(alert, animated: true)
        
    }
    
    @IBAction func chooseDate(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Select date")
        alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: nil, maximumDate: nil) {date in
            // action with selected date
            self.DateDisplayButton.setTitle(DateInfo.dateToDateString(date, dateFormat: "MM-dd hh:mm:ss"), for: .normal)
        }
        alert.addAction(title: "OK", style: .cancel)
        ParentView?.present(alert, animated: true)
    }
}
