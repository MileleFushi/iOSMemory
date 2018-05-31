//
//  CDMemoryGame+CoreDataProperties.swift
//  MemoryGame
//
//  Created by Malgorzata Zawisza on 5/31/18.
//  Copyright © 2018 Malgorzata Zawisza. All rights reserved.
//
//

import Foundation
import CoreData


extension CDMemoryGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMemoryGame> {
        return NSFetchRequest<CDMemoryGame>(entityName: "CDMemoryGame")
    }

    @NSManaged public var difficultyLevel: String?
    @NSManaged public var nick: String?
    @NSManaged public var time: String?

}
