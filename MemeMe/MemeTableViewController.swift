//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Heike Bernhard on 12/10/2016.
//  Copyright © 2016 stufengrau. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // To show newly created memes, reload data.
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "MemeTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MemeTableViewCell
        
        let meme = memes[indexPath.row]
        
        cell.generatedMeme.image = meme.memedPhoto
        cell.generatedMemeText.text = "\(meme.topText) ... \(meme.bottomText)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If a meme got selected show a detailed (in this case bigger) view of the meme.
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailVC.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove shared meme form to the memes array in the Application Delegate.
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
