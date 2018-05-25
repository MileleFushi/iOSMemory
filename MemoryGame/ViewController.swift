//
//  ViewController.swift
//  MemoryGame
//
//  Created by Malgorzata Zawisza on 4/26/18.
//  Copyright © 2018 Malgorzata Zawisza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var alphabetItems: [String] = []
    var randedForGameAlphabetItems: [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        alphabetItems = createAlphabetItemsArray()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAlphabetItemsArray() ->[String]{
        var newArray: [String] = []
        
        for i in 65...90{
            newArray.append(String(UnicodeScalar(UInt8(i))))
        }
        
        newArray.append(String(UnicodeScalar(UInt8(33))))
        newArray.append(String(UnicodeScalar(UInt8(35))))
        newArray.append(String(UnicodeScalar(UInt8(36))))
        newArray.append(String(UnicodeScalar(UInt8(37))))
        newArray.append(String(UnicodeScalar(UInt8(38))))
        newArray.append(String(UnicodeScalar(UInt8(63))))
        
        print(newArray)
        
        return newArray
    }
    
    func randForGameAlphabetItemsArray(countOfItems: Int8, array: [String]) -> [String] {
        var myArray = array
        var newArray: [String] = []
        
        var x = Int(arc4random_uniform(UInt32(6)))
        
        return newArray
    }
    
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        exit(0)
    }
    
    @IBAction func easyButtonTapped(_ sender: Any) {
    }
    
    @IBAction func mediumButtonTapped(_ sender: Any) {
    }
    
    @IBAction func hardButtonTapped(_ sender: Any) {
    }
    
}

