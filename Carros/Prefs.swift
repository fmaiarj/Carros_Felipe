//
//  Prefs.swift
//  Carros
//
//  Created by Luiz Felipe Oliveira Maia on 22/02/17.
//  Copyright © 2017 Ricardo Lecheta. All rights reserved.
//

import Foundation

class Prefs {

    class func setString(valor: String, chave:String) {
        
        let prefs = UserDefaults.standard
        prefs.set(valor, forKey: chave)
        prefs.synchronize()
        
    }
    
    class func getString(valor: String, chave: String) -> String! {
        
        let prefs =  UserDefaults.standard
        let s = prefs.string(forKey: chave)
        return s
    }
    
    
    class func setInt(valor: Int, chave: String) {
        
        let prefs = UserDefaults.standard
        prefs.set(valor, forKey: chave)
        prefs.synchronize()
        
    }
    
    class func getInt(chave: String) -> Int! {
        
        let prefs = UserDefaults.standard
        let s = prefs.integer(forKey: chave)
        return s
    }
    
}
