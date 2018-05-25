//
//  Game.swift
//  MemoryGame
//
//  Created by Malgorzata Zawisza on 5/25/18.
//  Copyright © 2018 Malgorzata Zawisza. All rights reserved.
//

import Foundation

protocol Game {
    
    var alphabetItems: [String] { get set }
    var randedForGameAlphabetItems: [String] { get set }
    var maxTimeForGame: Int16 { get set }
    var playerName: String { get set }
    var playerPairsCount: Int8 { get set }
}

struct Match: Game {
    
    var alphabetItems: [String]
    var randedForGameAlphabetItems: [String]
    var maxTimeForGame: Int16 = 0
    var playerName: String = "Gracz"
    var playerPairsCount: Int8 = 0
}
