//
//  Journal.swift
//  SimpleJournal
//
//  Created by yinzixie on 14/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import Foundation
import UIKit

class Journal {
    var ID:String!
    var Title:String!
    
    var Date_:Date!
    var DateString:String! //yyyy-MM-dd  HH:mm:ss
    var Year:Int!
    var Month:Int!
    var Day:Int!
    var Time:String! //example 13:00
    
    var Location:String!
    var Mood:String!
    var Weather:String!
    var TextContent:String!
    
    var PicsTableID:String!
    var PicsList:[UIImage]?
    
    init() {
        ID = DateInfo.dateToDateString(Date(), dateFormat:"yyyyMMddHHmmss")//generate by date
        Title = "Journal Title"
        Date_ = Date()
        DateString = DateInfo.dateToDateString(Date_, dateFormat: "yyyy-MM-dd  HH:mm:ss")
        Year = Int(DateString.prefix(4)) //前4个字符
        
        //截取第5-6个字符串 year
        let index6 = DateString.index(DateString.startIndex, offsetBy: 5)
        let index8 = DateString.index(DateString.startIndex, offsetBy: 7)
        
        Month = Int(DateString[index6..<index8])
        
        //9-10 month
        let index9 = DateString.index(DateString.startIndex, offsetBy: 8)
        let index11 = DateString.index(DateString.startIndex, offsetBy: 10)
        Day = Int(DateString[index9..<index11])
        
        //time
        Time = String(DateString.suffix(8)) //后8个字符
        
        Location = "None"
        Mood = "None"
        Weather = "None"
        TextContent = "None_Content" //avoid user type none cause conflic
        PicsTableID = ID
    }
}

