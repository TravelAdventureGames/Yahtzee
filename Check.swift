//
//  Check.swift
//  Yahtzee
//
//  Created by Martijn van Gogh on 21-04-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import Foundation

extension ViewController {
    
    func noScore() {
        YatzeeLabel.text = "Geen score..."
        if soundOn == true { myPLayer.playMe(file: "error", ext: "wav")}
    }
    func resetToFalse() {
        isPair = false
        isThreeOfAKind = false
        isCarre = false
        isKleineStraat = false
        isgroteStraat = false
        isFullHouse = false
        isYatzee = false
    }
    
    func pairCheck(_ arr: [Int]) {
        if arr[0] == arr[1] {
            YatzeeLabel.text = "One pair!"
            score += arr[0]*2
            if soundOn == true { myPLayer.playMe(file: "win2", ext: "wav")}
            isPair = true
        } else {
            noScore()
            score -= (arr[0] + arr[1])
            isFoutloos = false
            foutText = "\(arr[0]), \(arr[1])"  
        }
    }
    
    func threeOfAKindCheck(_ arr: [Int]) {
        if arr[0] == arr[1] && arr[1] == arr[2] {
            YatzeeLabel.text = "Three of a kind!!"
            score += arr[0]*3
            if soundOn == true { myPLayer.playMe(file: "win2", ext: "wav")}
            isThreeOfAKind = true
        } else {
            noScore()
            score -= (arr[0] + arr[1] + arr[2])
            isFoutloos = false
            foutText = "\(arr[0]), \(arr[1]), \(arr[2])"
            
        }
    }
    
    func carreCheck(_ arr: [Int]) {
        if arr[0] == arr[1] && arr[1] == arr[2] && arr[2] == arr[3] {
            YatzeeLabel.text = "Carré!!"
            score = score + arr[0]*4
            if soundOn == true { myPLayer.playMe(file: "win1", ext: "wav")}
            isCarre = true
            
        }
    }
    
    func kleineStraatCheck(_ arr: [Int]) {
        var sortedNumbers = arr.sorted(by: {$0 < $1})
        if sortedNumbers[1] - sortedNumbers[0] == 1 {
            if sortedNumbers[2] - sortedNumbers[1] == 1 {
                if sortedNumbers[3] - sortedNumbers[2] == 1 {
                    YatzeeLabel.text = "Kleine straat"
                    score += 30
                    if soundOn == true { myPLayer.playMe(file: "win2", ext: "wav")}
                    isKleineStraat = true
                }
            }
        }
        
    }
    
    func groteStraatCheck(_ arr: [Int]) {
        var sortedNumbers = arr.sorted(by: {$0 < $1})
        if sortedNumbers[1] - sortedNumbers[0] == 1 {
            if sortedNumbers[2] - sortedNumbers[1] == 1 {
                if sortedNumbers[3] - sortedNumbers[2] == 1 {
                    if sortedNumbers[4] - sortedNumbers[3] == 1 {
                        YatzeeLabel.text = "Grote straat"
                        score += 40
                        if soundOn == true { myPLayer.playMe(file: "win1", ext: "wav")}
                        isgroteStraat = true
                        
                    }
                }
            }
        }
        
    }
    func fullhouseCheck(_ arr: [Int]) {
        var sortedNumbers = arr.sorted(by: { $0 < $1})
        if sortedNumbers[0] == sortedNumbers[1] && sortedNumbers[0] == sortedNumbers[2] && sortedNumbers[0] != sortedNumbers[4] {
            if sortedNumbers[3] == sortedNumbers[4] {
                YatzeeLabel.text = "Full House!"
                score += 25
                if soundOn == true { myPLayer.playMe(file: "win1", ext: "wav")}
                isFullHouse = true
            }
        } else {
            if sortedNumbers[0] == sortedNumbers[1] {
                if sortedNumbers[2] == sortedNumbers[3] && sortedNumbers[2] == sortedNumbers[4] && sortedNumbers[0] != sortedNumbers[4] {
                    YatzeeLabel.text = "Full House!"
                    score += 25
                    if soundOn == true {myPLayer.playMe(file: "win1", ext: "wav")}
                    isFullHouse = true
                }
            }
        }
    }
    func yatzeeCheck(_ arr: [Int]) {
        if arr[0] == arr[1] && preSelectedNumbers[1] == arr[2] && arr[2] == preSelectedNumbers[3] && arr[3] == arr[4]{
            YatzeeLabel.text = "Yahtzee!!"
            score += 50
            if soundOn == true { myPLayer.playMe(file: "win3", ext: "mp3")}
            isYatzee = true
        }
    }

}
