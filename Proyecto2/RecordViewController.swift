//
//  RecordViewController.swift
//  Proyecto2
//
//  Created by Tobias Rodriguez Lujan on 19/03/25.
//

import UIKit

class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   @IBOutlet weak var tvRecord: UITableView!
   var records = [[String: Any]]()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           tvRecord.dataSource = self
           tvRecord.delegate = self
           tvRecord.register(UINib(nibName: "RecordTableViewCell", bundle: nil), forCellReuseIdentifier: "Celda")
           loadRecords()
       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           loadRecords()
       }
       
    func loadRecords() {
        let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
        
        let fileURL = documentsDirectory.appendingPathComponent("records.plist")
        
        if let array = NSArray(contentsOf: fileURL) as? [[String: Any]] {
            // Ordena los registros de mayor a menor puntuación
            let sortedArray = array.sorted { (recordA, recordB) -> Bool in
                let punA = recordA["pun"] as? Int ?? 0
                let punB = recordB["pun"] as? Int ?? 0
                return punA > punB
            }
            
            // Se quedan solo con los 5 primeros registros
            records = Array(sortedArray.prefix(5))
        } else {
            records = []
        }
        
        tvRecord.reloadData()
    }

       
       // MARK: - Table view data source
       func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return records.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(
               withIdentifier: "Celda",
               for: indexPath
           ) as! RecordTableViewCell
           
           let record = records[indexPath.row]
           
           cell.name.text = record["nam"] as? String ?? "Sin nombre"
           cell.record.text = "\(record["pun"] as? Int ?? 0)"
           
           return cell
       }
   }
