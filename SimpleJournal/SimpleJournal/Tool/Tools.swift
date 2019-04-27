//
//  Tools.swift
//  SimpleJournal
//
//  Created by yinzixie on 26/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import Foundation
import UIKit

public class Tools {
    //get uiimage form pics list
    static func getUIImageList(picList:[String])->[UIImage] {
        var result = [UIImage]()
        
        for id in picList {
            let image = UIImage(contentsOfFile: AppFile.getImageFullPath(imageName: id))
            image?.accessibilityIdentifier = id
            result += [image!]
        }
        return result
    }
}
