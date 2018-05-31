//
//  HighscoreData.swift
//  MemoryGame
//
//  Created by Malgorzata Zawisza on 5/31/18.
//  Copyright © 2018 Malgorzata Zawisza. All rights reserved.
//

import Foundation
import CoreData

class HighscoresData{
    
    let context:NSManagedObjectContext
    var highscores: [CDMemoryGame]{
        return _highscores
    }
    
    private var _highscores: [CDMemoryGame]
    
    init(context: NSManagedObjectContext){
        self.context = context
        do{
            _highscores = try context.fetch(CDMemoryGame.fetchRequest())
        }catch{
            _highscores = []
        }
        
    }
    
    func addNewHighScore(_ highscore: CDMemoryGame){
        _highscores.append(highscore)
        context.insert(highscore)
    }
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
        
    }
}
