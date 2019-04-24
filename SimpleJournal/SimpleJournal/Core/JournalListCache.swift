//
//  JournalListCache.swift
//  SimpleJournal
//
//  Created by yinzixie on 24/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import Foundation

public class JournalListCache{
    
    static var JournalList:[Journal]!
    static var Database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")

    init() {
        JournalListCache.JournalList = JournalListCache.Database.selectAllJournal()
    }
    
    static func refresh() {
        JournalListCache.JournalList = JournalListCache.Database.selectAllJournal()
    }
    
}
