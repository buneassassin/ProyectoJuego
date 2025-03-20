//
//  Record.swift
//  Proyecto2
//
//  Created by Tobias Rodriguez Lujan on 19/03/25.
//

import UIKit

class Record: NSObject {
   var puntuacion: Int
   var name: String
   var ultimaPuntuacion: Int
   var ultimoName: String
   static var recor: Record!
   
   override init() {
      puntuacion = 0
      name = ""
      ultimaPuntuacion = 0
      ultimoName = ""
      
   }
   
   static func sharedDatos() -> Record {
      if recor == nil {
         recor = Record.init()
      }
      return recor
   }
   
   func abrirArchivo()
   {
      let ruta = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/records.plist"
      print(ruta)
      let urlArchivo = URL(fileURLWithPath: ruta)
      
      do
      {
         let archivo = try Data.init(contentsOf: urlArchivo)
         print(archivo)
         
         let diccionario = try PropertyListSerialization.propertyList(from: archivo, format: nil) as! [String:Any]
         print(diccionario)
         
         puntuacion = diccionario["pun"] as! Int
         name = diccionario["nam"] as! String
         
      
         
      }catch
      {
         print("Error al leer el archivo: \(error)")
      }
   }
   
   //Guarda archivo persistente plist
   func guardarArchivo()
   {
      guard !self.name.isEmpty else {
         print("AVISO: No se guardara dado que el usuario no a participado en el juego")
         return
      }
      
      let ruta = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/records.plist"
      print("ruta en la que se va a guardar: \(ruta)")
      let urlArchivo = URL(fileURLWithPath: ruta)
      
      
      var recordsArray = [[String: Any]]()
      
      // 1. Cargar registros existentes
      if FileManager.default.fileExists(atPath: ruta) {
         do {
            let data = try Data(contentsOf: urlArchivo)
            recordsArray = try PropertyListSerialization.propertyList(from: data, format: nil) as? [[String: Any]] ?? []
         } catch {
            print("Error al leer archivo: \(error)")
         }
      }
      
      // 2. Agregar nuevo registro actual
      let nuevoRegistro = ["pun": self.puntuacion, "nam": self.name] as [String: Any]
      recordsArray.append(nuevoRegistro)
      
      
      // 3. Ordenar de mayor a menor puntuación
      recordsArray.sort { (registroA, registroB) -> Bool in
         let puntuacionA = registroA["pun"] as? Int ?? 0
         let puntuacionB = registroB["pun"] as? Int ?? 0
         return puntuacionA > puntuacionB
      }
      
      // 4. Guardar array ordenado
      do {
         let data = try PropertyListSerialization.data(fromPropertyList: recordsArray, format: .xml, options: 0)
         print("Se han guardado los datos en \(data)")
         try data.write(to: urlArchivo)
      } catch {
         print("Error al guardar: \(error)")
      }
      
      
   }
}

