import UIKit
// Definimos la estructura Cell para cada casilla
struct Cell {
    var isMine: Bool = false
    var isRevealed: Bool = false
    var isFlagged: Bool = false
    var adjacentMines: Int = 0
}
class GameBoard: NSObject {
    // Propiedades del tablero
    var cells: [[Cell]]
    let rows: Int
    let columns: Int
    let numberOfMines: Int

    // Inicializador
    init(rows: Int, columns: Int, numberOfMines: Int) {
        self.rows = rows
        self.columns = columns
        self.numberOfMines = numberOfMines
        self.cells = Array(repeating: Array(repeating: Cell(), count: columns), count: rows)
        super.init()  // Llamar al inicializador de NSObject
        setupBoard()
    }
    
    // Configura el tablero colocando minas y calculando las celdas adyacentes
    private func setupBoard() {
        var minesToPlace = numberOfMines
        while minesToPlace > 0 {
            let r = Int.random(in: 0..<rows)
            let c = Int.random(in: 0..<columns)
            if !cells[r][c].isMine {
                cells[r][c].isMine = true
                minesToPlace -= 1
            }
        }
        for row in 0..<rows {
            for col in 0..<columns {
                cells[row][col].adjacentMines = countAdjacentMines(row: row, col: col)
            }
        }
    }
    
    // Cuenta las minas adyacentes a una celda dada
    private func countAdjacentMines(row: Int, col: Int) -> Int {
        var count = 0
        for i in max(row - 1, 0)...min(row + 1, rows - 1) {
            for j in max(col - 1, 0)...min(col + 1, columns - 1) {
                if cells[i][j].isMine { count += 1 }
            }
        }
        return count
    }
    
    // Método para revelar celdas de forma recursiva
    func revealCell(atRow row: Int, column col: Int) {
        guard row >= 0, row < rows, col >= 0, col < columns else { return }
        if cells[row][col].isRevealed { return }
        cells[row][col].isRevealed = true
        
        if cells[row][col].adjacentMines == 0 && !cells[row][col].isMine {
            for i in max(row - 1, 0)...min(row + 1, rows - 1) {
                for j in max(col - 1, 0)...min(col + 1, columns - 1) {
                    revealCell(atRow: i, column: j)
                }
            }
        }
    }
    func printBoard() {
        print(" ")
        for row in cells {
            var rowText = ""
            for cell in row {
                if cell.isMine {
                    rowText += "* "
                } else if cell.adjacentMines > 0 {
                    rowText += "\(cell.adjacentMines) "
                } else {
                    rowText += "░ "
                }
            }
            print(rowText)
        }
    }

}
