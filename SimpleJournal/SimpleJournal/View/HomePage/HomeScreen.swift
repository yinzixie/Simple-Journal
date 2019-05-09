//
//  HomeScreen.swift
//  SimpleJournal
//
//  Created by yinzixie on 14/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//
import Foundation
import UIKit

class HomeScreen: UIViewController,TellHomePageCacheRefresh{
   
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    
    var journals:[Journal] = JournalListCache.JournalList
    
    var IsRefreshFromSelf = false
    
    let transition = CircularTransition()

    var ChoosenButton = UIButton.init(type: .custom)
    
    @IBOutlet var HeadPhoto: UIImageView!
    @IBOutlet var UserName: UILabel!
    @IBOutlet var SentenceLabel: UILabel!
    @IBOutlet var HomeTable: UITableView!
    @IBOutlet var TotalyPostLabel: UILabel!
    @IBOutlet var SharedLabel: UILabel!
    @IBOutlet var TodayPostLabel: UILabel!
    @IBOutlet var SettingButton: UIButton!
    
    lazy var refresher: UIRefreshControl = {
        let refreshController = UIRefreshControl()
        refreshController.tintColor = .red
        refreshController.addTarget(self, action: #selector(refreshDown), for: .valueChanged) // 添加事件
        return refreshController
    }()
  
    @objc func refreshDown(){
        JournalListCache.refresh()
        refresher.endRefreshing()
    }
    
    func remindHomePageCacheChanged() {
        print("Home page receive refresh")
        let indexPath = IndexPath(row:journals.count,section: 0)
        journals = JournalListCache.JournalList
        //refresh label
        setLabel()
        //refresh table
        HomeTable.beginUpdates()
        if(indexPath.row < journals.count){
            HomeTable.insertRows(at: [indexPath], with: .fade)
        }
        HomeTable.reloadData()
        HomeTable.endUpdates()
    }
    
    func remindHomePageDeleteAJournal(indexPathInTable:IndexPath) {
        print("Home page receive refresh")
        journals = JournalListCache.JournalList
        //refresh label
        setLabel()
        
        if(IsRefreshFromSelf){
            print(indexPathInTable)
            HomeTable.beginUpdates()
            HomeTable.deleteRows(at: [indexPathInTable], with: .automatic)
            HomeTable.endUpdates()
        }else {
            HomeTable.reloadData()
        }
        IsRefreshFromSelf = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        setHeadPhoto()
        
        //set delegate or journal list cache class
        JournalListCache.tellHomePageCacheRefresh = self
        
        //set label
        setLabel()
        setUserData()
        
        HomeTable.refreshControl = refresher
       // refreshAction.attributedTitle = NSAttributedString.init(string: "正在下拉刷新")  // 修改文字内容
       // self.HomeTable.addSubview(refreshAction) //添加//MARK- 下拉刷新
        
        //remove seperation from cell which doesn't contain data
        HomeTable.tableFooterView = UIView.init(frame: CGRect.zero)
        
        HomeTable.layer.borderWidth = 1
        HomeTable.layer.borderColor = UIColor.lightGray.cgColor
        //HeadPhoto.translatesAutoresizingMaskIntoConstraints = false //some say we should add this to disable auto layout but we don't need this here
       
         let verticalConstraint = NSLayoutConstraint(item: HeadPhoto, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 70*screen.screenh/CGFloat(screen.Xscreenh)) //set top alignment
        
        view.addConstraints([verticalConstraint])
        
        //hidden the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //water wave
       var headerView = ZFJWaveView(frame: CGRect(x: CGFloat(0), y: CGFloat(-20), width: CGFloat(self.view.frame.size.width), height: CGFloat(240) + 70*screen.screenh/CGFloat(screen.Xscreenh)))
        headerView.backgroundColor =  UIColor(red: 0/255, green: 141/255, blue: 206/255, alpha: 1.0)//UIColor(red: CGFloat(1.000), green: CGFloat(0.318), blue: CGFloat(0.129), alpha: CGFloat(1.00))
        headerView.waveBlock = {(_ currentY: CGFloat) -> Void in
            //print(currentY)
        }
        headerView.startWaveAnimation()
        
        view.addSubview(headerView)
        view.sendSubviewToBack(headerView)
        
    }

    
    //same as the top one
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }*/
    
    private func setUserData() {
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "USERNAME")
        let sentence = defaults.string(forKey: "SENTENCE")
        
