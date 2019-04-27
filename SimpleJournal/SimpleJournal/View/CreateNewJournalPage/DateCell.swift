//
//  DateCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 21/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

protocol PassDateData {
    func passDate(date: Date)
}
class DateCell: UITableViewCell {
    
    var ParentView:UIViewController? = nil
  
    var passDate: PassDateData?
    
    @IBOutlet var DateTextField: UITextField!
    
    var datePicker: UIDatePicker?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        datePicker  = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(self.dateChanged(dataPicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TextTap(gestureRecognizer:)))
        ParentView?.view.addGestureRecognizer(tapGesture)
        DateTextField.inputView = datePicker
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func dateChanged(dataPicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd  HH:mm:ss"
        
        DateTextField.text = dateFormatter.string(from: datePicker!.date)
        
        passDate?.passDate(date: datePicker!.date)
        print("select")
        ParentView?.view.endEditing(true)
    }
    
    @objc func TextTap(gestureRecognizer: UITapGestureRecognizer) {
        
         ParentView?.view.endEditing(true)
    }
}
