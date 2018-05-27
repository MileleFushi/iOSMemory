//
//  PlayGameViewController.swift
//  MemoryGame
//
//  Created by Malgorzata Zawisza on 5/20/18.
//  Copyright © 2018 Malgorzata Zawisza. All rights reserved.
//

import UIKit

class PlayGameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    //ZMIENNE
    @IBOutlet weak var myLabelPlayerPairsCount: UILabel!
    @IBOutlet weak var myLabelMaxTimeForGame: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var myCreatedGame: Match = Match(difficultyLevel: "", alphabetItems: [], randedForGameAlphabetItems: [], maxTimeForGame: 0, playerName: "Player", playerPairsCount: 0)
    
    var myPairsCount: Int8 = 0
    var myTimeInSeconds: Int16 = 0
    var timeIsRunning = false
    var resumeGame = false
    var firstChoosedItemContent = "null"
    var secondChoosedItemContent = "null"
    var firstClick = true
    var timer = Timer()
    
    let timeEndedAlert = UIAlertController(title: "Time is over!", message: "Time for your game has ended. Do you wanna try again? :)", preferredStyle: UIAlertControllerStyle.alert)
    
    //VIEW-DID-LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        //listenery nasluchujace czy aplikacja przeszla do tla/czy wrocila z tla
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appNotInBackground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
        //ustawienie do labelek i zmiennych widoku domyslnych wartosci z protokolu-struktury Game-Match
        myLabelPlayerPairsCount.text = setMyLabelPlayerPairsCount(counts: myCreatedGame.playerPairsCount)
        myLabelMaxTimeForGame.text = setMyLabelMaxTimeForGame(seconds: myCreatedGame.maxTimeForGame)
        myPairsCount = Int8(myCreatedGame.playerPairsCount)
        myTimeInSeconds = Int16(myCreatedGame.maxTimeForGame)
        
        //ustawienie przyciskow alertu konca czasu
        self.timeEndedAlert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            self.backButton.sendActions(for: .touchUpInside)
        }))
        self.timeEndedAlert.addAction(UIAlertAction(title: "Yes!", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            self.restartGame()
        }))
    }
    
    //VIEV-DID-APPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(resumeGame == true){
            pauseStartTimer()
        }
    }
    
    //funkcje obslugujace wejscie aplikacji do tla
    @objc func appMovedToBackground() {
        pauseStopTimer()
    }
    
    @objc func appNotInBackground() {
        pauseStartTimer()
    }
    
    //akcja przycisku backButton
    @IBAction func backButtonTapped(_ sender: Any) {
        pauseStopTimer()
    }
    
    //funkcje do obslugi timera w grze
    func pauseStopTimer(){
        timer.invalidate()
        print("pauseSTOPgame")
        self.resumeGame = true
        
    }
    
    func pauseStartTimer(){
        print("pauseSTARTgame")
        runTimer()
        self.resumeGame = false
        
    }
    
    @objc func decrementTime(){
        
        if(self.myTimeInSeconds != 0){
            let timeInSeconds = self.myTimeInSeconds-1
            print("\(timeInSeconds)")
            self.myLabelMaxTimeForGame.text = self.setMyLabelMaxTimeForGame(seconds: timeInSeconds)
            self.myTimeInSeconds = timeInSeconds
        }else{
            timer.invalidate()
            self.present(self.timeEndedAlert, animated: true, completion: nil)
            self.myTimeInSeconds = myCreatedGame.maxTimeForGame
            self.myLabelMaxTimeForGame.text = self.setMyLabelMaxTimeForGame(seconds: self.myTimeInSeconds)
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.decrementTime), userInfo: nil, repeats: true)
    }
    
    //DID-RECEIVE-MEMORY-WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //konwersja sekund na String o wygladzie 00:00 + ustawianie czasu do labelki
    func setMyLabelMaxTimeForGame (seconds : Int16) -> String {
        if ((seconds % 3600) % 60) == 0 {
            return "0\((seconds % 3600) / 60):00"
            
        } else if ((seconds % 3600) % 60) > 0 && ((seconds % 3600) % 60) < 10{
            return "0\((seconds % 3600) / 60):0\((seconds % 3600) % 60)"
            
        }else{
        return "0\((seconds % 3600) / 60):\((seconds % 3600) % 60)"
        }
    }
    
    //konwersja odnalezionych par na String o wygladzie 00 + ustawianie ilosci odgadnietych par do labelki
    func setMyLabelPlayerPairsCount (counts: Int8) -> String {
        if Int(counts) < 10 && Int(counts) >= 0 {
            return "0\(counts)"
        }else{
            return "\(counts)"
        }
    }
    
    //szereg operacji, ktore musza sie wykonac by gracz mogl zagrac jeszcze raz ten sam poziom
    func restartGame(){
        timeIsRunning = false
        self.myPairsCount = myCreatedGame.playerPairsCount
        self.myLabelPlayerPairsCount.text = setMyLabelPlayerPairsCount(counts: self.myPairsCount)
        loadViewIfNeeded()
    }
    
    //ile kafelek ma zwracac
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myCreatedGame.randedForGameAlphabetItems.count
    }
    
    //jakie wartosci ma wstawic do labelek kazdego kafelka
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! MyCollectionViewCell
        
        cell.myLabel.text = myCreatedGame.randedForGameAlphabetItems[indexPath.item]
        
        return cell
    }
    
    //co ma zrobic po nacisnieciu kafelka
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("You selected cell #\(indexPath.item)!")
        
        
        if(timeIsRunning == false){
            runTimer()
            timeIsRunning = true
        }
        
        if(firstClick){
            firstChoosedItemContent = myCreatedGame.randedForGameAlphabetItems[indexPath.row]
            firstClick = false
        }else{
            secondChoosedItemContent = myCreatedGame.randedForGameAlphabetItems[indexPath.row]
            
            if(secondChoosedItemContent == firstChoosedItemContent){
                myPairsCount = myPairsCount + 1
                myLabelPlayerPairsCount.text = setMyLabelPlayerPairsCount(counts: myPairsCount)
            }
            firstClick = true
        }
        
        
    }


}
