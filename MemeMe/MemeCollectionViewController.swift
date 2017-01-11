//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Heike Bernhard on 15/10/2016.
//  Copyright © 2016 stufengrau. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGridLayout(view.frame.size)
    }
    
    // Set correct flowLayout when orientation changed.
    // http://stackoverflow.com/questions/25666269/ios8-swift-how-to-detect-orientation-change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // If the collection view was not visited but the orientation of the device changed, e.g. when 
        // creating a meme, flowLayout ist nil and app crashed -> test if flowLayout is nil
        if flowLayout != nil {
            setGridLayout(size)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // To show newly created memes, reload data.
        collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.generatedMemeImage.image = meme.memedPhoto
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // If a meme got selected show a detailed (in this case bigger) view of the meme.
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailVC.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: Helper
    
    func setGridLayout(_ size: CGSize) {
        
        let spacing: CGFloat = 3.0
        let numberPortrait: CGFloat = 3.0
        let numberLandscape: CGFloat = 5.0
        let frameWidth = size.width
        let frameHeight = size.height
        var dimension: CGFloat
        
        // Set grid layout based on orientation.
        if (frameHeight > frameWidth) {
            dimension = (frameWidth - ((numberPortrait - 1) * spacing)) / numberPortrait
        } else {
            dimension = (frameWidth - ((numberLandscape - 1) * spacing)) / numberLandscape
        }
        
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

}
