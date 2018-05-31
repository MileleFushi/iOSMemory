//
//  ScoresViewController.swift
//  MemoryGame
//
//  Created by Malgorzata Zawisza on 5/20/18.
//  Copyright © 2018 Malgorzata Zawisza. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var myHighscores: [CDMemoryGame]?
    var levelCounts: [String: Int] = [:]
    
    var appDelegate: AppDelegate?
    var context: NSManagedObjectContext?
    var entity: NSEntityDescription?
    
    var myPlayerName: String = "Gracz"
    var myTimeInSeconds: Int16 = 0
    var myDifficultyLevel: String = "easy"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Highscore - Easy mode"
        self.tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "TableCell")
        
        prepareCoreData()
        addNewHighscore()
    }

    @IBAction func easyButtonScores(_ sender: Any) {
    }
    
    @IBAction func mediumButtonScores(_ sender: Any) {
    }
    
    @IBAction func hardButtonScores(_ sender: Any) {
    }
    
    //przygotowanie coreData
    func prepareCoreData(){
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "CDMemoryGame", in: context!)
        
        do{
            myHighscores = try context?.fetch(CDMemoryGame.fetchRequest())
        }catch{
            myHighscores = []
        }
    }
    
    //dodawanie celki do listy highscore
    func addNewHighscore(){
        
        //tworzenie obiektu i przypisywanie do jego atrybutow wartosci
        let newHighscore = NSManagedObject(entity: entity!, insertInto: context)
        newHighscore.setValue(myDifficultyLevel, forKey: "difficultyLevel")
        newHighscore.setValue(myPlayerName, forKey: "nick")
        newHighscore.setValue(setTimeLabelFormat(seconds: myTimeInSeconds), forKey: "time")
        
        //dodawanie nowego highscore do lokalnej tablicy
        myHighscores?.append(newHighscore as! CDMemoryGame)
        
        //zapisywanie
        do {
            try context?.save()
        } catch {
            print("ERROR: Saving failded!")
        }
        
        //fetchowanie
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CDMemoryGame")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context?.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "nick") as! String)
                print(data.value(forKey: "difficultyLevel") as! String)
                print(data.value(forKey: "time") as! String)
            }
            
        } catch {
            
            print("ERROR: Fetch failed!")
        }
        
        //przeladuj tableView
        print(myHighscores)
        tableView.reloadData()
        
    }
    
    //konwersja sekund na String o wygladzie 00:00
    func setTimeLabelFormat (seconds : Int16) -> String {
        if ((seconds % 3600) % 60) == 0 {
            return "0\((seconds % 3600) / 60):00"
            
        } else if ((seconds % 3600) % 60) > 0 && ((seconds % 3600) % 60) < 10{
            return "0\((seconds % 3600) / 60):0\((seconds % 3600) % 60)"
            
        }else{
            return "0\((seconds % 3600) / 60):\((seconds % 3600) % 60)"
        }
    }
    
    func checkHowManyItemsInLevel(level: String) -> Int {
        
        for item in myHighscores! {
            levelCounts[item.difficultyLevel!] = (levelCounts[item.difficultyLevel!] ?? 0) + 1
        }
        
        if(level == "easy"){
            return levelCounts["easy"]!
            
        }else if (level == "medium"){
            return levelCounts["medium"]!
            
        }else{
            return levelCounts["hard"]!
            
        }
        
    }
    
    //ile celek do jakiej sekcji - u mnie wszystkie do sekcji 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(myDifficultyLevel == "easy"){
            return checkHowManyItemsInLevel(level: "easy")
            
        }else if (myDifficultyLevel == "medium"){
            return checkHowManyItemsInLevel(level: "medium")
            
        }else{
            return checkHowManyItemsInLevel(level: "hard")
            
        }
        
    }
    
    //wypelnianie celek
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath as IndexPath) as! MyTableViewCell
        
        
        
        let tempHighscore = myHighscores![indexPath.row]
        cell.myTimeLabel.text = tempHighscore.getTime()
        cell.myPlayerLabel.text = tempHighscore.getNick()
        
        return cell
    }
    
    //co ma zrobic po kliknieciu celki
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
