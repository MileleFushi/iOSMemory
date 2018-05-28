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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var myLabelPlayerPairsCount: UILabel!
    @IBOutlet weak var myLabelMaxTimeForGame: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var myCreatedGame: Match = Match(difficultyLevel: "", alphabetItems: [], randedForGameAlphabetItems: [], maxTimeForGame: 0, playerName: "Player", playerPairsCount: 0)
    
    var myMatchItemsArray: [String] = []
    var myPairsCount: Int8 = 0
    var myTimeInSeconds: Int16 = 0
    var timeIsRunning = false
    var resumeGame = false
    var firstChoosedItemContent = "null"
    var secondChoosedItemContent = "null"
    var firstChoosedItemIndexPath: IndexPath?
    var secondChoosedItemIndexPath: IndexPath?
    var firstChoosedItemId = "null"
    var secondChoosedItemId = "null"
    var firstChoosedItem: MyCollectionViewCell?
    var secondChoosedItem: MyCollectionViewCell?
    var firstClick = true
    var timer = Timer()
    var colorRed: Float = 65.0
    var colorGreen: Float = 211.0
    var colorBlue: Float = 65.0
    var asciiAndItsColorDictionary: [String: UIColor] = [:]
    var letterColor: UIColor?
    
    let timeEndedAlert = UIAlertController(title: "Time is over!", message: "Time for your game has ended. Try one more time! :)", preferredStyle: UIAlertControllerStyle.alert)
    
    let winGameAlert = UIAlertController(title: "Hurra!", message: "You won the match. Check your score! :)", preferredStyle: UIAlertControllerStyle.alert)
    
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
        myMatchItemsArray = myCreatedGame.randedForGameAlphabetItems
        
        //ustawienie przyciskow alertu konca czasu
        self.timeEndedAlert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            self.backButton.sendActions(for: .touchUpInside)
        }))
        
        //ustawienie przyciskow alertu wygrania gry
        self.winGameAlert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            self.backButton.sendActions(for: .touchUpInside)
        }))
        self.winGameAlert.addAction(UIAlertAction(title: "Show score", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            self.showMyScore()
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
        //print("pauseSTOPgame")
        self.resumeGame = true
        
    }
    
    func pauseStartTimer(){
        //print("pauseSTARTgame")
        runTimer()
        self.resumeGame = false
        
    }
    
    @objc func decrementTime(){
        
        if(self.myTimeInSeconds != 0){
            let timeInSeconds = self.myTimeInSeconds-1
            //print("\(timeInSeconds)")
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
    
    func showMyScore(){
        self.performSegue(withIdentifier: "showScore", sender: self)
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
    
    //zamiana hex na kolor do odczytu
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //funkcja do wykonywania animacji trzesienia sie itemu
    func shakeThatWithAnimation(){
        
        let animation = CABasicAnimation(keyPath: "animateItemWrongSelection")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        
        animation.fromValue = NSValue(cgPoint: CGPoint(x: (firstChoosedItem?.center.x)! - 15, y: (firstChoosedItem?.center.y)!))
        animation.toValue = NSValue(cgPoint: CGPoint(x: (firstChoosedItem?.center.x)! + 15, y: (firstChoosedItem?.center.y)!))
        
        firstChoosedItem?.layer.add(animation, forKey: "animateItemWrongSelection")
        secondChoosedItem?.layer.add(animation, forKey: "animateItemWrongSelection")
    }
    
    //ile kafelek ma zwracac do sekcji - tutaj jedna sekcja = 0
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myMatchItemsArray.count
    }
    
    //jakie wartosci ma wstawic do labelek kazdego kafelka
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! MyCollectionViewCell
        
        cell.myLabel.text = myMatchItemsArray[indexPath.item]
        
        if(asciiAndItsColorDictionary[cell.myLabel.text!] == nil){
            changeItemLetterColor(cell: cell)
            
        }else{
            cell.myLabel.textColor = asciiAndItsColorDictionary[cell.myLabel.text!]
        }
        
        cell.contentView.alpha = 0.0
        cell.contentView.backgroundColor = hexStringToUIColor(hex: "55320A")
        return cell
    }
    
    //funkcja ustawiajaca kolor czcionki itemu w okreslonej przeze mnie gamie kolorow o 292 poziomach
    func changeItemLetterColor(cell: MyCollectionViewCell){
        
        let jumpInColor = 584.0/Float(myMatchItemsArray.count)
        
        if(colorRed < 211){
            colorRed = colorRed + jumpInColor
            letterColor = UIColor(red: CGFloat(colorRed/255.0), green: CGFloat(colorGreen/255.0), blue: CGFloat(colorBlue/255.0), alpha: 1.0)
            cell.myLabel.textColor = letterColor
            
            print(colorRed)
            
        }else{
            colorGreen = colorGreen - jumpInColor
            letterColor = UIColor(red: CGFloat(colorRed/255.0), green: CGFloat(colorGreen/255.0), blue: CGFloat(colorBlue/255.0), alpha: 1.0)
            cell.myLabel.textColor = letterColor
        }
        
        asciiAndItsColorDictionary[cell.myLabel.text!] = letterColor
    }
    
    //co ma zrobic po nacisnieciu kafelka
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let ableToClick = collectionView.cellForItem(at: indexPath)?.backgroundColor != UIColor(white: 1, alpha: 0.0)
        
        if(timeIsRunning == false){
            runTimer()
            timeIsRunning = true
        }else{}
        
        if(ableToClick){
            if(firstClick){
                firstChoosedItem = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as? MyCollectionViewCell
                firstChoosedItemContent = myMatchItemsArray[indexPath.row]
                firstChoosedItemId = "\(indexPath.item)"
                firstChoosedItemIndexPath = indexPath
                firstClick = false
                self.collectionView.cellForItem(at: firstChoosedItemIndexPath!)?.backgroundColor = hexStringToUIColor(hex: "A86417")
                self.collectionView.cellForItem(at: firstChoosedItemIndexPath!)?.contentView.alpha = 1.0
                
            }else{
                secondChoosedItem = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as? MyCollectionViewCell
                secondChoosedItemContent = myMatchItemsArray[indexPath.row]
                secondChoosedItemId = "\(indexPath.item)"
                secondChoosedItemIndexPath = indexPath
                firstClick = true
                self.collectionView.cellForItem(at: secondChoosedItemIndexPath!)?.backgroundColor = hexStringToUIColor(hex: "A86417")
                self.collectionView.cellForItem(at: secondChoosedItemIndexPath!)?.contentView.alpha = 1.0
                
                if(secondChoosedItemContent == firstChoosedItemContent) && (collectionView.cellForItem(at: indexPath)?.backgroundColor != UIColor(white: 1, alpha: 0.0) || collectionView.cellForItem(at: indexPath)?.backgroundColor != UIColor(white: 1, alpha: 0.0)) && (secondChoosedItemId != firstChoosedItemId){
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.collectionView.cellForItem(at: self.firstChoosedItemIndexPath!)?.contentView.alpha = 0.0
                        self.collectionView.cellForItem(at: self.secondChoosedItemIndexPath!)?.contentView.alpha = 0.0
                        
                        self.collectionView.cellForItem(at: self.firstChoosedItemIndexPath!)?.backgroundColor = UIColor(white: 1, alpha: 0.0)
                        self.collectionView.cellForItem(at: self.secondChoosedItemIndexPath!)?.backgroundColor = UIColor(white: 1, alpha: 0.0)
                    })
                    
                    myPairsCount = myPairsCount + 1
                    myLabelPlayerPairsCount.text = setMyLabelPlayerPairsCount(counts: myPairsCount)
                    if(myPairsCount == myMatchItemsArray.count/2){
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            self.present(self.winGameAlert, animated: true, completion: nil)
                            self.self.myTimeInSeconds = 0
                            self.myLabelMaxTimeForGame.text = self.setMyLabelMaxTimeForGame(seconds: self.myTimeInSeconds)
                        })
                    }
                    
                }else{
                    //shakeThatWithAnimation()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.collectionView.cellForItem(at: self.firstChoosedItemIndexPath!)?.backgroundColor = self.hexStringToUIColor(hex: "55320A")
                        self.collectionView.cellForItem(at: self.secondChoosedItemIndexPath!)?.backgroundColor = self.hexStringToUIColor(hex: "55320A")
                        self.collectionView.cellForItem(at: self.firstChoosedItemIndexPath!)?.contentView.alpha = 0.0
                        self.collectionView.cellForItem(at: self.secondChoosedItemIndexPath!)?.contentView.alpha = 0.0
                    })
                    
                }
            }
        }else{}
        
        
        
    }


}
