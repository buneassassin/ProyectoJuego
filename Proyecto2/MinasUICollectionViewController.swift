//
//  MinasUICollectionViewController.swift
//  Proyecto2
//
//  Created by Tobias Rodriguez Lujan on 13/03/25.
//

import UIKit

class MinasUICollectionViewController: UICollectionViewController {

   private let items = Array(0...100)
   
   override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        /*self.collectionView.register(UINib(nibName: "MinasUICollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Celda")*/
        let nib = UINib(nibName: "MinasCollectionViewCell", bundle: nil)
              collectionView.register(nib, forCellWithReuseIdentifier: "MinasCell")

      
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                  layout.itemSize = CGSize(width: 60, height: 60)
                  layout.minimumInteritemSpacing = 2
                  layout.minimumLineSpacing = 1
              }
        // Do any additional setup after loading the view.
    }
    // MARK: UICollectionViewDataSource

   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return items.count
       }
       
       override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MinasCell", for: indexPath) as! MinasCollectionViewCell
           
           // Configuración básica de la celda
           
           
           return cell
       }
       
       // MARK: - Selección
       override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           print("Celda seleccionada: \(indexPath.item)")
       }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
