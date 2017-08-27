//
//  SettingsDefaults.swift
//  Yahtzee
//
//  Created by Martijn van Gogh on 03-05-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//  This extension takes care of the whole setingsmenu, it's folding in and out, and en- and disabling of sound, music and to look at 

import Foundation
import UIKit

extension ViewController {
    
    //func to foldout settingsmenu and it's 3 buttons to set sound, music and 'overig'. It also adds targets to the 4 buttons.
    func popOutSettings() {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: {
            //self.containerView.frame = CGRect(x: 0, y: self.view.bounds.maxY - 150, width: 150, height: 150)
            self.addBlurview()
            
            self.imageView.frame = CGRect(x: 0, y: self.view.bounds.maxY - 150, width: 150, height: 150)
            self.imageView.image = UIImage(named: Settings.SettingsSetUp.settingsBckGroundImg)
            self.imageView.alpha = 0.7
            
            self.settingsBtn.frame = CGRect(x: 0, y: self.view.bounds.maxY - 50, width: 50, height: 50)
            self.settingsBtn.setImage(UIImage(named: Settings.SettingsSetUp.settingsBtnImg), for: UIControlState())
            self.settingsBtn.addTarget(self, action: #selector(ViewController.popSettings), for: .touchUpInside)
            
            self.setMusicBtn.frame = CGRect(x: 10, y: self.view.bounds.maxY - 140, width: 50, height: 50)
            self.setMusicBtn.setImage(UIImage(named: self.btn2Image), for: UIControlState())
            self.setMusicBtn.addTarget(self, action: #selector(ViewController.musicSettings), for: .touchUpInside)
            
            self.setSoundBtn.frame = CGRect(x: 56, y: self.view.bounds.maxY - 106, width: 50, height: 50)
            self.setSoundBtn.setImage(UIImage(named: self.btn3Image), for: UIControlState())
            self.setSoundBtn.addTarget(self, action: #selector(ViewController.soundSettings), for: .touchUpInside)
            
            self.setOverigBtn.frame = CGRect(x: 90, y: self.view.bounds.maxY - 60, width: 50, height: 50)
            self.setOverigBtn.setImage(UIImage(named: self.btn4Image), for: UIControlState())
            self.setOverigBtn.addTarget(self, action: #selector(ViewController.otherSettings), for: .touchUpInside)
            
            
        }) { _ in
            
            self.view.addSubview(self.setMusicBtn)
            self.imageView.bringSubview(toFront: self.setMusicBtn)
            
            self.view.addSubview(self.setSoundBtn)
            self.imageView.bringSubview(toFront: self.setSoundBtn)
            
            self.view.addSubview(self.setOverigBtn)
            self.imageView.bringSubview(toFront: self.setOverigBtn)
        }
    }
    //animation of the settingsarea fold back
    func popBackSettings() {
        removeBlurview()
        imageView.frame = CGRect(x: 0, y: view.bounds.maxY - 150, width: 150, height: 150)
        imageView.image = UIImage(named: Settings.SettingsSetUp.settingsBckGroundImg)
        
        settingsBtn.frame = CGRect(x: 0, y: view.bounds.maxY - 50, width: 50, height: 50)
        settingsBtn.setImage(UIImage(named: Settings.SettingsSetUp.settingsBtnImg), for: UIControlState())
        settingsBtn.addTarget(self, action: #selector(ViewController.popSettings), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(settingsBtn)
        imageView.bringSubview(toFront: settingsBtn)
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.imageView.frame = CGRect(x: 0, y: self.view.bounds.maxY - 50, width: 50, height: 50)
            self.imageView.image = UIImage(named: Settings.SettingsSetUp.settingsBckGroundImg)
            self.imageView.alpha = 0.2
            
            self.settingsBtn.frame = CGRect(x: 0, y: self.view.bounds.maxY - 50, width: 50, height: 50)
            self.settingsBtn.setImage(UIImage(named: Settings.SettingsSetUp.settingsBtnImg), for: UIControlState())
            self.settingsBtn.addTarget(self, action: #selector(ViewController.popSettings), for: .touchUpInside)
            
            self.setMusicBtn.frame = CGRect(x: 10, y: self.view.bounds.maxY + 40, width: 0, height: 0)
            self.setSoundBtn.frame = CGRect(x: 10, y: self.view.bounds.maxY + 40, width: 0, height: 0)
            self.setOverigBtn.frame = CGRect(x: 10, y: self.view.bounds.maxY + 40, width: 0, height: 0)
            
        }) 
    }
    //Func that sets musicettings if the user changes them during the game, so it changes the settings immediately
    func musicSettings() {
        myAdvancedAnimations.addWobblingAnimation(setMusicBtn)
        if soundOn { myPLayer.playMeAlso(file: Settings.AudioStrings.chooseSetting, ext: "wav") }
        if musicOn {
            btn2Image = Settings.SettingsSetUp.musicOff
            setMusicBtn.setImage(UIImage(named: btn2Image), for: UIControlState())
            settingsDefaults.set(true, forKey: "musicSettings")
            musicOn = false
            if myPLayer.backgroundPlayer != nil {
                myPLayer.backgroundPlayer!.stop()
            }
            
        } else {
            btn2Image = Settings.SettingsSetUp.musicOnImg
            setMusicBtn.setImage(UIImage(named: btn2Image), for: UIControlState())
            settingsDefaults.set(false, forKey: "musicSettings")
            musicOn = true
            myPLayer.playMusicInBackground(file: Settings.AudioStrings.backGroundMusic, ext: "wav")
            
        }
    }
    //Func that sets soundsettings if the user changes them during the game, so it changes the settings immediately
    func soundSettings() {
        if soundOn { myPLayer.playMeAlso(file: Settings.AudioStrings.chooseSetting, ext: "wav") }
        myAdvancedAnimations.addWobblingAnimation(setSoundBtn)
        if soundOn {
            btn3Image = Settings.SettingsSetUp.soundOfImg
            setSoundBtn.setImage(UIImage(named: btn3Image), for: UIControlState())
            settingsDefaults.set(true, forKey: "soundSettings")
            soundOn = false
            
        } else {
            btn3Image = Settings.SettingsSetUp.soundOnImg
            setSoundBtn.setImage(UIImage(named: btn3Image), for: UIControlState())
            settingsDefaults.set(false, forKey: "soundSettings")
            soundOn = true
        }
        
    }
    //Func to load music- and soundsettings from the memmory (views and audioplayers). Beacause de 'nil-setting of the boolforkey is 'false', we call it soundoff. We in- or validate the players.
    func setSoundAndMusicSettings() {
        
        //sets beginframe for settings and imagebutton in foldin-state
        settingsBtn.frame = CGRect(x: 0, y: view.bounds.maxY - 50, width: 50, height: 50)
        settingsBtn.setImage(UIImage(named: Settings.SettingsSetUp.settingsBtnImg), for: UIControlState())
        settingsBtn.addTarget(self, action: #selector(ViewController.popSettings), for: .touchUpInside)
        view.addSubview(settingsBtn)
        
        imageView.frame = CGRect(x: 0, y: self.view.bounds.maxY - 50, width: 50, height: 50)
        imageView.image = UIImage(named: Settings.SettingsSetUp.settingsBckGroundImg)
        imageView.alpha = 0.3
        imageView.bringSubview(toFront: settingsBtn)
        
        view.addSubview(imageView)
        imageView.bringSubview(toFront: settingsBtn)
        
        //Sets sound-/musicbuttons Starts false, so sound is on
        let soundoff = settingsDefaults.bool(forKey: "soundSettings")
        let musicOff = settingsDefaults.bool(forKey: "musicSettings")
        
        if soundoff == false {
            btn3Image = Settings.SettingsSetUp.soundOnImg
            soundOn = true
        } else {
            btn3Image = Settings.SettingsSetUp.soundOfImg
            soundOn = false
        }
        
        if musicOff == false {
            myPLayer.playMusicInBackground(file: Settings.AudioStrings.backGroundMusic, ext: "wav")
            btn2Image = Settings.SettingsSetUp.musicOnImg
            musicOn = true
        } else {
            btn2Image = Settings.SettingsSetUp.musicOff
            musicOn = false
        }
    }
    
    func otherSettings() {
        myAdvancedAnimations.addWobblingAnimation(setOverigBtn)
        
    }
    // overall functie die aangeroepen wordt als op de settingsbutton wordt getapt.
    func popSettings() {
        if soundOn { myPLayer.playMeAlso(file: Settings.AudioStrings.openSettingsMenu, ext: "wav") }
        myAdvancedAnimations.smoothJiggle(settingsBtn)
        myAdvancedAnimations.addSlowWobblingAnimation(settingsBtn)
        if isPoppedOut {
            popBackSettings()
            isPoppedOut = false
        } else {
            popOutSettings()
            isPoppedOut = true
        }
    }

}
