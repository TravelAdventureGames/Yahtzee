//
//  Settings.swift
//  Yahtzee
//
//  Created by Martijn van Gogh on 21-04-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import Foundation

struct Settings {
    struct World1 {
        static let worldName: String = "Yahtzee World"
        static let speeltijd: Double = 60.0
        static let speelTijdReduction = 2.75
        static let speelTijdReduction2 = 1.5
        static let targetScore: Int = 60
        static let noOfLevels = 24
        static let startAmountLives = 5
        static let tijdnoodFactor = 0.70
    }
    //images of the settingsbutton which folds out when tapped. It reveals buttons to enter the app-settings
    struct SettingsSetUp {
        static let settingsBtnImg = "setting1.png" //image for main (little) btn in corner bottem left.
        static let settingsBckGroundImg = "quarter.png" //image for background after button folds out
        static let soundOnImg = "sound.png" //image for sound in 'on-state'
        static let soundOfImg = "soundOff.png" //image of sound in 'off-state'
        static let musicOnImg = "musicOn.png" //image for backgroud music in 'on state'
        static let musicOff = "musicOff.png" //image for background music in 'off-state'
        static let scoreImg = "musicOn.png" // Image to enter higscores, achievements, etc.
    }
    
    struct AudioStrings {
        static let extraLive = "levelup" //When player played all dices away. He wins an extra live
        static let levelUp = "levelup" //When player completes the level and moves up a level
        static let levelFail = "error" //PLayed when level failed and live lost
        static let tooManyDices = "error"
        static let worldEnd1 = "wordEnd" //Scream when player loses al of his lives
        static let timeOut = "timesup" //Played when all the time for the level is up
        static let world1Completed = "world1completed" //plays when the player completes all levels of this world
        static let timeRunningOut = "tickingclock" //At a certain percentage of the playtime completed, a clock starts ticking
        static let backGroundMusic = "They came here1 WAV" //Background music during whole game
        static let cancelSound = "reverse1" //bring back the selected dices on the screen with the cancel button
        static let selectDiceSound = "tap1" //whenever a dice is tapped
        static let dicesThrown = "dices" //when the 15 random dices are presented
        static let openSettingsMenu = "open" //open settingsmenu
        static let chooseSetting = "pop" //choose setting in settigsmenu
    }
    struct Images {
        static let bonusLeeg = "bonusLeeg.png"
        static let extraLive = "extraLive.png"
        static let levelUp = "levelUp.png"
        static let levelFail = "levelFail.png"
        static let tooManyDices = "tooManyDices.png"
        static let worldEnd1 = "worldend1.png"
        static let worldEnd1Win = "worldEnd1Win.png"
        static let timeOut = "timeOut.png"
    }
}
