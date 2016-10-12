//
//  CreateMemeViewController.swift
//  MemeMe
//
//  Created by Heike Bernhard on 13/09/16.
//  Copyright © 2016 stufengrau. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var memeTopTextField: MemeTextField!
    var memeBottomTextField: MemeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        memeTopTextField = MemeTextField(textField: topTextField)
        memeBottomTextField = MemeTextField(textField: bottomTextField)
        topTextField.delegate = memeTopTextField
        bottomTextField.delegate = memeBottomTextField
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        // Enable camera button only if camera is available.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        // Disable share button if no image is selected.
        if photoImageView.image == nil {
            shareButton.enabled = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        photoImageView.image = selectedImage
        // Enable share button after an image was selected.
        shareButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: NSNotification - Keyboard Notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateMemeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateMemeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // Bottom text field should be visible when editing -> shift view up
        if bottomTextField.editing {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    // MARK: Actions
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        pickImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
    }

    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        pickImageFromSource(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        // Generate meme for sharing.
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
        // Save the meme after sharing.
        activityController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            if completed {
                self.save(memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }

    
    // MARK: Generate and save the Meme
    // So far the save function doesn't do anything useful ... maybe in Version 2 of MemeMe
    func save(image: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, photo: photoImageView.image!, memedPhoto: image)
    }
    
    func generateMemedImage() -> UIImage {
        // Render view without the toolbar to an image.
        toolbar.hidden = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolbar.hidden = false
        
        return memedImage
    }
    
    // MARK: Helper
    func pickImageFromSource(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }    

}

