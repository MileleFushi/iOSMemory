//
//  ScoresViewController.swift
//  MemoryGame
//
//  Created by Malgorzata Zawisza on 5/20/18.
//  Copyright © 2018 Malgorzata Zawisza. All rights reserved.
//

import UIKit

class ScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var myPlayerName: String = "Gracz"
    var myTimeInSeconds: Int16 = 0
    var myDifficultyLevel: String = "easy"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Highscore - Easy mode"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        
        addHighscore()
    }

    @IBAction func easyButtonScores(_ sender: Any) {
    }
    
    @IBAction func mediumButtonScores(_ sender: Any) {
    }
    
    @IBAction func hardButtonScores(_ sender: Any) {
    }
    
    //dodawanie celki do listy highscore
    func addHighscore(){
        
    }
    
    //konwersja sekund na String o wygladzie 00:00
    func setTimeLabel (seconds : Int16) -> String {
        if ((seconds % 3600) % 60) == 0 {
            return "0\((seconds % 3600) / 60):00"
            
        } else if ((seconds % 3600) % 60) > 0 && ((seconds % 3600) % 60) < 10{
            return "0\((seconds % 3600) / 60):0\((seconds % 3600) % 60)"
            
        }else{
            return "0\((seconds % 3600) / 60):\((seconds % 3600) % 60)"
        }
    }
    
    //ile celek do jakiej sekcji - u mnie wszystkie do sekcji 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    //wypelnianie celek
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath as IndexPath)
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
