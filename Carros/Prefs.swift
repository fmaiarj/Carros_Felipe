//
//  Prefs.swift
//  Carros
//
//  Created by Luiz Felipe Oliveira Maia on 22/02/17.
//  Copyright © 2017 Ricardo Lecheta. All rights reserved.
//

import Foundation

class Prefs {

    class func getFilePath(nome: String) -> String {
        
        // Caminho com arquivo
        let path = NSHomeDirectory() + "/Documents/" + nome + ".txt"
        print(path)
        return path
        
    }
    
    
    class func setString(valor: String, chave:String) {
        
        let path = Prefs.getFilePath(nome: chave)
        let nsdata = StringUtils.toNSData(valor)
        // Escreve NSData no arquivo
        do {
            try nsdata.write(to: URL(fileURLWithPath: path), options: Data.WritingOptions.atomic)
        }catch {
            print("Erro ao escrever em arquivo")
        }
    }
    
    class func getString(chave: String) -> String! {
        
        let path = Prefs.getFilePath(nome: chave)
        var nsdata :Data?
        var s: String?
        do{
            try nsdata = Data(contentsOf: URL(fileURLWithPath: path))
            
        }catch {
            print("Erro")
        }
        
        if ( nsdata != nil){
            s = StringUtils.toString(nsdata!)
        }
        // Implementacao anterior (NSUserDefaults)
        
       // let prefs =  UserDefaults.standard
       // let s = prefs.string(forKey: chave)
       
        return s
    }
    
    
    class func setInt(valor: Int, chave: String) {
        
        
        setString(valor: String(valor), chave: chave)
        
        
        // Implementacao anterior (NSUserDefaults)
        
        //let prefs = UserDefaults.standard
        //prefs.set(valor, forKey: chave)
        //prefs.synchronize()
        
    }
    
    class func getInt(chave: String) -> Int! {
        
        let valorString :String! = getString(chave: chave)
        
        if(valorString == nil) {
            
            // Nao existe
            return 0
        }
        
        
        let valorInt = Int(valorString)
        return valorInt!
        
        // Implementacao anterior NSUSerDefauts
        
        //let prefs = UserDefaults.standard
        //let s = prefs.integer(forKey: chave)
        //return s
    }
    
    
    
}
