//
//  CoreDataConnector.swift
//  CCIP-iOS-Swift
//
//  Created by 高宜誠 on 2017/7/6.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

import Foundation
import CoreData

class CoreDataConnector {
    var moc :NSManagedObjectContext!
    
    init(moc:NSManagedObjectContext) {
        self.moc = moc
    }
    
}