        UserName.text = username
        SentenceLabel.text = sentence
    }
    
    private func setLabel() {
        var today_num: Int = 0
        var shared_num: Int = 0
        
        //Totaly post label
        TotalyPostLabel.text = String(journals.count)
        
        //shared label
        for journal in journals {
            if(journal.Shared == 1) {
                shared_num += 1
            }
        }
        SharedLabel.text = String(shared_num)
        
        //Today post label
        for journal in journals {
            if(DateInfo.currentYear() == journal.Year && DateInfo.currentMonth() == journal.Month && DateInfo.currentDay() == journal.Day) {
                today_num += 1
            }
        }
        TodayPostLabel.text = String(today_num)
    }
    
    
    public func setHeadPhoto() {
        if(AppFile.isJudgeFileOrFolderExists(folderName: AppFile.HeadPhotoFullPath as String)) {
            HeadPhoto?.image = UIImage(contentsOfFile: AppFile.HeadPhotoFullPath as String)?.toCircle()
        }else {
            HeadPhoto?.image = UIImage(named:"default")?.toCircle()
        }
        
        HeadPhoto?.layer.cornerRadius = HeadPhoto.frame.width/2
        HeadPhoto?.clipsToBounds = true
        
       // HeadPhoto?.layer.borderWidth = 2
       // HeadPhoto?.layer.borderColor = UIColor.blue.cgColor
        
        
        /*HeadPhoto.layer.borderWidth = 1
         HeadPhoto.layer.masksToBounds = false
         HeadPhoto.layer.borderColor = UIColor.black.cgColor
         HeadPhoto.layer.cornerRadius = HeadPhoto.frame.height/2
         HeadPhoto.clipsToBounds = true*/
    }
   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToEditJournalSegue" {
            let EditPage = segue.destination as! CreateNewJournalScreen
            EditPage.journal = sender as? Journal
            EditPage.EditMode = "Edit"
            
        }else if(segue.identifier == "fromHomeTableShowJournalSegue") {
            guard let DisplayPage = segue.destination as? JournalDisplayScreen else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedJournalCell = sender as? HomeJournalCell else {
                fatalError("Unexpected selected cell")
            }
            guard let indexPath = HomeTable.indexPath(for: selectedJournalCell) else {
                fatalError("The selected cell is not in table")
            }
            DisplayPage.journal = journals[indexPath.row]
            print("Going to show journal details")
        }else if (segue.identifier == "goToSettingScreenSegue") {
            ChoosenButton = SettingButton
            let secondVC = segue.destination as! SettingScreen
            secondVC.transitioningDelegate = self
            secondVC.modalPresentationStyle = .custom
            secondVC.tellHomePageChangeHeadPhoto = self
            secondVC.tellHomePageChangeUserDate = self
        }
    }
}

extension HomeScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journals.count 
    }
    
    //configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeJournalCell
       
        // Configure the cell...
        if let HomeTableCell = cell as? HomeJournalCell
        {
            var DayString = String(journals[indexPath.row].Day)
            if(journals[indexPath.row].Day < 10) {
                 DayString = "0" + String(journals[indexPath.row].Day)
            }
            HomeTableCell.DateLabel.text = DayString
            HomeTableCell.MonthLabel.text = Journal.MonthString[journals[indexPath.row].Month - 1]
            HomeTableCell.TitleLabel.text = journals[indexPath.row].Title
            HomeTableCell.ContentLabel.text = journals[indexPath.row].TextContent
            
            //add button event and tag
            HomeTableCell.ShareButton.tag = indexPath.row
            HomeTableCell.ShareButton.addTarget(self, action: #selector(shareJournal(sender:)), for: .touchUpInside)
            
            HomeTableCell.ContentLabel.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    @objc func shareJournal(sender: UIButton) {
        
        //get pics for journal
        let PicsIDList = database.selectPicsByJournal(journal: journals[sender.tag])
        
        let ActiveShareView = UIActivityViewController(activityItems: journals[sender.tag].generateShareList(picIDList:PicsIDList) as [Any], applicationActivities: nil)
        ActiveShareView.popoverPresentationController?.sourceView = self.view
        
        self.present(ActiveShareView,animated: true,completion: nil)
    
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }
    
   
    func deleteAction(at indexPath: IndexPath)->UIContextualAction {
        let action = UIContextualAction(style:.normal, title: "Delete") {(action, view, completion) in
            
            #warning("弹出确认窗口")
            self.IsRefreshFromSelf = true
            JournalListCache.deleteJournal(journal: self.journals[indexPath.row], indexPathInTable: indexPath)
            completion(true)
        }
        
        action.image = UIImage(named:"delete@250*250")?.resizeImage(60, opaque: false)
        action.backgroundColor = .red
        return action
    }
    
    func editAction(at indexPath: IndexPath)->UIContextualAction {
        let action = UIContextualAction(style:.normal, title: "Edit") {(action, view, completion) in
            
            //jump to admin page through segue"goToEditJournalSegue"
            self.performSegue(withIdentifier:"goToEditJournalSegue", sender: self.journals[indexPath.row])
            
            completion(true)
        }
        
        action.image = UIImage(named:"Edit")?.resizeImage(60, opaque: false)
        action.backgroundColor = .lightGray
        return action
    }
}

extension HomeScreen:TellHomePageChangeUserDate,TellHomePageChangeHeadPhoto {
    func updateData() {
        setUserData()
    }
    
    func updatePic() {
        setHeadPhoto()
    }
}

extension HomeScreen: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = ChoosenButton.center
        transition.circleColor = ChoosenButton.backgroundColor ?? UIColor.white
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = ChoosenButton.center
        transition.circleColor = ChoosenButton.backgroundColor ??  UIColor.white
        return transition
    }
    
    
}
