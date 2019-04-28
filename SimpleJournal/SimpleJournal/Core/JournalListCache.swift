//
//  JournalListCache.swift
//  SimpleJournal
//
//  Created by yinzixie on 25/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import Foundation

class MoodStatistic {
    var Num:Int?
    var Mood: String?
    
    init(num:Int,mood:String){
        Num = num
        Mood = mood
    }
}

protocol TellHomePageCacheRefresh {
    func remindHomePageCacheChanged()
    func remindHomePageDeleteAJournal(indexPathInTable:IndexPath)
}

protocol TellManagementPageCacheRefresh {
    func remindManagementPageCacheChanged()
    func remindManagementPageDeleteAJournal(indexPathInTable: IndexPath)
}

protocol TellStatisticPageCacheRefresh {
    func remindStatisticPageCacheChanged()
    func remindStatisticPageDeleteAJournal(indexPathInTable: IndexPath)
}

public class JournalListCache {
    
    static var tellHomePageCacheRefresh:TellHomePageCacheRefresh?
    static var tellManagementPageCacheRefresh:TellManagementPageCacheRefresh?
    static var tellStatisticPageCacheRefresh:TellStatisticPageCacheRefresh?
    
    static var Database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    
    static var JournalList = JournalListCache.Database.selectAllJournal()
    static var StatisticList:[Int]?
    
    class func refresh() {
        JournalList = JournalListCache.Database.selectAllJournal()
        
        tellHomePageCacheRefresh?.remindHomePageCacheChanged()
        tellManagementPageCacheRefresh?.remindManagementPageCacheChanged()
        tellStatisticPageCacheRefresh?.remindStatisticPageCacheChanged()
        print("send refresh")
    }
    
    class func deleteJournal(journal:Journal,indexPathInTable:IndexPath) {
        if(Database.deleteJournal(journal: journal)) {
            
            JournalList = JournalListCache.Database.selectAllJournal()
            
            tellHomePageCacheRefresh?.remindHomePageDeleteAJournal(indexPathInTable:indexPathInTable)
            tellManagementPageCacheRefresh?.remindManagementPageDeleteAJournal(indexPathInTable:indexPathInTable)
            tellStatisticPageCacheRefresh?.remindStatisticPageDeleteAJournal(indexPathInTable: indexPathInTable)
            print("send refresh")
        }
    }
    
    class func statisticMoods(from:Date,to:Date)->[MoodStatistic] {
        var statistics = [MoodStatistic]()
      
        for journal in JournalList {
            if(!(DateInfo.compareOneDay(oneDay: from, withAnotherDay: DateInfo.timeStringToDate(journal.DateString)) == 1 ) && !(DateInfo.compareOneDay(oneDay: to, withAnotherDay: DateInfo.timeStringToDate(journal.DateString)) == 2 )) {

                if(statistics.filter{$0.Mood == journal.Mood}.count > 0){
                    statistics.filter{$0.Mood == journal.Mood}.first?.Num = statistics.filter{$0.Mood == journal.Mood}.first!.Num! + 1
                }else {
                    statistics += [MoodStatistic(num:1,mood:journal.Mood)]
                }
            }
        }
        
        //sort array
        return bubble_sort(list:statistics)
    }
    
    //sort array
    static func bubble_sort(list:[MoodStatistic])->[MoodStatistic]
    {
        var finish = true
        let len = list.count
        
        var result = list
       
        if(len <= 1)
        {
            return list
        }
        
        repeat{
            finish = true
           
            for i in 0..<len {
                let j = i+1
                if(j < len) {
                    print("ss: ",i," ",j," ",result[i].Num)
                    if(result[i].Num! < result[j].Num!) {
                      
                        let temp = result[i]
                        print(result[i].Num, result[j].Num)
                        
                        result[i] = result[j]
                        result[j] = temp
                        finish = false
                    }
                }
            }
            print(finish)
        } while(!finish)
        
        return result
    }
}
