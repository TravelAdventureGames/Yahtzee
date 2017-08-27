//
//  AlertHelper.swift
//  Protobarendt
//
//  Created by Martijn van Gogh on 19-01-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

extension UIViewController {
    
    func alertExt(_ message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
