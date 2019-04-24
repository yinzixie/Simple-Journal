//
//  HomeScreen.swift
//  SimpleJournal
//
//  Created by yinzixie on 14/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//
import Foundation
import UIKit

class HomeScreen: UIViewController {

    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    
    var journals:[Journal] = JournalListCache.JournalList
    
    @IBOutlet var HeadPhoto: UIImageView!
    @IBOutlet var UserName: UILabel!
    @IBOutlet var HomeTable: UITableView!
    @IBOutlet var TotalyPostLabel: UILabel!
    @IBOutlet var SharedLabel: UILabel!
    @IBOutlet var TodayPostLabel: UILabel!
    
    lazy var refresher: UIRefreshControl = {
        let refreshController = UIRefreshControl()
        refreshController.tintColor = .red
        refreshController.addTarget(self, action: #selector(refreshDown), for: .valueChanged) // 添加事件
        return refreshController
    }()
  
    @objc func refreshDown(){
        let indexPath = IndexPath(row:journals.count,section: 0)
        journals = database.selectAllJournal()
        //refresh label
        setLabel()
        //refresh table
        HomeTable.beginUpdates()
        if(indexPath.row < journals.count){
            HomeTable.insertRows(at: [indexPath], with: .automatic)
        }
        HomeTable.reloadData()
        HomeTable.endUpdates()
        refresher.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        setHeadPhoto()
        
        //get journals from db
        journals = database.selectAllJournal()
        
        //set label
        setLabel()
        
        HomeTable.refreshControl = refresher
       // refreshAction.attributedTitle = NSAttributedString.init(string: "正在下拉刷新")  // 修改文字内容
       // self.HomeTable.addSubview(refreshAction) //添加//MARK- 下拉刷新
        
        //remove seperation from cell which doesn't contain data
        HomeTable.tableFooterView = UIView.init(frame: CGRect.zero)
        
        HomeTable.layer.borderWidth = 1
        HomeTable.layer.borderColor = UIColor.lightGray.cgColor
        //HeadPhoto.translatesAutoresizingMaskIntoConstraints = false //some say we should add this to disable auto layout but we don't need this here
       
         let verticalConstraint = NSLayoutConstraint(item: HeadPhoto, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 812/screen.screenh*100) //812 iphone x height //set top alignment
        
        view.addConstraints([verticalConstraint])
        
        //hidden the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //water wave
       var headerView = ZFJWaveView(frame: CGRect(x: CGFloat(0), y: CGFloat(-20), width: CGFloat(self.view.frame.size.width), height: CGFloat(320)))
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
    
    private func setLabel() {
        var today_num: Int = 0
        TotalyPostLabel.text = String(journals.count)
        #warning("share num")
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
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension HomeScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journals?.count ?? 0
    }
    
    //configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeJournalCell
       
        // Configure the cell...
        if let HomeTableCell = cell as? HomeJournalCell
        {
            HomeTableCell.DateLabel.text = String(journals[indexPath.row].Day)
            HomeTableCell.MonthLabel.text = Journal.MonthString[journals[indexPath.row].Month - 1]
            HomeTableCell.TitleLabel.text = journals[indexPath.row].Title
            HomeTableCell.ContentLabel.text = journals[indexPath.row].TextContent
            HomeTableCell.ContentLabel.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }
    
   
    func deleteAction(at indexPath: IndexPath)->UIContextualAction {
        let action = UIContextualAction(style:.normal, title: "Delete") {(action, view, completion) in
            
            #warning("弹出确认窗口")
            
            if(self.database.deleteJournal(journal: self.journals[indexPath.row])) {
                self.journals.remove(at: indexPath.row)
                self.HomeTable.beginUpdates()
                self.HomeTable.deleteRows(at: [indexPath], with: .automatic)
                self.HomeTable.endUpdates()
            }
            completion(true)
        }
        
        action.image = UIImage(named:"delete@250*250")?.resizeImage(60, opaque: false)
        action.backgroundColor = .red
        return action
    }
    
    func editAction(at indextPath: IndexPath)->UIContextualAction {
        let action = UIContextualAction(style:.normal, title: "Edit") {(action, view, completion) in
            
            completion(true)
        }
        
        action.image = UIImage(named:"edit@120*120")?.resizeImage(60, opaque: false)
        action.backgroundColor = .lightGray
        return action
    }
    
   
}
