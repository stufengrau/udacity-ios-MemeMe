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
    @IBOutlet weak var renderView: UIView!
    
    var memeTopTextField: MemeTextField!
    var memeBottomTextField: MemeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create MemeTextField delegate.
        memeTopTextField = createMemeTextField(with: topTextField, defaultText: "TOP")
        memeBottomTextField = createMemeTextField(with: bottomTextField, defaultText: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        // Enable camera button only if camera is available.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        // Disable share button if no image is selected.
        if photoImageView.image == nil {
            shareButton.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        photoImageView.image = selectedImage
        // Enable share button after an image was selected.
        shareButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: NSNotification - Keyboard Notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(CreateMemeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateMemeViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        // Bottom text field should be visible when editing -> shift view up
        if bottomTextField.isEditing {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    // MARK: Actions
    @IBAction func pickImageFromAlbum(_ sender: UIBarButtonItem) {
        pickImageFromSource(UIImagePickerControllerSourceType.photoLibrary)
    }

    @IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {
        pickImageFromSource(UIImagePickerControllerSourceType.camera)
    }
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        // Generate meme for sharing.
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        // Save the meme after sharing.
        activityController.completionWithItemsHandler = {(activityType: UIActivityType?, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if completed {
                self.save(memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

    @IBAction func cancelMeme(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: Generate and save the Meme
    func save(_ image: UIImage) {
        // Create meme.
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, photo: photoImageView.image!, memedPhoto: image)
        
        // Add it to the memes array in the Application Delegate.
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // Render view to an image.

        UIGraphicsBeginImageContext(view.frame.size)
        renderView.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    // MARK: Helper
    func createMemeTextField(with textField: UITextField, defaultText text: String) -> MemeTextField {
        let memeTextField = MemeTextField(textField: textField, text: text)
        textField.delegate = memeTextField
        return memeTextField
    }
    
    func pickImageFromSource(_ source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }    

}

