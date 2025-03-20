//
//  RecordTableViewCell.swift
//  Proyecto2
//
//  Created by Tobias Rodriguez Lujan on 19/03/25.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

   @IBOutlet weak var name: UILabel!
   @IBOutlet weak var record: UILabel!
   
   override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
   
    
}
