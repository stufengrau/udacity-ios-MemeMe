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
    
    var memeTopTextField: MemeTextField!
    var memeBottomTextField: MemeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        memeTopTextField = MemeTextField(textField: topTextField)
        memeBottomTextField = MemeTextField(textField: bottomTextField)
        self.topTextField.delegate = self.memeTopTextField
        self.bottomTextField.delegate = self.memeBottomTextField
    }
    
    override func viewWillAppear(animated: Bool) {
        // Enable camera button only if camera is available.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        photoImageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        pickImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
    }

    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        pickImageFromSource(UIImagePickerControllerSourceType.Camera)
    }
    
    // MARK: Helper
    func pickImageFromSource(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
}

