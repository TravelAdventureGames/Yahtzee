//
//  MyPlayer.swift
//  Protobarendt
//
//  Created by Martijn van Gogh on 04-12-15.
//  Copyright © 2015 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PlayItNow {
    
    var backgroundPlayer: AVAudioPlayer?
    var player: AVAudioPlayer = AVAudioPlayer()
    var player2: AVAudioPlayer = AVAudioPlayer()
    var playerAlways: AVAudioPlayer?
    
    func playMusicInBackground(file: String, ext: String) {
        guard let file: URL = Bundle.main.url(forResource: file, withExtension: ext) else { return }
        do { backgroundPlayer = try? AVAudioPlayer(contentsOf: file, fileTypeHint: nil)
            
        } catch _ {
            return
        }
        backgroundPlayer!.numberOfLoops = -1
        backgroundPlayer!.prepareToPlay()
        backgroundPlayer!.play()
    }
    
    func playMe(file: String, ext: String) {
        
        let file: URL = Bundle.main.url(forResource: file, withExtension: ext)!
        do { player = try AVAudioPlayer(contentsOf: file, fileTypeHint: nil)
            
        } catch _ {
            return
        }
        player.numberOfLoops = 0
        player.prepareToPlay()
        player.play()
        
    }
    func playMeAlso(file: String, ext: String) {
        
        let file: URL = Bundle.main.url(forResource: file, withExtension: ext)!
        do { player2 = try AVAudioPlayer(contentsOf: file, fileTypeHint: nil)
            
        } catch _ {
            return
        }
        player2.numberOfLoops = 0
        player2.prepareToPlay()
        player2.play()
        
    }
    func playMeForever(file: String, ext: String) {
    
        let file: URL = Bundle.main.url(forResource: file, withExtension: ext)!
        do { playerAlways = try AVAudioPlayer(contentsOf: file, fileTypeHint: nil)
            
        } catch _ {
            return
        }
        playerAlways!.numberOfLoops = -1
        playerAlways!.prepareToPlay()
        playerAlways!.play()
        
    }
}

var myPLayer = PlayItNow()
