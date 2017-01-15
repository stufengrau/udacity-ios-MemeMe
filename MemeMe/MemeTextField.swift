//
//  MemeTextField.swift
//  MemeMe
//
//  Created by Heike Bernhard on 19/09/16.
//  Copyright © 2016 stufengrau. All rights reserved.
//

import Foundation
import UIKit

class MemeTextField: NSObject, UITextFieldDelegate {
    
    // MARK: Properties
    let textField: UITextField
    let memeTextAttributes = [NSStrokeColorAttributeName: UIColor.black, NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Impact", size: 40)!, NSStrokeWidthAttributeName: -3.0] as [String : Any]
    
    // MARK: Initialization
    init(textField: UITextField, text: String) {
        self.textField = textField
        self.textField.text = text
        self.textField.defaultTextAttributes = memeTextAttributes
        self.textField.textAlignment = NSTextAlignment.center
        self.textField.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: UITextFieldDelegate
    // Clear only default text when user begins editing.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "BOTTOM" || textField.text == "TOP") {
            textField.text = ""
        }
    }
    
    // Dismiss keyboard, if user hits return.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
