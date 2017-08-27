//
//  Animations.swift
//  Yahtzee
//
//  Created by Martijn van Gogh on 21-04-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit



extension ViewController {
    
    
    //TIMER FUNCTIONS
    
    //Timerfunc voor playingtime (speeltijd)
    func timeOut() {
        score -= 20
        let valueRandomNumbers = randomNumbers.reduce(0, +)
        let valueSelectedNumbers = selectedNumbers.reduce(0, +)
        let scoreReduce = valueRandomNumbers - valueSelectedNumbers
        score -= scoreReduce
        timer.invalidate()
        timer2.invalidate()
        stopReason = "timeOut"
    }
    
    //Timer1 func voor tijdnood audio als timer afloopt
    func timeIsRunningOut() {
        
        if soundOn == true { myPLayer.playMeForever(file: Settings.AudioStrings.timeRunningOut, ext: "wav")}
        
    }
    
    // ANIMATIONS
    func makeTimerRects() {
        greyTimerRect.isHidden = false
        blueTimerRect.isHidden = false
        greyTimerRect.frame = CGRect(x: 30, y: 85, width: view.bounds.width - 60, height: 5)
        greyTimerRect.backgroundColor = UIColor(red: 93/255, green: 223/255, blue: 255/255, alpha: 0.4)
        view.addSubview(greyTimerRect)
        
        blueTimerRect.frame = CGRect(x: 30, y: 85, width: 5, height: 5)
        blueTimerRect.backgroundColor = UIColor(red: 93/255, green: 223/255, blue: 255/255, alpha: 1.0)
        view.addSubview(blueTimerRect)
        
        UIView.animate(withDuration: speelTijd, animations: {
            self.blueTimerRect.frame = CGRect(x: 30, y: 85, width: self.view.bounds.width - 60, height: 5)
        }, completion: { (Bool) in
            
            
        }) 
    }
    
    func bonus(imName: String, text: String, soundName: String, ext: String, seconds: Double) {
        
        view.isUserInteractionEnabled = false
        bonusView.frame = CGRect(x: (self.view.bounds.width / 2) , y: (view.bounds.height / 2) - 50, width: 0.025, height: 0.016)
        bonusView.image = UIImage(named: imName)

        label.frame = CGRect(x: (self.view.bounds.width / 2) - 120 , y: (view.bounds.height / 2) - 115, width: 240, height: 110)
        label.font = UIFont(name: "MarkerFelt-Wide", size: 17)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.alpha = 1.0
        
        view.addSubview(bonusView)
        
        self.opnieuwLabel.isHidden = true
        self.greyTimerRect.isHidden = true
        self.blueTimerRect.isHidden = true
        self.YatzeeLabel.isHidden = true
        self.kiesLabel.isHidden = true
        self.cancelLabel.isHidden = true
        
        UIView.animate(withDuration: seconds, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
           
            self.bonusView.transform = CGAffineTransform(scaleX: 14500, y: 14500)
            self.label.text = text
            self.view.addSubview(self.label)
            
            if self.soundOn == true { myPLayer.playMeAlso(file: soundName, ext: ext)}
            
            
            }) { (Bool) in
                UIView.animate(withDuration: 0.1, delay: 4.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.bonusView.transform = CGAffineTransform.identity
                    self.label.frame = CGRect(x: (self.view.bounds.width / 2) - 125 , y: (self.view.bounds.height / 2) - 130, width: 0, height: 0)
                    
                    }, completion: { (Bool) in
                        self.opnieuwLabel.isHidden = false
                        self.bonusView.removeFromSuperview()
                        self.label.removeFromSuperview()
                        self.view.isUserInteractionEnabled = true
                })
        }
    }
    
    //Al je levens zijn op, je hebt gefaald. Begin opnieuw met level 1 van deze wereld.
    
    func wordlEnd(imName: String) {
        self.timer.invalidate()
        self.timer2.invalidate()
        button = UIButton(type: .system)
        button.frame = CGRect(x: (self.view.bounds.width / 2) - 90, y: self.view.bounds.maxY - 90, width: 180, height: 45)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.titleLabel!.font = UIFont(name: "MarkerFelt-Wide", size: 17)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        button.setTitle("Probeer opnieuw!", for: UIControlState())
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 4
        button.addTarget(self, action: #selector(ViewController.beginOpnieuw), for: .touchUpInside)
        
        bonusView.frame = CGRect(x: (self.view.bounds.width / 2) , y: self.view.bounds.height / 2, width: 0, height: 0)
        bonusView.image = UIImage(named: imName)
        view.addSubview(bonusView)
        view.addSubview(button)
        view.bringSubview(toFront: button)
        
        self.greyTimerRect.isHidden = true
        self.blueTimerRect.isHidden = true
        self.YatzeeLabel.isHidden = true
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
            self.bonusView.frame = self.view.bounds
            if self.soundOn == true { myPLayer.playMeAlso(file: Settings.AudioStrings.worldEnd1, ext: "wav")}
            
        }) { (Bool) in
    
        }
    }
    func beginOpnieuw() {
        self.button.removeFromSuperview()
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.bonusView.frame = CGRect(x: (self.view.bounds.width / 2) , y: self.view.bounds.height / 2, width: 0, height: 0)

            }, completion: { (Bool) in
                self.currentLevel = 1
                self.defaults.set(1, forKey: "newCurrentLevel")
                self.speelTijd = Settings.World1.speeltijd
                self.defaults.set(Settings.World1.speeltijd, forKey: "newSpeelTijd")
                self.lives = Settings.World1.startAmountLives
                self.defaults.set(Settings.World1.startAmountLives, forKey: "newLivesAmount")
                
                self.greyTimerRect.isHidden = false
                self.blueTimerRect.isHidden = false
                self.YatzeeLabel.isHidden = false
                
                self.prepareForNextRound()
                self.resetToFalse()
                self.loadLevel()
                
                self.view.isUserInteractionEnabled = true
                
        })
 
    }
    
    
//LETOP IK MOET NOG ALLES RESETTEN NA DE BOOL
    
}
