//
//  CarroDBCoreData.swift
//  Carros
//
//  Created by Luiz Felipe Oliveira Maia on 09/03/17.
//  Copyright © 2017 Ricardo Lecheta. All rights reserved.
//

import Foundation
import CoreData

class CarroDBCoreData {
    
    class func newInstance () -> AnyObject {
        // AppDelegate da aplicação
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Context para salvar/deletar/buscar objetos
        let context = appDelegate.managedObjectContext
        
        // Cria uma instância do Carro (inserindo no managed object context)
        //println(context)
        
        let c = NSEntityDescription.insertNewObject(forEntityName: "Carro", into:context!)
        
        return c
    }
    
    
    
}
