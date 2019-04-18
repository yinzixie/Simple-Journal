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

    @IBOutlet var HeadPhoto: UIImageView!
    @IBOutlet var UserName: UILabel!
    

    
    @IBOutlet var HomeTable: UITableView!
    
    
    
    let screenh = UIScreen.main.bounds.size.height
    let screenw = UIScreen.main.bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(screenh, screenw)
       
        // Do any additional setup after loading the view.
        
        setHeadPhoto()
        
        //remove seperation from cell which doesn't contain data
        HomeTable.tableFooterView = UIView.init(frame: CGRect.zero)
        
        HomeTable.layer.borderWidth = 1
        HomeTable.layer.borderColor = UIColor.lightGray.cgColor //HeadPhoto.translatesAutoresizingMaskIntoConstraints = false //some say we should add this to disable auto layout but we don't need this here
       
         let verticalConstraint = NSLayoutConstraint(item: HeadPhoto, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 812/screenh*100) //812 iphone x height //set top alignment
        
        view.addConstraints([verticalConstraint])
        
        //hidden the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    //same as the top one
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }*/
    
   
    
    
    private func setHeadPhoto() {
        HeadPhoto?.image = UIImage(named:"2")?.toCircle()
        
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
        #warning("记得修改这里 table的元素数量")
        return 3
    }
    
    //configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeJournalCell
       
         #warning("记得修改这里 table的content")
        // Configure the cell...
        if let HomeTableCell = cell as? HomeJournalCell
        {
            HomeTableCell.DateLabel.text = "30"
            HomeTableCell.MonthLabel.text = "Mar"
            HomeTableCell.TitleLabel.text = "Title"
            HomeTableCell.ContentLabel.text = "Loeff sdfjh sdfefn sdfsdf..."
            HomeTableCell.ContentLabel.isUserInteractionEnabled = false
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }
    
   
    func deleteAction(at indextPath: IndexPath)->UIContextualAction {
        let action = UIContextualAction(style:.normal, title: "Delete") {(action, view, completion) in
            
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
