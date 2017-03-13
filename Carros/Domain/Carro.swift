//
//  Carro.swift
//  Carros
//
//  Created by Ricardo Lecheta on 7/12/14.
//  Copyright (c) 2014 Ricardo Lecheta. All rights reserved.
//

// Implementacao abordagem (CoreData -> Framework de Persistencia)


import Foundation
import CoreData
@objc(Carro)

class Carro: NSManagedObject {
    
    @NSManaged var desc: String
    @NSManaged var latitude: String
    @NSManaged var longitude: String
    @NSManaged var nome: String
    @NSManaged var timestamp: NSDate
    @NSManaged var tipo: String
    @NSManaged var url_foto: String
    @NSManaged var url_info: String
    @NSManaged var url_video: String
    
}



// Implementacao (SQLite3 -> Abordagem tradicional)

/*
import Foundation

class Carro : NSObject {
    // id do banco de dados
    var id: Int = 0
    
    // tipo: clássico, esportivo, luxo
    var tipo: String = ""
    
    var nome: String = ""
    var desc: String = ""
    
    // Url para a foto do carro
    var url_foto: String = ""
    
    // Url com um site com informações do carro
    var url_info : String = ""
    
    // Url com o vídeo do carro
    var url_video : String = ""
    
    // Coordenadas da fábrica ou país de origem do carro
    
    var latitude : String = ""
    var longitude : String = ""
}
*/
