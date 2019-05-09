//
//  MyTabBar.swift
//  SimpleJournal
//
//  Created by yinzixie on 14/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class MyTabBar: UITabBarController {
    
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    let transition = CircularTransition()
    

    @IBOutlet var MytabBar: UITabBar!
    
    let CreateButton = UIButton.init(type: .custom)
    let SettingButton = UIButton.init(type: .custom)
    
    var ChoosenButton = UIButton.init(type: .custom)
    
    private let radarAnimation = "radarAnimation"
    private var animationLayer: CALayer?
    private var animationGroup: CAAnimationGroup?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init file system
        AppFile.init()
        //set button
        setCretateNewJournalButton()
        setSettingButton()
        disableCentreTabBarIteam()
        
        
        //AppFile.saveMoodPhoto(image: UIImage(named: "1")!, imageName: "test")
        //print(AppFile.isJudgeFileOrFolderExists(folderName: AppFile.MoodsFolderFullPath.appending("fuck") as String))
        //print(AppFile.getDomcumentAllFolder())//AppFile.getFileListInFolderWithPath(path: AppFile.ImagesFolderFullPath as String))
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe place to set the frame of button manually
        CreateButton.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 104*screen.screenh/CGFloat(screen.Xscreenh), width: 64, height: 64)
        CreateButton.layer.cornerRadius = 32
        
        //
        SettingButton.frame = CGRect.init(x: self.view.bounds.width-50 , y: 50*screen.screenh/CGFloat(screen.Xscreenh), width: 32, height: 32)
        SettingButton.layer.cornerRadius = 16
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //set Setting Button
    private func setSettingButton() {
        SettingButton.setBackgroundImage(UIImage(named:"setting"), for:.normal)
        //add button to screen
        self.view.insertSubview(SettingButton, aboveSubview: self.tabBar)
        
        //set trigger event go to create journal screen when realse button
        SettingButton.addTarget(self, action: #selector(goToSettingScreen), for: .touchUpInside)
    }
    
    @objc func goToSettingScreen() {
    //jump to admin page through segue"goToSettingScreen"
        self.performSegue(withIdentifier:"goToSettingScreenSegue", sender: self)
    }
    
    //create center button(create a new journal) and add animation
    private func setCretateNewJournalButton() {
        //CreateButton.setTitle("New", for:.normal)
        //CreateButton.setTitleColor(.black, for: .normal)
        //CreateButton.setTitleColor(.red, for: .highlighted)
        //CreateButton.frame = CGRect(x:100, y:0, width: 44, height: 44)
        CreateButton.backgroundColor = .orange
        //CreateButton.layer.borderWidth = 4
        //CreateButton.layer.borderColor = UIColor.red.cgColor
        
        CreateButton.setBackgroundImage(UIImage(named:"tabbar_add_yellow"), for:.normal)
        //add button to screen
        self.view.insertSubview(CreateButton, aboveSubview: self.tabBar)
        //set trigger event add animation when press down
        CreateButton.addTarget(self, action: #selector(startAction), for: .touchDown)
        //set trigger event go to create journal screen when realse button
        CreateButton.addTarget(self, action: #selector(goToCreateJournalScreen), for: .touchUpInside)
        
        //add animation
        let first = makeRadarAnimation(showRect: CGRect(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 104*screen.screenh/CGFloat(screen.Xscreenh), width: 64, height: 64), isRound: true)    //位置和大小
        view.layer.addSublayer(first)
        self.animationLayer?.removeAnimation(forKey: self.radarAnimation)
        
    }
    
    //disable centre tabbar item
    private func disableCentreTabBarIteam() {
        if let arrayOfTabBarItems = self.tabBar.items as AnyObject as? NSArray,let
            tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
            tabBarItem.isEnabled = false
        }
    }

    //动作-开始
    @objc func startAction() {
        animationLayer?.add(animationGroup!, forKey: radarAnimation)
    }
    //go to create journal page
    @objc func goToCreateJournalScreen() {
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //jump to admin page through segue"backToPatientTableSegue"
            self.performSegue(withIdentifier:"goToCreateNewJournalSegue", sender: self)
            //self.animationLayer?.removeAnimation(forKey: self.radarAnimation)
        //}
    }
    
    
    
    private func makeRadarAnimation(showRect: CGRect, isRound: Bool) -> CALayer {
        // 1. 一个动态波
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = showRect
        // showRect 最大内切圆
        
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: showRect.width, height: showRect.height)).cgPath
        
        shapeLayer.fillColor = UIColor.orange.cgColor    //波纹颜色
        
        shapeLayer.opacity = 0.0    // 默认初始颜色透明度
        
        animationLayer = shapeLayer
        
        // 2. 需要重复的动态波，即创建副本
        let replicator = CAReplicatorLayer()
        replicator.frame = shapeLayer.bounds
        replicator.instanceCount = 4
        replicator.instanceDelay = 1.0
        replicator.addSublayer(shapeLayer)
        
        // 3. 创建动画组
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(floatLiteral: 0.3)  // 开始透明度
        opacityAnimation.toValue = NSNumber(floatLiteral: 0)      // 结束时透明底
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        if isRound {
            scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0))      // 缩放起始大小
        } else {
            scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 0))      // 缩放起始大小
        }
        scaleAnimation.toValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 2.0, 2.0, 0))      // 缩放结束大小
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [opacityAnimation, scaleAnimation]
        animationGroup.duration = 3.0       // 动画执行时间
        animationGroup.repeatCount = 2//HUGE   // 最大重复
        animationGroup.autoreverses = false
        
        self.animationGroup = animationGroup
        
        shapeLayer.add(animationGroup, forKey: radarAnimation)
        
        return replicator
    }
}

extension MyTabBar: UIViewControllerTransitioningDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "goToCreateNewJournalSegue" {
            ChoosenButton = CreateButton
            let secondVC = segue.destination as! CreateNewJournalScreen
            secondVC.journal = Journal()
            secondVC.transitioningDelegate = self
            secondVC.modalPresentationStyle = .custom
            secondVC.EditMode = "Create"
        }else if segue.identifier == "goToSettingScreenSegue" {
            ChoosenButton = SettingButton
            let secondVC = segue.destination as! SettingScreen
            secondVC.transitioningDelegate = self
            secondVC.modalPresentationStyle = .custom
        }
       
    }
    
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
        self.startAction()
        return transition
    }
    
    
}
