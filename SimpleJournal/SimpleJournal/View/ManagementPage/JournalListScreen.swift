//
//  JournalListScreen.swift
//  SimpleJournal
//
//  Created by yinzixie on 14/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class JournalListScreen: UIViewController {

  
    @IBOutlet var JournalList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hidden the navigation bar navigationController?.setNavigationBarHidden(true, animated: false)
        
       // var emitter:CAEmitterLayer? = particleEffect(UIImage(named: "snow")!, viewlayer: view)
        
        //emitter!.birthRate = 0
        
        
        //remove seperation from cell which doesn't contain data
        JournalList.tableFooterView = UIView.init(frame: CGRect.zero)
        
        JournalList.layer.borderWidth = 1
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension JournalListScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #warning("记得修改这里 table的元素数量")
        return 3
    }
    
    //configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var journal = journas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCellWithPic", for: indexPath) as! JournalCellWithPic
        
        #warning("记得修改这里 table的content")
        if let JournalListCell = cell as? JournalCellWithPic
        {
            JournalListCell.DateLabel.text = "30"
            JournalListCell.MonthLabel.text = "Mar"
            JournalListCell.TitleLabel.text = "Travel to China"
            JournalListCell.ContentLabel.text = "Loeff sdfjh sdfefn ssdfsdfdfgdfgsfgsdfgdfsg..."
            JournalListCell.WeatherView.image = UIImage(named:"cloudly")
            JournalListCell.ImageView.image = UIImage(named:"2")
            JournalListCell.MoodView.image = UIImage(named:"333333")
            
            JournalListCell.ContentLabel.isUserInteractionEnabled = false
            
           var emitter:CAEmitterLayer? = particleEffect(UIImage(named: "snow30")!,viewlayer: JournalListCell)
            //JournalListCell.allowsTransparency = true
        }
        
        return cell
        
        
    }
}
