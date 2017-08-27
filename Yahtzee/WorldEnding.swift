//
//  WorldEnding.swift
//  Yahtzee
//
//  Created by Martijn van Gogh on 24-04-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit

//To do: Stop direct na het behalen van het laatste level (en niet via het 'naar volgende level'), want anders start er weer een game...
//To do: maak selector met segue

extension ViewController {
    
    func worldOneComplete() {
        emptyForWorldTwo()
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: (self.view.bounds.width / 2) - 90, y: self.view.bounds.maxY - 90, width: 180, height: 35)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.titleLabel!.font = UIFont(name: "MarkerFelt-Wide", size: 17)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        button.setTitle("Naar \(Settings.World1.worldName) ", for: UIControlState())
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 4
        button.addTarget(self, action: #selector(ViewController.naarWorldTwo), for: .touchUpInside)
        bonusView.frame = CGRect(x: (self.view.bounds.width / 2) , y: self.view.bounds.height / 2, width: 0, height: 0)
        bonusView.image = UIImage(named: Settings.Images.worldEnd1Win)
        view.addSubview(bonusView)
        view.addSubview(button)
        view.bringSubview(toFront: button)
        
        greyTimerRect.removeFromSuperview()
        blueTimerRect.removeFromSuperview()
        YatzeeLabel.removeFromSuperview()
        timer.invalidate()
        prepareForNextRound()
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
            self.bonusView.frame = self.view.bounds
            if self.soundOn == true { myPLayer.playMeAlso(file: Settings.AudioStrings.world1Completed, ext: "wav")}
            
        }) { (Bool) in
            
            self.view.isUserInteractionEnabled = true
            
        }
    }
    func naarWorldTwo() {
        performSegue(withIdentifier: "naar uitleg World 2", sender: self )
    }
    
    //empties the sored properties of this world. Remooves the views form the superview
    func emptyForWorldTwo() {
        view.isUserInteractionEnabled = false
        timer.invalidate()
        timer2.invalidate()
        YatzeeLabel.removeFromSuperview()
        kiesLabel.removeFromSuperview()
        cancelLabel.removeFromSuperview()
        greyTimerRect.removeFromSuperview()
        blueTimerRect.removeFromSuperview()
        for butt in butslabel {
            butt.removeFromSuperview()
        }
        for dice in displayDices {
            dice.removeFromSuperview()
        }
        randomNumbers.removeAll()
        defSelectedPLace.removeAll()
        selectedNumbers.removeAll()
        selectedPlace.removeAll()
    }
    
    // Al je levens zijn op. De wereld start opnieuw.
    func newBeginning() {
        wordlEnd(imName: "worldend1.png")
        
    }
    
}
