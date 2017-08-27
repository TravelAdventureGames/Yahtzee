//
//  Randoms.swift
//  Yahtzee
//
//  Created by Martijn van Gogh on 23-04-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import Foundation

extension Int {
    
    static func random(min: Int, max: Int) -> Int {
        if max < min { return min }
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
}


