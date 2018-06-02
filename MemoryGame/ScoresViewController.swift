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
    var myViewedHighscores: [CDMemoryGame]?
    var levelCounts: [String: Int] = [:]
    
    var appDelegate: AppDelegate?
    var context: NSManagedObjectContext?
    var entity: NSEntityDescription?
    
    var myPlayerName: String = "Gracz"
    var myTimeInSeconds: Int16 = 0
    var myDifficultyLevel: String = "easy"
    
    var wonTheGame = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myHeaderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        prepareCoreData(forDifficultyLevel: myDifficultyLevel)
        //deleteAllData(entity: "CDMemoryGame") <- BE CAREFUL!
        if(wonTheGame){
            addNewHighscore()
        }else{}
        
    }

    @IBAction func easyButtonScores(_ sender: Any) {
        myDifficultyLevel = "easy"
        prepareCoreData(forDifficultyLevel: "easy")
        myHighscores = createSortedDataArrayForLevelDifficulty(array: myHighscores!, diffLevel: "easy")
        self.tableView.reloadData()
        print("EASY")
    }
    
    @IBAction func mediumButtonScores(_ sender: Any) {
        myDifficultyLevel = "medium"
        prepareCoreData(forDifficultyLevel: "medium")
        myHighscores = createSortedDataArrayForLevelDifficulty(array: myHighscores!, diffLevel: "medium")
        self.tableView.reloadData()
        print("MEDIUM")
    }
    
    @IBAction func hardButtonScores(_ sender: Any) {
        myDifficultyLevel = "hard"
        prepareCoreData(forDifficultyLevel: "hard")
        myHighscores = createSortedDataArrayForLevelDifficulty(array: myHighscores!, diffLevel: "hard")
        self.tableView.reloadData()
        print("HARD")
    }
    
    //przygotowanie coreData
    func prepareCoreData(forDifficultyLevel: String){
        
        myHeaderLabel.text = "Level \(forDifficultyLevel) scores"
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "CDMemoryGame", in: context!)
        
        do{
            myHighscores = try context?.fetch(CDMemoryGame.fetchRequest())
            myHighscores = createSortedDataArrayForLevelDifficulty(array: myHighscores!, diffLevel: forDifficultyLevel)
            //myViewedHighscores = myHighscores
        }catch{
            myHighscores = []
        }
    }
    
    //wyczysc rekordy encji glownej
    func deleteAllData(entity: String)
    {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try context?.execute(DelAllReqVar) }
        catch { print(error) }
    }
    
    //dodawanie celki do listy highscore
    func addNewHighscore(){
        
        //tworzenie obiektu i przypisywanie do jego atrybutow wartosci
        let newHighscore = NSManagedObject(entity: entity!, insertInto: context)
        newHighscore.setValue(myDifficultyLevel, forKey: "difficultyLevel")
        newHighscore.setValue(myPlayerName, forKey: "nick")
        newHighscore.setValue(myTimeInSeconds, forKey: "time")
        
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
                print(data.value(forKey: "time") as! Int16)
            }
            
        } catch {
            
            print("ERROR: Fetch failed!")
        }
        
        //przeladuj tableView
        prepareCoreData(forDifficultyLevel: myDifficultyLevel)
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
    
    //sprawdz ile jest itemow o okreslonych poziomach trudnosci
    func checkHowManyItemsInLevel(level: String) -> Int {
        
        levelCounts["easy"] = 0
        levelCounts["medium"] = 0
        levelCounts["hard"] = 0
        
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
    
    //posortuj tablice coreData czasem malejaco biorac pod uwage pozom
    func createSortedDataArrayForLevelDifficulty(array: [CDMemoryGame], diffLevel: String) -> [CDMemoryGame]{
        let myArray = array
        var newArray: [CDMemoryGame] = []
        
        for item in myArray {
            
            if(item.difficultyLevel == diffLevel){
                newArray.append(item)
            }
        }
        
        newArray = newArray.sorted(by: { $0.time < $1.time })
        print(newArray)
        
        return newArray
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
        
        let cell: MyTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TableCell") as! MyTableViewCell
        
        let tempHighscore = myHighscores![indexPath.row]
        let timeString = setTimeLabelFormat(seconds: tempHighscore.getTime())
        cell.myTimeLabel.text = timeString
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
