//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Heike Bernhard on 16/10/2016.
//  Copyright © 2016 stufengrau. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!

    @IBOutlet weak var detailedMeme: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = true
        detailedMeme.image = meme.memedPhoto
    }
    
    override func viewWillDisappear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
