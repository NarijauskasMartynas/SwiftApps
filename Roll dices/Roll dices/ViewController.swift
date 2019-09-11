//
//  ViewController.swift
//  Roll dices
//
//  Created by Martynas Narijauskas on 9/10/19.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    
    var diceIndex1 : Int = 0
    var diceIndex2 : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imagesArray : [UIImage] = []

        for index in 1 ... 6 {
            imagesArray.append(UIImage(named: "dice\(index).png")!)
        }
        imagesArray.shuffle()
        diceImageView1.animationImages = imagesArray
        diceImageView1.animationDuration = 0.5
        
        imagesArray.shuffle()
        diceImageView2.animationImages = imagesArray
        diceImageView2.animationDuration = 0.5
    }

    @IBAction func rollButtonTapped(_ sender: UIButton) {
        rollDices()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollDices()
    }
    
    func rollDices(){
        diceIndex1 = Int.random(in: 1 ... 6)
        diceIndex2 = Int.random(in: 1 ... 6)
        
        diceImageView1.startAnimating()
        diceImageView2.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            self.diceImageView1.stopAnimating()
            self.diceImageView2.stopAnimating()
        }
        
        diceImageView1.image = UIImage.init(named: "dice\(diceIndex1)")
        diceImageView2.image = UIImage.init(named: "dice\(diceIndex2)")
    }
}

