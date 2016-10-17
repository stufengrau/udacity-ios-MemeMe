//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Heike Bernhard on 12/10/2016.
//  Copyright © 2016 stufengrau. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {


    @IBOutlet weak var generatedMeme: UIImageView!
    @IBOutlet weak var generatedMemeText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
