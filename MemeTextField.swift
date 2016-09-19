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
    let memeTextAttributes = [NSStrokeColorAttributeName: UIColor.blackColor(), NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Impact", size: 40)!, NSStrokeWidthAttributeName: -3.0]
    
    // MARK: Initialization
    init(textField: UITextField) {
        self.textField = textField
        self.textField.defaultTextAttributes = memeTextAttributes
        self.textField.textAlignment = NSTextAlignment.Center
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "BOTTOM" || textField.text == "TOP") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
