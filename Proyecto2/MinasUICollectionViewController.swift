//
//  MinasUICollectionViewController.swift
//  Proyecto2
//
//  Created by Tobias Rodriguez Lujan on 13/03/25.
//

import UIKit
import AVFoundation

class MinasUICollectionViewController: UICollectionViewController {
   
   @IBOutlet weak var tiempoTranscurrido: UILabel!
   
   var audioPlayer: AVAudioPlayer?
   var audioEngine = AVAudioEngine()
   let pitchEffect = AVAudioUnitTimePitch()
   var minePlayers = [AVAudioPlayer]()
   let audioQueue = DispatchQueue(label: "audioQueue")
   // Crea una instancia del tablero del juego
   var gameBoard: GameBoard!
   let rows = 10
   let columns = 10
   var timer: Timer?
   var elapsedSeconds = 0
   
   let r = Record.sharedDatos()
   
   
   private func calcularPuntuacion() -> Int {
      let celdasReveladas = gameBoard.cells.flatMap { $0 }.filter { $0.isRevealed && !$0.isMine }.count
      return (celdasReveladas * 3) - (elapsedSeconds + 1) + 2 // Fórmula de ejemplo
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      gameBoard = GameBoard(rows: rows, columns: columns, numberOfMines: 10)
      gameBoard.printBoard()
      
      let nib = UINib(nibName: "MinasCollectionViewCell", bundle: nil)
      collectionView.register(nib, forCellWithReuseIdentifier: "MinasCell")
      
      // Asegurar que el UICollectionView tenga un FlowLayout
      if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
         layout.minimumInteritemSpacing = 2
         layout.minimumLineSpacing = 2
      }
      do {
          try AVAudioSession.sharedInstance().setCategory(.playback)
          try AVAudioSession.sharedInstance().setActive(true)
      } catch {
          print("Error configurando sesión de audio: \(error)")
      }
      
      do {
          try AVAudioSession.sharedInstance().setCategory(
              .playback,
              mode: .default,
              options: [.mixWithOthers, .allowAirPlay]
          )
          try AVAudioSession.sharedInstance().setActive(true)
      } catch {
          print("Error audio session: \(error)")
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
   
   private func playSafeSound() {
       audioQueue.async { [weak self] in
           guard let self = self,
                 let url = Bundle.main.url(forResource: "sound-9", withExtension: "mp3") else { return }
           
           do {
               let randomRate = Float.random(in: 0.9...1.1)
               let randomPitch = Float.random(in: -300...300)
               
               // Nuevo engine por reproducción
               let engine = AVAudioEngine()
               let playerNode = AVAudioPlayerNode()
               let pitchEffect = AVAudioUnitTimePitch()
               
               let audioFile = try AVAudioFile(forReading: url)
               
               pitchEffect.pitch = randomPitch
               
               engine.attach(playerNode)
               engine.attach(pitchEffect)
               
               engine.connect(playerNode, to: pitchEffect, format: nil)
               engine.connect(pitchEffect, to: engine.outputNode, format: nil)
               
               playerNode.scheduleFile(audioFile, at: nil) {
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                       engine.stop()
                       engine.detach(playerNode)
                       engine.detach(pitchEffect)
                   }
               }
               
               try engine.start()
               playerNode.play()
               
               // Rate debe aplicarse así
               playerNode.rate = randomRate
               
               // Retener engine mientras se reproduce
               self.audioEngine = engine
               
           } catch {
               print("Error: \(error.localizedDescription)")
           }
       }
   }

<<<<<<< HEAD
   
   private func playMineSound() {
       guard let url = Bundle.main.url(forResource: "bomba", withExtension: "mp3") else { return }
       
       do {
           let player = try AVAudioPlayer(contentsOf: url)
           player.prepareToPlay()
           minePlayers.append(player) // Retener referencia
           player.play()
       } catch {
           print("Error: \(error.localizedDescription)")
       }
   }
   
   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let row = indexPath.item / columns
      let column = indexPath.item % columns
      let cellData = gameBoard.cells[row][column]
      
