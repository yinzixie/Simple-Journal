//
//  JournalListScreen.swift
//  SimpleJournal
//
//  Created by yinzixie on 14/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class JournalListScreen: UIViewController,TellManagementPageCacheRefresh {
    
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    
    var DisplayJournals:[SearchJournalResultList] = []

    var Searching = false
    
    var IsRefreshFromSelf = false
    
    @IBOutlet var SearchBar: UISearchBar!
    @IBOutlet var JournalList: UITableView!
    
    func remindManagementPageCacheChanged() {
        if(!Searching) {
            print("Management Page receive refresh,now not in searching modle")

            DisplayJournals = JournalListCache.getAllJournalsInResultListForm()
            JournalList.reloadData()
        }else {
            print("Management Page receive refresh,now in searching modle")
            
            DisplayJournals = JournalListCache.searchJournalByString(text: SearchBar.text ?? "")
            JournalList.reloadData()
        }
    }
    
    func remindManagementPageDeleteAJournal(indexPathInTable:IndexPath) {
        if(Searching) {
            print("Management Page receive refresh,now in searching modle")
            DisplayJournals = JournalListCache.searchJournalByString(text: SearchBar.text ?? "")
        }else {
            print("Management Page receive refresh, now not in searching modle")
            DisplayJournals = JournalListCache.getAllJournalsInResultListForm()
        }
        
        if(!IsRefreshFromSelf) {
            JournalList.reloadData()
        }
        IsRefreshFromSelf = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Initial Management Page")
        JournalListCache.tellManagementPageCacheRefresh = self
        JournalListCache.refresh()
        
        //hidden the navigation bar navigationController?.setNavigationBarHidden(true, animated: false)
        
       // var emitter:CAEmitterLayer? = particleEffect(UIImage(named: "snow")!, viewlayer: view)
        
        //emitter!.birthRate = 0
        
        DisplayJournals = JournalListCache.getAllJournalsInResultListForm()
        
        //remove seperation from cell which doesn't contain data
        JournalList.tableFooterView = UIView.init(frame: CGRect.zero)
        
        JournalList.layer.borderWidth = 0.5
        JournalList.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func particleEffect(_ image:UIImage,viewlayer: UIView) -> CAEmitterLayer {
        let rect = CGRect(x: 0.0, y: -70.0, width: view.bounds.width,
                          height: 50.0)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        viewlayer.layer.addSublayer(emitter)
        
        emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
        
        //kCAEmitterLayerPoint
        //kCAEmitterLayerLine
        //kCAEmitterLayerRectangle
        let point = CGPoint(x: rect.width/2, y: rect.height/2)
        emitter.emitterPosition = point
        emitter.emitterSize = rect.size
        
        let emitterCell = CAEmitterCell()
        
        emitterCell.contents = image.cgImage
        emitterCell.birthRate = 60  //每秒产生120个粒子
        emitterCell.lifetime = 3    //存活1秒
        emitterCell.lifetimeRange = 3.0
        
        emitterCell.yAcceleration = 30.0  //给Y方向一个加速度
        emitterCell.xAcceleration = 10.0 //x方向一个加速度
        emitterCell.velocity = 10.0 //初始速度
        emitterCell.emissionLongitude = CGFloat(-Double.pi) //向左
        emitterCell.velocityRange = 100.0   //随机速度 -200+20 --- 200+20
        emitterCell.emissionRange = CGFloat(Double.pi/2) //随机方向 -pi/2 --- pi/2
        //emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0,
        //   alpha: 1.0).CGColor //指定颜色
        emitterCell.redRange = 0.3
        emitterCell.greenRange = 0.3
        emitterCell.blueRange = 0.3  //三个随机颜色
        
       // emitterCell.color         = UIColor.lightGray.cgColor
        
        emitterCell.scale = 0.8
        emitterCell.scaleRange = 0.8  //0 - 1.6
        emitterCell.scaleSpeed = -0.15  //逐渐变小
        
        emitterCell.alphaRange = 0.75   //随机透明度
        emitterCell.alphaSpeed = -0.15  //逐渐消失
        
        
        emitter.emitterShape = .line
        emitter.emitterCells = [emitterCell]  //这里可以设置多种粒子 我们以一种为粒子
        return emitter
    }
    
   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "fromManagementTableShowJournalSegue") {
            guard let DisplayPage = segue.destination as? JournalDisplayScreen else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedJournalCell = sender as? JournalCellWithPic else {
                fatalError("Unexpected selected cell")
            }
            guard let indexPath = JournalList.indexPath(for: selectedJournalCell) else {
                fatalError("The selected cell is not in table")
            }
            DisplayPage.journal = DisplayJournals[indexPath.row].journal
            print("Going to show journal details")
            
        }else if(segue.identifier == "fromManagementEditJournalSegue") {
                print("Going to edit journal")
                let EditPage = segue.destination as! CreateNewJournalScreen
                EditPage.journal = sender as? Journal
                EditPage.EditMode = "Edit"
        }
    }
   
}


