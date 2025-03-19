import UIKit

class MinasUICollectionViewController: UICollectionViewController {

   @IBOutlet weak var tiempoTranscurrido: UILabel!
   // Crea una instancia del tablero del juego
    var gameBoard: GameBoard!
    let rows = 10
    let columns = 10
    var timer: Timer?
    var elapsedSeconds = 0

    override func viewDidLoad() {
       super.viewDidLoad()
               gameBoard = GameBoard(rows: rows, columns: columns, numberOfMines: 15)
               gameBoard.printBoard()

               let nib = UINib(nibName: "MinasCollectionViewCell", bundle: nil)
               collectionView.register(nib, forCellWithReuseIdentifier: "MinasCell")

               // Asegurar que el UICollectionView tenga un FlowLayout
               if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                   layout.minimumInteritemSpacing = 2
                   layout.minimumLineSpacing = 2
               }
       
       startTimer()
    }
    
   override func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1  // Solo una sección para manejar todas las celdas
       }

       override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return rows * columns // Se manejan todas las celdas en una sección
       }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MinasCell", for: indexPath) as! MinasCollectionViewCell

              let row = indexPath.item / columns
              let column = indexPath.item % columns
              let cellData = gameBoard.cells[row][column]
              cell.configure(with: cellData)
              return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let row = indexPath.item / columns
              let column = indexPath.item % columns
              let cellData = gameBoard.cells[row][column]

              if cellData.isMine {
                  showGameOver()
              } else {
                  gameBoard.revealCell(atRow: row, column: column)
                  collectionView.reloadData()
                  if checkVictory() {
                      showVictory()
                  }
              }
          }
   
   
   private func startTimer() {
       timer?.invalidate() // Detiene cualquier temporizador existente
       elapsedSeconds = 0
       updateTimeLabel()
       timer = Timer.scheduledTimer(
           timeInterval: 1.0,
           target: self,
           selector: #selector(updateTimer),
           userInfo: nil,
           repeats: true
       )
   }
   
   @objc private func updateTimer() {
       elapsedSeconds += 1
       updateTimeLabel()
   }
   
   private func updateTimeLabel() {
      tiempoTranscurrido.text = "Tiempo: \(formattedTime(seconds: elapsedSeconds))"
   }
   
   
   
   
   private func checkVictory() -> Bool {
           for row in gameBoard.cells {
               for cell in row {
                   if !cell.isMine && !cell.isRevealed {
                       return false
                   }
               }
           }
           return true
       }

   private func showGameOver() {
       timer?.invalidate() // Detener temporizador
       
       // Revelar todas las minas
       for row in 0..<rows {
           for column in 0..<columns {
               if gameBoard.cells[row][column].isMine {
                   gameBoard.cells[row][column].isRevealed = true
               }
           }
       }
       collectionView.reloadData()

       // Mensaje con tiempo transcurrido
      let message = "Has pisado una mina. Tiempo: \(formattedTime(seconds: elapsedSeconds))"
       let alert = UIAlertController(title: "¡Game Over!", message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "Reiniciar", style: .default, handler: { _ in
           self.restartGame()
       }))
       present(alert, animated: true, completion: nil)
   }

   private func showVictory() {
       timer?.invalidate() // Detener temporizador
       
      let message = "¡Felicidades! Tiempo: \(formattedTime(seconds: elapsedSeconds))"
       let alert = UIAlertController(title: "¡Ganaste!", message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "Reiniciar", style: .default, handler: { _ in
           self.restartGame()
       }))
       present(alert, animated: true, completion: nil)
   }

   private func restartGame() {
       gameBoard = GameBoard(rows: rows, columns: columns, numberOfMines: 15)
       gameBoard.printBoard()
       collectionView.reloadData()
       startTimer() // Reiniciar temporizador al reiniciar juego
   }
   
   
   private func formattedTime(seconds: Int) -> String {
       let minutes = (seconds / 60) % 60
       let seconds = seconds % 60
       return String(format: "%02d:%02d", minutes, seconds)
   }
   
    @IBAction func reiniciarJuego(_ sender: UIButton) {
        restartGame()
    }

    @IBAction func regresarInicio(_ sender: UIButton) {
         timer?.invalidate()
         dismiss(animated: true, completion: nil)
     }

}
extension MinasUICollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 2
        let horizontalSpacing = CGFloat(columns - 1) * spacing
        let verticalSpacing = CGFloat(rows - 1) * spacing
        
        // Calcula el espacio disponible considerando el espaciado
        let availableWidth = collectionView.bounds.width - horizontalSpacing
        let availableHeight = collectionView.bounds.height - verticalSpacing
        
        // Determina el tamaño de la celda basado en la dimensión más restrictiva
        let cellWidth = availableWidth / CGFloat(columns)
        let cellHeight = availableHeight / CGFloat(rows)
        let cellSize = min(cellWidth, cellHeight)
        
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let cellSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0))
        
        // Calcula el tamaño total del grid incluyendo espaciado
        let totalGridWidth = CGFloat(columns) * cellSize.width + CGFloat(columns - 1) * layout.minimumInteritemSpacing
        let totalGridHeight = CGFloat(rows) * cellSize.height + CGFloat(rows - 1) * layout.minimumLineSpacing
        
        // Calcula márgenes para centrar el grid
        let horizontalInset = (collectionView.bounds.width - totalGridWidth) / 2
        let verticalInset = (collectionView.bounds.height - totalGridHeight) / 2
        
        return UIEdgeInsets(
            top: max(verticalInset, 0),
            left: max(horizontalInset, 0),
            bottom: max(verticalInset, 0),
            right: max(horizontalInset, 0))
    }
    
    // Mantén los demás métodos del delegate sin cambios
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