      if cellData.isMine {
         playMineSound()
         showGameOver()
      } else {
         playSafeSound()
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
      timer?.invalidate()
      
      // Revelar todas las minas
      for row in 0..<rows {
         for column in 0..<columns {
            if gameBoard.cells[row][column].isMine {
               gameBoard.cells[row][column].isRevealed = true
            }
         }
      }
      collectionView.reloadData()
      
      // Calcular y mostrar puntuación
      r.puntuacion = calcularPuntuacion()
      let mensaje = "Has pisado una mina. Tiempo: \(formattedTime(seconds: elapsedSeconds)). Puntuación: \(r.puntuacion)"
      
      let alert = UIAlertController(title: "¡Game Over!", message: mensaje, preferredStyle: .alert)
      
      // Opción para guardar puntuación
      alert.addAction(UIAlertAction(title: "Guardar Puntuación", style: .default, handler: { _ in
         self.promptForName()
      }))
      
      // Opción para reiniciar sin guardar
      alert.addAction(UIAlertAction(title: "Reiniciar sin Guardar", style: .destructive, handler: { _ in
         self.restartGame()
      }))
      
      present(alert, animated: true, completion: nil)
   }
   
   private func showVictory() {
      timer?.invalidate()
      
      r.puntuacion = calcularPuntuacion() + 30
      let mensaje = "¡Felicidades! Tiempo: \(formattedTime(seconds: elapsedSeconds)). Puntuación: \(r.puntuacion)"
      
      let alert = UIAlertController(title: "¡Ganaste!", message: mensaje, preferredStyle: .alert)
      
      // Opción para guardar puntuación
      alert.addAction(UIAlertAction(title: "Guardar Puntuación", style: .default, handler: { _ in
         self.promptForName()
      }))
      
      // Opción para reiniciar sin guardar
      alert.addAction(UIAlertAction(title: "Reiniciar sin Guardar", style: .destructive, handler: { _ in
         self.restartGame()
      }))
      
      present(alert, animated: true, completion: nil)
   }
   
   private func promptForName() {
      let alert = UIAlertController(
         title: "Guardar Puntuación",
         message: "Introduce 3 letras para tu registro:",
         preferredStyle: .alert
      )
      
      alert.addTextField { textField in
         textField.placeholder = "Ej: ABC"
         textField.autocapitalizationType = .allCharacters
         textField.delegate = self  // Para validar entrada
      }
      
      let saveAction = UIAlertAction(title: "Guardar", style: .default) { _ in
         guard let input = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespaces),
               input.count == 3,
               input.rangeOfCharacter(from: .letters) != nil else {
            
            // Mostrar error si la entrada no es válida
            let errorAlert = UIAlertController(
               title: "Entrada inválida",
               message: "Debes introducir exactamente 3 letras",
               preferredStyle: .alert
            )
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
               self.promptForName() // Volver a mostrar el prompt
            }))
            self.present(errorAlert, animated: true)
            return
         }
         
         self.r.name = input.uppercased()
         self.r.guardarArchivo()
         self.restartGame()
      }
      
      let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { _ in
         self.restartGame()
      }
      
      alert.addAction(saveAction)
      alert.addAction(cancelAction)
      present(alert, animated: true)
   }
   
   private func restartGame() {
      gameBoard = GameBoard(rows: rows, columns: columns, numberOfMines: 10)
      gameBoard.printBoard()
      collectionView.reloadData()
      startTimer() // Reiniciar temporizador al reiniciar juego
      
      r.name = ""
      r.puntuacion = 0
   }
   
   
   private func formattedTime(seconds: Int) -> String {
      let minutes = (seconds / 60) % 60
      let seconds = seconds % 60
      return String(format: "%02d:%02d", minutes, seconds)
   }
   
   @IBAction func bandera(_ sender: UILongPressGestureRecognizer) {
      guard sender.state == .began else { return }
      
      let touchPoint = sender.location(in: collectionView)
      if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
         let row = indexPath.item / columns
         let column = indexPath.item % columns
         gameBoard.toggleFlag(atRow: row, column: column)
         collectionView.reloadItems(at: [indexPath])
      }
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
      let cellSize = min(cellWidth, cellHeight) - 2
      
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

extension MinasUICollectionViewController: UITextFieldDelegate {
   func textField(_ textField: UITextField,
                  shouldChangeCharactersIn range: NSRange,
                  replacementString string: String) -> Bool {
      
      let currentText = textField.text ?? ""
      let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
      
      // Limitar a 3 caracteres y solo letras
      return newText.count <= 3 && string.rangeOfCharacter(from: .letters) != nil
   }
=======
   @IBOutlet var colMinas: UICollectionView!
   
   override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        colMinas.register(UINib(nibName: "MinasUICollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Celda")

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       let cell = colMinas.dequeueReusableCell(withReuseIdentifier: "Celda", for: indexPath) as! MinasCollectionViewCell

    
        // Configure the cell
    
        return cell
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

>>>>>>> parent of 33fc88b (Merge pull request #5 from buneassassin/origin/China)
}
