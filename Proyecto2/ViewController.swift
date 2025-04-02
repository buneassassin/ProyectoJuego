//
//  ViewController.swift
//  Proyecto2
//
//  Created by Dante Raziel Basurto Saucedo on 28/02/25.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Establecer la categoría del audio para que se reproduzca en segundo plano, si es necesario
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error al configurar la sesión de audio: \(error)")
        }
        
        // Ubica el archivo de audio en el bundle
        if let audioPath = Bundle.main.path(forResource: "C418", ofType: "mp3") {
            let audioURL = URL(fileURLWithPath: audioPath)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                // Para que se repita indefinidamente
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error al reproducir el audio: \(error)")
            }
        } else {
            print("No se encontró el archivo de audio")
        }
    }



}

