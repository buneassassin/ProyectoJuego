//
//  AudioManager.swift
//  Proyecto2
//
//  Created by Dante Raziel Basurto Saucedo on 01/04/25.
//

import UIKit
import AVFoundation

class AudioManager: NSObject {

    static let shared = AudioManager()  // Singleton
    
    var audioPlayer: AVAudioPlayer?
    
    private override init() {
        // Ubicar el archivo de audio en el bundle
        if let audioPath = Bundle.main.path(forResource: "C418", ofType: "mp3") {
            let audioURL = URL(fileURLWithPath: audioPath)
            do {
                // Inicializa el reproductor
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                // Configurar para que se repita indefinidamente
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error al inicializar el audio: \(error)")
            }
        } else {
            print("No se encontró el archivo de audio")
        }
    }
    
    func playBackgroundMusic() {
        // Asegurarse de que la sesión de audio esté configurada
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error al configurar la sesión de audio: \(error)")
        }
        
        audioPlayer?.play()
    }
    
    func stopBackgroundMusic() {
        audioPlayer?.stop()
    }
}
