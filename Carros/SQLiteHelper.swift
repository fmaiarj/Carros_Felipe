//
//  SQLiteHelper.swift
//  Carros
//
//  Created by Luiz Felipe Oliveira Maia on 02/03/17.
//  Copyright © 2017 Ricardo Lecheta. All rights reserved.
//

import Foundation

class SQLiteHelper: NSObject {
    
    // sqlite3 *db
    
    var db: OpaquePointer? = nil
    
    init(database: String){
        
        super.init()
        self.db = open(database)
        
    }
    
    
    // Caminho Banco de dados
    
    func getFilePath(nome: String) -> String {
        
        // Caminho com o arquivo
        
        let path =  NSHomeDirectory() + "/Documents/" + nome
        
        return path
    }
    
    
    // Abre o banco de dados
    func open(_ database: String) -> OpaquePointer? {
        
        var db: OpaquePointer? = nil;
        
        let path = getFilePath(nome: database)
        print(path)
        
        
       let cPath = StringUtils.toCString(path)
        
        let result = sqlite3_open(cPath, &db)
        
        if(result != SQLITE_OK) {
            
            print("Não foi possível abrir o banco de dados SQLite \(result)")
            return nil
            
        } else {
            
            //println("SQLite OK")
        
        }
        
        return db
    }
    
    // Executa SQL
    
    func execSql(sql: String) -> CInt {
        
        return execSql(sql: sql, params: nil)
  
    }
    
    
    func execSql(sql: String, params: Array<AnyObject>!) -> CInt {
        
        // Statement
        
        let stmt = query(sql, params: params)
        
        
        // Step
        
        var result = sqlite3_step(stmt)
        
        if result != SQLITE_OK && result != SQLITE_DONE {
            
            sqlite3_finalize(stmt)
            
            let msg = "Erro ao executar SQL \n\(sql)\nError: \(lastSQLError())"
            
            print(msg)
            
            return -1
        }
        
        if sql.uppercased().hasPrefix("INSERT") {
            
            // http://www.sqlite.org/c3ref/last_insert_rowid.html
            
            let rid = sqlite3_last_insert_rowid(self.db)
            
            result  = CInt(rid)
            
        }else{
            
            
            result = 1
        
            
      }
    
        // Fecha o Statement
        
        sqlite3_finalize(stmt)
        return result
        
    }
    
    
    // Faz o bind dos parametros (?,?,?) de um SQL
    
    func bindParams(stmt: OpaquePointer, params: Array<AnyObject>!) {
        
        if (params != nil) {
            
            let size = params.count
            
            for i:Int in 1...size {
                
                let value : AnyObject = params[i-1]
                
                if(value is Int) {
                    
                    let number: CInt = toCInt(SwiftInt: value as! Int)
                    sqlite3_bind_int(stmt, toCInt(SwiftInt: i), number)
                    
                }else{
                    
                    let text: String = value as! String
                    SQLiteObjc.bindText(stmt, idx: toCInt(SwiftInt: i), with: text)
                    
                }
                
            }
            
        }
        
    }
    
    
    // Executa o SQL e retorna o statement
    
    func query(sql: String) -> OpaquePointer {
        
        return query(sql, params: nil)
        
    }
    
    
    func query(_ sql: String, params: Array<AnyObject>!) -> OpaquePointer {
        
        
        var stmt: OpaquePointer? = nil
        let cSql = StringUtils.toCString(sql)
        
        
        // Prepare
        
        let result = sqlite3_prepare_v2(self.db, cSql, -1, &stmt, nil)
        
            
        if (result != SQLITE_OK) {
            
            sqlite3_finalize(stmt)
            let msg = "Erro ao preparar SQL \n\(sql)\nError: \(lastSQLError())"
            print("SQLite ERROR \(msg)")
            
        }else{
            
            print("SQL [\(sql)] , params: \(params)")
        }
        
        if(params != nil) {
            
            bindParams(stmt: stmt!, params: params)
            
        }
        
        return stmt!
        
    }
    
    
    // Retorna true se existe a proxima linha da consulta
    
    func nextRow(stmt: OpaquePointer) -> Bool {
        
        
        let result = sqlite3_step(stmt)
        let next: Bool = result == SQLITE_ROW
        return next
        
        
    }
    
    // fecha o statement
    
    func closeStatement(stmt: OpaquePointer) {
        
        sqlite3_finalize(stmt)
        
    }
    
    // Fecha Banco de Dados
    
    func close() {
        
        sqlite3_close(self.db)
        
    }
    
    // Retorna Ultimo erro de SQL
    
    func lastSQLError() -> String {
        
        var err: UnsafePointer<Int8>? = nil
        
        err = sqlite3_errmsg(self.db)
        
        if(err != nil) {
            
            let s = NSString(utf8String: err!)
            return s as! String
            
        }
     
        return ""
    }
    
    
    // Lê uma coluna do tipo Int
    
    func getInt(stmt: OpaquePointer, index: CInt) -> Int {
        
        let val = sqlite3_column_int(stmt, index)
        
        return Int(val)
    }
    
    func getDouble(stmt: OpaquePointer, index:CInt) -> Double {
        
        let val = sqlite3_column_double(stmt, index)
        
        return Double(val)
    }
    
    func getFloat(stmt: OpaquePointer, index: CInt) -> Float {
        
        let val = sqlite3_column_double(stmt, index)
        
        return Float(val)
    
    }
    
    func getString(stmt: OpaquePointer, index: CInt) -> String {
    
        let cString = SQLiteObjc.getText(stmt, idx: index)
        let s = String(describing: cString)
        return s
    
    }

    // Convert Int (Swift) para Cint(C)
    
    func toCInt(SwiftInt: Int) -> CInt {
        
        let number: NSNumber = SwiftInt as NSNumber
        let pos: CInt = CInt(number.intValue)
        return pos
        
    }

}