extension JournalListScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DisplayJournals.count
    }
    
    //configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var journal = journas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCellWithPic", for: indexPath) as! JournalCellWithPic
        
        if let JournalListCell = cell as? JournalCellWithPic
        {
            //set journal
            JournalListCell.loadJournal(journal: DisplayJournals[indexPath.row].journal)
            
            //add button event and tag
            JournalListCell.DeleteButton.tag = indexPath.row
            JournalListCell.DeleteButton.addTarget(self, action: #selector(deleteJournal(sender:)), for: .touchUpInside)
            
            JournalListCell.EditButton.tag = indexPath.row
            JournalListCell.EditButton.addTarget(self, action: #selector(editJournal(sender:)), for: .touchUpInside)
            
            JournalListCell.ShareButton.tag = indexPath.row
            JournalListCell.ShareButton.addTarget(self, action: #selector(shareJournal(sender:)), for: .touchUpInside)
            
            //disable selected effect
            JournalListCell.selectionStyle = UITableViewCell.SelectionStyle.none
          
            // var emitter:CAEmitterLayer? = particleEffect(UIImage(named: "snow30")!,viewlayer: JournalListCell)
            //JournalListCell.allowsTransparency = true
        }
        
        return cell
    }
    
    @objc func deleteJournal(sender: UIButton) {
        print("Press mangement table cell's delete button ")
        let IndexPathInFulltable = DisplayJournals[sender.tag].indexPath
        
        let indexPathForSelfTable = IndexPath(row: sender.tag, section: 0)
        
        IsRefreshFromSelf = true
        print(IndexPathInFulltable)
        
        JournalListCache.deleteJournal(journal: DisplayJournals[sender.tag].journal, indexPathInTable:IndexPathInFulltable)
        
        JournalList.beginUpdates()
        JournalList.deleteRows(at: [indexPathForSelfTable], with: .fade)
        JournalList.endUpdates()
    }
    
    @objc func editJournal(sender: UIButton) {
        print("Press mangement table cell's edit button ")
        let IndexRow = sender.tag //indexpath.row
        performSegue(withIdentifier: "fromManagementEditJournalSegue", sender: self.DisplayJournals[IndexRow].journal)
    }
    
    @objc func shareJournal(sender: UIButton) {
        print("Press mangement table dell's share button ")
        let IndexRow = sender.tag //indexpath.row
        
    }
    
    private func getDisplayResult(text:String) {
        DisplayJournals = JournalListCache.searchJournalByString(text: text)
    }
    
    private func updateTable(text:String) {
        DisplayJournals.removeAll()
        
        getDisplayResult(text: text)
        
        JournalList.reloadData()
    }
    
}

extension JournalListScreen: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "") {
            DisplayJournals = JournalListCache.getAllJournalsInResultListForm()
            JournalList.reloadData()
            Searching = false
            //print(Searching)
        }else {
            DisplayJournals = JournalListCache.searchJournalByString(text: searchText)
            JournalList.reloadData()
            Searching = true
            //print(Searching)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        DisplayJournals = JournalListCache.getAllJournalsInResultListForm()
        JournalList.reloadData()
        Searching = false
        //print(Searching)
    }
}
