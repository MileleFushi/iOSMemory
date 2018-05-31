//
//  CDMemoryGame+CoreDataClass.swift
//  MemoryGame
//
//  Created by Malgorzata Zawisza on 5/31/18.
//  Copyright © 2018 Malgorzata Zawisza. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CDMemoryGame)
public class CDMemoryGame: NSManagedObject {
    
    public func getDifficultyLevel() -> String {
        return difficultyLevel!
    }
    
    public func getNick() -> String {
        return nick!
    }
    
    public func getTime() -> String {
        return time!
    }
}
