//
//  ViewController.swift
//  Yahtzee
//
//  Created by Martijn van Gogh on 19-04-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

/*This is the main class of world one. It handles all the main events happening in world one. How does it works?
0. All the basic settings are set from the Settings-struct. This means that adjusting it there, will adjust every instance of it in the game.
1. It loads the level via loadLevel() This will empty previous used properties and checks if the previous level succeeded (levelSucceeded()). If so it wil raise the currentlevel by 1. This will automatically decrease the playing time (speeltijd). The first time the level automatically starts loading form viewDidload (coming from uitlegVC). This also means the timer is set and the game starts immediately.
2. The player starts to play by selecting dices to form a combination. The 'numberSelected() action is performed on every selected dice. It first checks if the game is still active (isActive == true). If so the selected dice's value and place are appended to atemorary arrays, preselectedNumbers and selectedPlaces, and the display-array 'displayDices'.  preselectedNumber.count is used to keeps track of the amount of dices selected. This can never never be more than 5. If more than 5 the arrays are emptied and a alert is presented to the player.. The player can cancel his selection by pushing the cancel-button. This IBaction empties the temporary arrays. If the player is satisfied with his selection, he taps the 'Choose'-button.
3. When the 'choose-button is tapped, a IBAction is performed 'Kies'. It first checks if the combination was a genuine yahtzee-combination with the checkScore() function. This func switches on the amount of dices used (preselectedNumbers.count) and looks for a matching combi. If found, it raises the score, display what combi was formed and play an according sound (which is set in settings). If not, it sets the 'isFoutloos' property to false and lowers the score by the used dices of the false combination. This means the player can't win this level (because he has to be without faults).
4. After checkScore, the preselectedNumber and selectedPLace have become definite, so they are parsed to 2 new arrays selectedNumbers and defSelectedPlaces. The temporary arrays preSelectedNumbers and selectedPLaces are emptied for a possible next selection. Als the func 'isSetToFalse()' will set all the properties which are used in the checkScore-function to false (a boolean which stores if it is f.e. a carre-combination or not) so it has a 'false-status' for a next selection.
5. Then (very important) the checkGameStatus() func is used. The only goal of this function is to check if there is any combination possible with the remaning numbers. It therefore first make a new array (remValues) out of the Arrays RandomNumbers and defSelectedPLaces. By combining the two, you can estimate which numbers of randomnumbers are still unused.
6. You switch over theremValues.count. If it is more then 5 the default is used and the game continues (because with more than 5 numbers, there's always a combination possible! If 5 or less the func checks wether or not there is still a possible combination. If not, is sets the 'stopReason' property. This property stores what the rason of the game-end is. It can be one of three: 'zettenOp' : there are dices left, but no combination possible. 'nulOver': there are no dices left, the player played them all away. 'timeOut' which is not set by checkGameStatus but by the timer itself (if it expires, it will set stopreason to 'timeOut'
7. The game is now stopped for one of the 3 stopReasons. In didSet of this stopReason, the function afterFinished() is called. This func switches over the 3 stopreasons.
8. But first its is checked if the player did succeed to accomplish the last level of this world (player reached targetscore, made it to targetlevel and was faultless (isFoutloos == true); in that case the worldOneCompleted() func is called.. which will produce a nice animation and sets the whole level to empty properties. If not then the switch cases are handled which display texts, pushes bonus-animations, increase lives, checks for highscore, invalidates timer and makes the opniewLabel (button to go to next level) visible and active again and sets it's title/image with the setButTit() func.
9.The 'opNieuw' is now visible. When tapped the 'loadLevel()' func is being performed. In loadLevel() the first func that's called is 'levelSucceeded()' Only now is checked if the player should move to the next level or not, based one score >= targetscore, he was faultless (isFoutloos == true). If so the playingtime is decreased by the amount of the settings. The currentLevel is raised by 1. Otherwise the playingtime and currentLevel will reamin the old value.
10. HighScore, currentLevel, speeltijd and Lives are stored in userDefaults*/

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet var displayDices: [UIImageView]!
    @IBOutlet var YatzeeLabel: UILabel!
    @IBOutlet var butslabel: [UIButton]!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var kiesLabel: opmaakButton!
    @IBOutlet var cancelLabel: opmaakButton!
    @IBOutlet var opnieuwLabel: opmaakButton!
    @IBOutlet var higScoreLabel: UILabel!
    @IBOutlet var livesLabel: UILabel!
    @IBOutlet var currentLevelLabel: UILabel!

    //views for animation timerbeam
    let greyTimerRect = UIView()
    var blueTimerRect = UIView()
    var blurEffectView = UIVisualEffectView()

    //view for feedback to player after game is finished. Label for it's text.
    var bonusView = UIImageView()
    var toWorldTwo: UIButton!
    var label = UILabel()
    var button = UIButton()
    
    var timer = Timer() //Timer for playing time
    var timer2 = Timer() //Timer voor audio time running out
    
    var opnieuwButTile: String = "Opnieuw" {
        didSet {
            opnieuwLabel.setTitle(opnieuwButTile, for: UIControlState())
        }
    }
    
    var score: Int = 0 {
        didSet {
           scoreLabel.text = "Score: \(score)"
        }
    }
    var speelTijd: Double = Settings.World1.speeltijd {
        didSet {
            defaults.set(speelTijd, forKey: "newSpeelTijd")
        }
    }
    
    //check for highscore. If set, then store it and update UI
    var highScore: Int = 0 {
        didSet {
            higScoreLabel.text = "HighScore: \(highScore)"
            defaults.set(highScore, forKey: "newHighScore")
        }
    }
    var currentLevel: Int = 1 {
        didSet {
            levelsLeft.text = "Levels left: \(Settings.World1.noOfLevels - currentLevel)"
            currentLevelLabel.text = "Level \(currentLevel)"
            defaults.set(currentLevel, forKey: "newCurrentLevel")
            
        }
    }
    
    
    
    var targetScore: Int = Settings.World1.targetScore {
        didSet {
            
        }
    }
    //maximum of 10 lives
    var lives: Int = Settings.World1.startAmountLives {
        didSet {
            switch lives {
            case 0:
                isAlive = false
            case 10...25:
                lives = 10
            default:
                break
            }
            livesLabel.text = "Lives: \(lives)"
            defaults.set(lives, forKey: "newLivesAmount")
        }
    }
    
    @IBOutlet var levelsLeft: UILabel!

    // preSelectedNumbers zijn de nummers die geselecteerd worden. Deze worden opgeslagen in deze tijdelijke array die geleegd wordt als de user cancelt of definitief kiest. Dan worden de waarden en plaatsen  opgeslagen in de array selectedNumbers.
    //counter: om door de array RandomNumbers te bladeren en daar images aan toe te kennen. RandomNumbers: een array van 15 random nummers tussen 1 en 6 om later de dobbelstenen te kunnen vullen. preSelectednumbers: Tijdelijke bewaar array om in een selectie bij te houden welke nummers geselecteerd zijn. SelectedNumbers: Indien op Kies is gedrukt, is de selectie van nummers definitief en wordt deze array gevuld om bij te houden welke cijfers gebruikt zijn.
    var counter = 0
    var randomNumbers = [Int]()
    var preSelectedNumbers = [Int]()
    var selectedNumbers = [Int]()
    var selectedPlace = [Int]()
    var defSelectedPLace = [Int]()
    
    //To check if combination is possible and player is foutloos
    var isPair = false
    var isThreeOfAKind = false
    var isCarre = false
    var isKleineStraat = false
    var isgroteStraat = false
    var isFullHouse = false
    var isYatzee = false
    
    var isFoutloos = true
    var isAlive = true
    
    //Set after the game in Afterfinished(). Gives a wrap-up of the result achieved.
    var foutText: String = ""
    
    //To switch on the reason the game stopped. Can be on of three reasons; 1] No possible combi's left (zettenOp) 2]No dices left (nulOver) or 3] Time's up(timeOut). Afterfinished() is called which handles the 3 cases.
    var stopReason: String = "" {
        didSet {
            afterFinished()
        }
    }
    //Important! As long as it is true, the game continues (the choose-button is active'). Defaults is memory for highscore, lives, currentlevel.
    var levelActive: Bool = true
    let defaults = UserDefaults.standard //scores en dergelijk
    
    //All variabels for the settings-menu popping out and in, and for setting it's sound and music values (on or off)
    var settingsBtn = UIButton()
    var setMusicBtn = UIButton()
    var setSoundBtn = UIButton()
    var setOverigBtn = UIButton()
    var btn2Image = Settings.SettingsSetUp.musicOnImg
    var btn3Image = Settings.SettingsSetUp.soundOnImg
    var btn4Image = Settings.SettingsSetUp.scoreImg
    var imageView = UIImageView()
    var isPoppedOut = false
    var musicOn: Bool = true {
        didSet {
            print("Muziek aan \(musicOn)")
        }
    }
    var soundOn: Bool = true {
        didSet {
            print("Sound aan \(soundOn)")
        }
    }
    
    
    
    let settingsDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //block of code to set-up the settings foldout and load it's memmory settings for sound/music on/off
        setSoundAndMusicSettings()
        

        //set higscores, levels, lives form userdefaults
        currentLevelLabel.text = "Level \(currentLevel)"
        livesLabel.text = "Lives \(lives)"
        //Create storage in userdefaults and load level when starting up app.
        let hs = defaults.integer(forKey: "newHighScore")
        let cl = defaults.integer(forKey: "newCurrentLevel")
        let st = defaults.double(forKey: "newSpeelTijd")
        let cla = defaults.integer(forKey: "newLivesAmount")
        
        if st != 0.0 {
            speelTijd = st
        }
        if cl != 0 {
            currentLevel = cl
        }
        if cla != 0 {
            lives = cla
        }

        highScore = hs
        print("Eerste speeltijd: \(speelTijd)")
        loadLevel()
        
    }
    
    func addBlurview() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, belowSubview: settingsBtn)
    }
    
    func removeBlurview() {
        blurEffectView.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //User taps to confirm combination. 1. Score wordt gecheckt 2. Alles waarden worden gereset of op 0 gezet. 3. de arrays selectednumbers en ..places (waarden en plaats) worden gevuld. 4. checkGameStatus checkt of er nog combis mogelijk zijn. Zo niet -> disables de UI tijdenlijk tot het volgende level wordt geopend.
    @IBAction func kies(_ sender: AnyObject) {
        myAdvancedAnimations.addWobblingAnimation(kiesLabel)
        if levelActive == true {
            checkScore()
            resetToFalse()
            emptyDisplayDices()
            selectedNumbers += preSelectedNumbers
            defSelectedPLace += selectedPlace
            print("Selectednumbers \(selectedNumbers)")
            print("Definitive selected places: \(defSelectedPLace)")
            
            checkGameStatus() //Check of er nog combinaties mogelijk zijn
            
            preSelectedNumbers = []
            selectedPlace = []
            
        } else {
            
            stopReason = "zettenOp"
        }
    }
    @IBAction func cancel(_ sender: AnyObject) {
        myAdvancedAnimations.addWobblingAnimation(cancelLabel)
        emptyDisplayDices()
        if soundOn { myPLayer.playMeAlso(file: Settings.AudioStrings.cancelSound, ext: "wav") }
        for i in selectedPlace {
            let timeRate = 0.05
            UIView.animate(withDuration: timeRate * Double(i), animations: {
                myAdvancedAnimations.addWobblingAnimation(self.butslabel[i])
                self.butslabel[i].alpha = 1.0
                self.butslabel[i].isUserInteractionEnabled = true
            })
            
            
        }
        preSelectedNumbers = []
        selectedPlace = []
    }
    //1.plays sound on tap 2. clears label 3. fills arr preselectednumbers/selectedplaces which keeps track of numbers selected and the place they're at. 4. Fill arr of UIImageViews which displays the selected dices. 5. When more than 5 selected, empties arrays.
    @IBAction func numberSelected(_ sender: AnyObject) {
        if levelActive == true {
            if preSelectedNumbers.count <= 4 {
                print("works")
                if soundOn == true { myPLayer.playMe(file: Settings.AudioStrings.selectDiceSound, ext: "wav")}
                YatzeeLabel.text = ""
                preSelectedNumbers.append(randomNumbers[sender.tag])
                selectedPlace.append(sender.tag)
                let tempImView = displayDices[preSelectedNumbers.count - 1]
                let img = UIImage(named: "dice\(randomNumbers[sender.tag])")
                tempImView.image = img
                
                print("preselectednumbers \(preSelectedNumbers)")
                print("on place \(selectedPlace)")
                
                myAdvancedAnimations.addWobblingAnimation(butslabel[sender.tag])
                butslabel[sender.tag].transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                UIView.animate(withDuration: 0.2, animations: {
                    self.butslabel[sender.tag].alpha = 0.0
                    self.butslabel[sender.tag].isUserInteractionEnabled = false
                })
                
            } else {
                emptyDisplayDices()
                for i in selectedPlace {
                    
                    butslabel[i].alpha = 1.0
                    butslabel[i].isUserInteractionEnabled = true
                
                    butslabel[i].isUserInteractionEnabled = true
                    butslabel[i].alpha = 1.0
                }
                if soundOn == true { myPLayer.playMe(file: Settings.AudioStrings.selectDiceSound, ext: "wav")}
                preSelectedNumbers = []
                selectedPlace = []
                alertExt("Je kunt maximaal 5 dobbelstenen selecteren!", title: "Let op!!")
                
            }
        }

    }
    //wordt opgeroepen nadat 'stopReason' wordt gezet. Dwz; het spel is gestopt om één van de vlgd redenen: geen zetten meer mogelijk, geen tijd meer over, alles weggespeeld. Zorgt voor check op 1.einde wereld (worldOneComplete wordt dan uitgevoerd), 2. puntenaftrek voor overgbleven stenen (scorereduce) 3. maakt teksten voor displaylabel, roept bonus-animaties op. 4. leegt voor volgende ronde. 5. setButTit (opnieuw of vlgd level).
    func afterFinished() {
        
        var bonusText = [
            "Your target was \(Settings.World1.targetScore) and guess what.. you scored \(score) points so you made it!\n\nUp to the next level..",
            "You blew it!\n\nYou just came \(Settings.World1.targetScore - score) short of a blast achievement. \n\nBut dry your tears and try again!",
            "You made a tiny mistake, with great consequences. \n\n\(foutText) is not a real combination dummy!",
            "You're on a roll!!\n\nYou won an extra live and without a doubt may proceed to the next level!",
            "You thought you made it, didn't you?\n\nBut \(foutText) is not a real combination dummy! Try again!",
            "You're a bit of a snail...\n\nBut the good news is, you still had more points than the targetscore. So hurry up to the next level!",
            "You're as slow as a snail on sanding paper. Hurry up next time!"]
        
        
        levelActive = false
        blueTimerRect.layer.removeAllAnimations()
        prepareForNextRound()
        timer2.invalidate()
        timer.invalidate()
        
        // Alle levels gehaald, -> (dit werkt goed, er vindt geen animatie plaats)
        if score >= Settings.World1.targetScore && isFoutloos == true && currentLevel == Settings.World1.noOfLevels  {
            worldOneComplete()
            
            } else {
                switch stopReason {
                case "zettenOp":
                setButTit()
                checkForHighScore()
                
                if lives == 0 {
                    newBeginning()
                } else {
                    if score >= Settings.World1.targetScore && isFoutloos == true {
                        bonus(imName: Settings.Images.bonusLeeg, text: bonusText[0] , soundName: Settings.AudioStrings.levelUp, ext: "wav", seconds: 0.6)
                        
                    } else if score < Settings.World1.targetScore && isFoutloos == true {
                        bonus(imName: Settings.Images.bonusLeeg, text: bonusText[1], soundName: Settings.AudioStrings.levelFail, ext: "wav", seconds: 0.6)
                        
                    } else {
                        bonus(imName: Settings.Images.bonusLeeg, text: bonusText[2], soundName: Settings.AudioStrings.levelFail, ext: "wav", seconds: 0.6)
                    }
                }
                

                case "nulOver":
                setButTit()
                checkForHighScore()
                
                if lives == 0 {
                    newBeginning()
                } else {
                    if isFoutloos == true {
                        bonus(imName: Settings.Images.bonusLeeg, text: bonusText[3], soundName: Settings.AudioStrings.levelUp, ext: "wav", seconds: 0.6)
                        lives += 1
                    } else {
                        bonus(imName: Settings.Images.bonusLeeg, text: bonusText[4], soundName: Settings.AudioStrings.levelFail, ext: "wav", seconds: 0.6)
                        //opnieuwLabel.hidden = false
                    }
                }
                
                case "timeOut":
                setButTit()
                print("score\(score)")
                print("Lives: \(lives)")
                
                checkForHighScore()
                if lives == 0 {
                    newBeginning()
                } else {
                    let allPlaces = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
                    let setA = Set(allPlaces)
                    let setB = Set(self.defSelectedPLace)
                    let diff = setA.subtracting(setB)
                    for number in diff {
                        self.butslabel[number].isEnabled = false
                        //self.butslabel[number].hidden = true
                    }
                    
                    preSelectedNumbers = []
                    selectedPlace = []
                    
                    if score >= Settings.World1.targetScore && isFoutloos == true {
                        bonus(imName: Settings.Images.bonusLeeg, text: bonusText[5], soundName: Settings.AudioStrings.levelUp, ext: "wav", seconds: 0.6)
                    } else {
                        bonus(imName: Settings.Images.bonusLeeg, text: bonusText[6], soundName: Settings.AudioStrings.timeOut, ext: "wav", seconds: 0.6)
                    }
                    
                    //opnieuwLabel.hidden = false
                }
                
             
            default:
                break
            }
        }
    }
    // Checkt op de gekozen combinatie als op 'kies' wordt gedrukt. Bepaalt de score en of er een fout wordt gemaakt. In geval van een fout is het level niet meer haalbaar. Zorgt ook voor punten aftrek bij foute combinatie..
    func checkScore() {
        var numberLength: Int = 0
        numberLength = preSelectedNumbers.count
        switch numberLength {
        case 0:
            print("was 0")

        case 1:
            print("was 1")
            isFoutloos = false
        case 2:
            pairCheck(preSelectedNumbers)
        case 3:
            threeOfAKindCheck(preSelectedNumbers)
        case 4:
            kleineStraatCheck(preSelectedNumbers)
            carreCheck(preSelectedNumbers)
            if !isKleineStraat && !isCarre {
                noScore()
                score -= (preSelectedNumbers[0] + preSelectedNumbers[1] + preSelectedNumbers[2] + preSelectedNumbers[3])
                isFoutloos = false
                foutText = "\(preSelectedNumbers[0]), \(preSelectedNumbers[1]), \(preSelectedNumbers[2]), \(preSelectedNumbers[3]), "
            }
        case 5:
            groteStraatCheck(preSelectedNumbers)
            yatzeeCheck(preSelectedNumbers)
            fullhouseCheck(preSelectedNumbers)
            if !isFullHouse && !isYatzee && !isgroteStraat {
                noScore()
                score -= (preSelectedNumbers[0] + preSelectedNumbers[1] + preSelectedNumbers[2] + preSelectedNumbers[3] + preSelectedNumbers[4])
                isFoutloos = false
                foutText = "\(preSelectedNumbers[0]), \(preSelectedNumbers[1]), \(preSelectedNumbers[2]), \(preSelectedNumbers[3]), \(preSelectedNumbers[4])"
            }
        default:
            alertExt("Kies minimaal 2 en maximaal 5 getallen!", title: "Te veel getallen!")
        }
    }
    func checkForHighScore() {
        if score > highScore {
            highScore = score
        }
    }
    //Verandert opniewButton title naar volgende level als het huidige level is gehaald.
    func setButTit() {
        if score >= targetScore && isFoutloos {
            opnieuwButTile = "Volgende level"
        } else {
            opnieuwButTile = "Opnieuw"
            lives -= 1
        }
    }
    
    func levelSucceeded() {
        if score >= targetScore && isFoutloos {
            currentLevel += 1
            if speelTijd > 25 {
                speelTijd = speelTijd - Settings.World1.speelTijdReduction
                print("Nieuwe speeltijd: \(speelTijd)")
                
                
            } else {
                speelTijd = speelTijd - Settings.World1.speelTijdReduction2
                print("Nieuwe speeltijd: \(speelTijd)")
            }
        } else {
            print("Oude Speeltijd: \(speelTijd)")
        }
        
    }
    func startTimers() {
        timer = Timer.scheduledTimer(timeInterval: speelTijd, target: self, selector: #selector(ViewController.timeOut), userInfo: nil, repeats: false)
        timer2 = Timer.scheduledTimer(timeInterval: speelTijd*Settings.World1.tijdnoodFactor, target: self, selector: #selector(ViewController.timeIsRunningOut), userInfo: nil, repeats: false)
    }
    func stopAudioplayer () {
        if let thisPlayer = myPLayer.playerAlways {
            if thisPlayer.isPlaying {
                thisPlayer.stop()
            }
        }
    }
   
    func loadLevel() {
        levelSucceeded()
        isFoutloos = true
        startTimers()
        makeTimerRects()
        if soundOn == true { myPLayer.playMe(file: Settings.AudioStrings.dicesThrown, ext: "wav")}
        levelActive = true
        resetToFalse()
        opnieuwLabel.isHidden = true
        YatzeeLabel.isHidden = false
        YatzeeLabel.text = "Nieuwe ronde!"
        levelsLeft.text = "Levels left: \(Settings.World1.noOfLevels - currentLevel + 1)"
        score = 0
        cancelLabel.isEnabled = true
        kiesLabel.isEnabled = true
        cancelLabel.isHidden = false
        kiesLabel.isHidden = false
        
        button.isHidden = true
        button.isEnabled = false
        button.removeFromSuperview()
        
        for _ in 0...14 {
            let number = Int.random(min: 1, max: 6)
            randomNumbers.append(number)
            print(randomNumbers)
        }
        
        for butt in self.butslabel {
            let image = UIImage(named: "dice\(self.randomNumbers[self.counter]).png")
            butt.setBackgroundImage(image, for: UIControlState())
            butt.setTitle("", for: UIControlState())
            butt.isUserInteractionEnabled = true
            butt.alpha = 1.0
            butt.isEnabled = true
            self.counter += 1
        }
        
    }
    
    //checkt na iedere kiesronde of er nog combi's mogelijk zijn. Zo niet dan wordt stopReason gezet (reden waarom het spel stopt) en wordt levelActive false geset om
    func checkGameStatus() {
        let allPlaces = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
        var remValues = [Int]()
        let setA = Set(allPlaces)
        let setB = Set(defSelectedPLace)
        let diff = setA.subtracting(setB)
        print("Remaining places: \(diff)")
        for number in diff {
            remValues.append(randomNumbers[number])
        }
        print("Remaining values: \(remValues)")
        
        switch remValues.count {
        case 0:
            levelActive = false
            score += 20
            stopReason = "nulOver"
            for place in diff {
                butslabel[place].isUserInteractionEnabled = false
                butslabel[place].alpha = 0.0
            }
            remValues = []
        case 1:
            levelActive = false
            score -= remValues.reduce(0, +)
            stopReason = "zettenOp"
            for place in diff {
                butslabel[place].isUserInteractionEnabled = false
                butslabel[place].alpha = 0.0
            }
            remValues = []
        case 2:
            if remValues[0] != remValues[1] {
                
                levelActive = false
                score -= remValues.reduce(0, +) //maakt een getal van de inhoud van de array
                stopReason = "zettenOp"
                remValues = []
                for place in diff {
                    butslabel[place].isUserInteractionEnabled = false
                    butslabel[place].alpha = 0.0
                }
                
            }
        case 3:
            if remValues[0] != remValues[1] && remValues[0] != remValues[2] && remValues[1] != remValues[2] {
                for place in diff {
                    butslabel[place].isUserInteractionEnabled = false
                    butslabel[place].alpha = 0.0
                }
                levelActive = false
                score -= remValues.reduce(0, +)
                stopReason = "zettenOp"
                remValues = []
            }
        case 4:
            var sortedNumbers = remValues.sorted(by: {$0 < $1})
            if sortedNumbers[0] == sortedNumbers[1] || sortedNumbers[0] == sortedNumbers[2] || sortedNumbers[0] == sortedNumbers[3] || sortedNumbers[1] == sortedNumbers[2] || sortedNumbers[1] == sortedNumbers[3] || sortedNumbers[2] == sortedNumbers[3] || ((sortedNumbers[1] - sortedNumbers[0]) == 1 && (sortedNumbers[2] - sortedNumbers[1]) == 1 && (sortedNumbers[3] - sortedNumbers[2] == 1)) {
                        levelActive = true
                            
                        } else {
                            for place in diff {
                                butslabel[place].isUserInteractionEnabled = false
                                butslabel[place].alpha = 0.0
                            }
                            score -= remValues.reduce(0, +)
                            levelActive = false
                            stopReason = "zettenOp"
                            remValues = []
            }
        case 5:
            var sortedNumbers = remValues.sorted(by: {$0 < $1})
            if (sortedNumbers[0] == 1 && sortedNumbers[1] == 2 && sortedNumbers [2] == 3 && sortedNumbers [3] == 5 && sortedNumbers[4] == 6) || (sortedNumbers[0] == 1 && sortedNumbers[1] == 2 && sortedNumbers [2] == 4 && sortedNumbers [3] == 5 && sortedNumbers[4] == 6) {
                for place in diff {
                    butslabel[place].isUserInteractionEnabled = false
                    butslabel[place].alpha = 0.0
                }
                levelActive = false
                score -= remValues.reduce(0, +)
                stopReason = "zettenOp"
                remValues = []
            }
        
        default:
            break
        }
        
    }
    //maakt tijdelijke array van dices (images) als speler kiest of aan einde level.
    func emptyDisplayDices() {
        for dice in displayDices {
            dice.image = UIImage(named: "")
        }
    }

    
    @IBAction func opnieuwTap(_ sender: AnyObject) {
        loadLevel()
    }
    //prepare for next round. empty all arrays, set counter to 0 and dis- and enable buttons of labels.
    func prepareForNextRound() {
        stopAudioplayer()
        emptyDisplayDices()
        cancelLabel.isEnabled = false
        kiesLabel.isEnabled = false
        isAlive = true
        preSelectedNumbers.removeAll()
        randomNumbers.removeAll()
        defSelectedPLace.removeAll()
        selectedNumbers.removeAll()
        selectedPlace.removeAll()
        counter = 0
    }

}

