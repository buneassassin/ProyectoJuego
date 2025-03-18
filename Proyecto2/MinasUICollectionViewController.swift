import UIKit

class MinasUICollectionViewController: UICollectionViewController {

    // Crea una instancia del tablero del juego
    var gameBoard: GameBoard!
    let rows = 10
    let columns = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        gameBoard = GameBoard(rows: rows, columns: columns, numberOfMines: 15)
        gameBoard.printBoard()

        let nib = UINib(nibName: "MinasCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MinasCell")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rows
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columns
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MinasCell", for: indexPath) as! MinasCollectionViewCell
        let cellData = gameBoard.cells[indexPath.section][indexPath.item]
        cell.configure(with: cellData)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellData = gameBoard.cells[indexPath.section][indexPath.item]
        
        if cellData.isMine {
            showGameOver()
        } else {
            gameBoard.revealCell(atRow: indexPath.section, column: indexPath.item)
            collectionView.reloadData()
            if checkVictory() {
                showVictory()
            }
        }
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
        // Revelar todas las celdas que son minas
        for row in 0..<rows {
            for column in 0..<columns {
                if gameBoard.cells[row][column].isMine {
                    gameBoard.cells[row][column].isRevealed = true
                }
            }
        }
        
        // Recargar el CollectionView para reflejar los cambios
        collectionView.reloadData()

        // Mostrar la alerta de Game Over
        let alert = UIAlertController(title: "¡Game Over!", message: "Has pisado una mina.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reiniciar", style: .default, handler: { _ in
            self.restartGame()
        }))
        present(alert, animated: true, completion: nil)
    }

    private func showVictory() {
        let alert = UIAlertController(title: "¡Ganaste!", message: "¡Felicidades, has revelado todas las celdas seguras!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reiniciar", style: .default, handler: { _ in
            self.restartGame()
        }))
        present(alert, animated: true, completion: nil)
    }

    private func restartGame() {
        gameBoard = GameBoard(rows: rows, columns: columns, numberOfMines: 15)
        gameBoard.printBoard()
        collectionView.reloadData()
        
    }
    @IBAction func reiniciarJuego(_ sender: UIButton) {
        restartGame()
    }

    @IBAction func regresarInicio(_ sender: UIButton) {
        // Navegar de regreso al inicio
        dismiss(animated: true, completion: nil)

     }

}

// Extensión para ajustar el tamaño de las celdas dinámicamente
extension MinasUICollectionViewController: UICollectionViewDelegateFlowLayout {
    var numberOfColumns: CGFloat { return 10 }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 2
        let insets: CGFloat = 5 * 2 // 5 puntos de insets a cada lado
        let totalSpacing = (numberOfColumns - 1) * spacing + insets
        let availableWidth = collectionView.bounds.width - totalSpacing
        let cellWidth = availableWidth / numberOfColumns
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
