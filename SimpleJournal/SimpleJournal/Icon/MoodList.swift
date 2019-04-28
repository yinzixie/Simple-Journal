//
//  MoodList.swift
//  SimpleJournal
//
//  Created by yinzixie on 24/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import Foundation
import UIKit

public class MoodList {
    static var Moods = ["sad","embarrassed","rich","sad","embarrassed","rich"]
    
    static func UpdateMoods() {
        let list = AppFile.getFileListInFolderWithPath(path:AppFile.MoodsFolderFullPath as String)
        
        for name in list {
            if (!Moods.contains(name)) {
                Moods += [name]
            }
        }
    }
}
