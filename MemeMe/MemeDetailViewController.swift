//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Heike Bernhard on 16/10/2016.
//  Copyright © 2016 stufengrau. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var meme: Meme!

    @IBOutlet weak var detailedMeme: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        detailedMeme.image = meme.memedPhoto
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

}
