//
//  MinasCollectionViewCell.swift
//  Proyecto2
//
//  Created by Tobias Rodriguez Lujan on 06/03/25.
//

import UIKit

class MinasCollectionViewCell: UICollectionViewCell {

   @IBOutlet weak var imgEstado: UIImageView!
   
   override func awakeFromNib() {
        super.awakeFromNib()
<<<<<<< HEAD
        // Configuración inicial del label
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .black
        
        // Opcional: Redondear las esquinas de la celda
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    func configure(with cellData: Cell) {
        if cellData.isRevealed {
            if cellData.isMine {
                contentView.backgroundColor = .red
                label.text = "💣"
            } else {
                switch cellData.adjacentMines {
                case 1:
                    contentView.backgroundColor = UIColor.systemGreen
                case 2:
                    contentView.backgroundColor = UIColor.systemYellow
                case 3:
                    contentView.backgroundColor = UIColor.systemOrange
                case 4:
                    contentView.backgroundColor = UIColor.systemPurple
                default:
                    contentView.backgroundColor = .lightGray
                }
                label.text = cellData.adjacentMines > 0 ? "\(cellData.adjacentMines)" : ""
            }
        } else {
            contentView.backgroundColor = .green
           label.text = cellData.isFlagged ? "🚩" : ""
        }
=======
        // Initialization code
>>>>>>> parent of 33fc88b (Merge pull request #5 from buneassassin/origin/China)
    }

}

/*
        if cellData.isRevealed {
            backgroundColor = UIColor.lightGray
            if cellData.isMine {
                label.text = "💣"
                backgroundColor = .red
            } else {
                label.text = cellData.adjacentMines > 0 ? "\(cellData.adjacentMines)" : ""
                setNumberColor(cellData.adjacentMines)
            }
        } else {
            backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            label.text = cellData.isFlagged ? "🚩" : ""
        }
*/
