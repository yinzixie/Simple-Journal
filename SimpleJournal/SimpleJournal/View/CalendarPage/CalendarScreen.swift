//
//  ClendarScreen.swift
//  SimpleJournal
//
//  Created by yinzixie on 27/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class CalendarScreen: UIViewController,TellCalendarPageCacheRefresh {
   
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    
    var DisplayJournals:[SearchJournalResultList] = []
    
    @IBOutlet var CalendarTable: UITableView!
    
    @IBOutlet var DatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Initial calendar page")
        
        JournalListCache.tellCalendarPageCacheRefresh = self
        getDisplayResult(date:DatePicker.date)
        DatePicker.addTarget(self, action: #selector(self.DateChanged(dataPicker:)), for: .valueChanged)
    }
    
    private func getDisplayResult(date:Date) {
        DisplayJournals = JournalListCache.getJournalByDate(date:date)
    }
    
    private func updateTable(date:Date) {
        DisplayJournals.removeAll()
        
        getDisplayResult(date:date)
        
        //CalendarTable.beginUpdates()
        CalendarTable.reloadData()
        //CalendarTable.endUpdates()
    }
    
    @objc func DateChanged(dataPicker:UIDatePicker) {
        updateTable(date:dataPicker.date)
    }
    
    func remindCalendarPageCacheChanged() {
        updateTable(date:DatePicker.date)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "fromCalendarPageShowJournalSegue") {
            guard let DisplayPage = segue.destination as? JournalDisplayScreen else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedJournalCell = sender as? CalendarTableCell else {
                fatalError("Unexpected selected cell")
            }
            guard let indexPath = CalendarTable.indexPath(for: selectedJournalCell) else {
                fatalError("The selected cell is not in table")
            }
            DisplayPage.journal = DisplayJournals[indexPath.row].journal
            print("Going to show journal details")
        }else if (segue.identifier == "fromCalendarGoToEditJournalSegue") {
            let EditPage = segue.destination as! CreateNewJournalScreen
            EditPage.journal = sender as? Journal
            EditPage.EditMode = "Edit"
        }
    }
}


extension CalendarScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DisplayJournals.count
    }
    
    //configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableCell", for: indexPath) as! CalendarTableCell
        
        // Configure the cell...
        if let CalendarTableCell = cell as? CalendarTableCell
        {
            let journal = DisplayJournals[indexPath.row].journal
            
            var DayString = String(journal.Day)
            if(journal.Day < 10) {
                DayString = "0" + String(journal.Day)
            }
            CalendarTableCell.DateLabel.text = DayString
            CalendarTableCell.MonthLabel.text = Journal.MonthString[journal.Month - 1]
            CalendarTableCell.TitleLabel.text = journal.Title
            CalendarTableCell.ContentLabel.text = journal.TextContent
            
            //add button event and tag
            CalendarTableCell.ShareButton.tag = indexPath.row
            CalendarTableCell.ShareButton.addTarget(self, action: #selector(shareJournal(sender:)), for: .touchUpInside)
            
            CalendarTableCell.ContentLabel.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    @objc func shareJournal(sender: UIButton) {
        
        //get pics for journal
        let PicsIDList = database.selectPicsByJournal(journal: DisplayJournals[sender.tag].journal)
        
        let ActiveShareView = UIActivityViewController(activityItems: DisplayJournals[sender.tag].journal.generateShareList(picIDList:PicsIDList) as [Any], applicationActivities: nil)
        ActiveShareView.popoverPresentationController?.sourceView = self.view
        
        self.present(ActiveShareView,animated: true,completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print(indexPath.row)
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }
    
    
    func deleteAction(at indexPath: IndexPath)->UIContextualAction {
        let action = UIContextualAction(style:.normal, title: "Delete") {(action, view, completion) in
            
            #warning("弹出确认窗口")
            
            JournalListCache.deleteJournal(journal: self.DisplayJournals[indexPath.row].journal, indexPathInTable: self.DisplayJournals[indexPath.row].indexPath)
            completion(true)
        }
        
        action.image = UIImage(named:"delete@250*250")?.resizeImage(60, opaque: false)
        action.backgroundColor = .red
        return action
    }
    
    func editAction(at indexPath: IndexPath)->UIContextualAction {
        let action = UIContextualAction(style:.normal, title: "Edit") {(action, view, completion) in
            
            //jump to admin page through segue"goToEditJournalSegue"
            self.performSegue(withIdentifier:"fromCalendarGoToEditJournalSegue", sender: self.DisplayJournals[indexPath.row].journal)
            
            completion(true)
        }
        
        action.image = UIImage(named:"Edit")?.resizeImage(60, opaque: false)
        action.backgroundColor = .lightGray
        return action
    }
}
