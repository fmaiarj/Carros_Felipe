//
//  CarroDB.swift
//  Carros
//
//  Created by Luiz Felipe Oliveira Maia on 03/03/17.
//  Copyright © 2017 Ricardo Lecheta. All rights reserved.
//

import Foundation


class CarroDB {
    
    var db: SQLiteHelper
    
    init() {
        self.db = SQLiteHelper(database: "carros.sqlite")
    }
    
    // Cria a tabela carros (apenas se já não existe)
    
    func createTables() {
        
        let sql = "create table if not exists carro (_id integer primary key autoincrement,nome text, desc text, url_foto text,url_info text,url_video text, latitude text,longitude text, tipo text);"
        
        db.execSql(sql: sql)
        
        db.close()
    }
    
    
    
    func getCarrosByTipo(tipo: String) -> Array<Carro> {
        
        var carros: Array<Carro> = []
        
        let stmt = db.query("SELECT * FROM carro where tipo = ?",params:[tipo as AnyObject])
        
        
        while(db.nextRow(stmt: stmt)) {
            
            let c = Carro()
            
            c.id = db.getInt(stmt: stmt, index: 0)
            c.nome = db.getString(stmt: stmt, index: 1)
            c.desc = db.getString(stmt: stmt, index: 2)
            c.url_foto = db.getString(stmt: stmt, index: 3)
            c.url_info = db.getString(stmt: stmt, index: 4)
            c.url_video = db.getString(stmt: stmt, index: 5)
            c.latitude = db.getString(stmt: stmt, index: 6)
            c.longitude = db.getString(stmt: stmt, index: 7)
            c.tipo = db.getString(stmt: stmt, index: 8)
            carros.append(c)

            print(c.id)
            print("Url Resgatada do banco de dados \(c.url_foto)")
            
        }
        
        db.closeStatement(stmt: stmt)
        return carros
    }

    // Salva um novo carro ou atualiza se ja existe id
    
    func save(carro: Carro) {
        
        if(carro.id == 0) {
            
            // Insert 
            
            let sql = "insert or replace into carro (nome,desc,url_foto,url_info,url_video,latitude,longitude,tipo) VALUES(?,?,?,?,?,?,?,?);"
            
            let params = [carro.nome,carro.desc,carro.url_foto,carro.url_info,carro.url_video,carro.latitude,carro.longitude,carro.tipo]
            
            let id = db.execSql(sql: sql, params: params as Array<AnyObject>)
            
        }else{
            
            // Update
            
            let sql = "update carro set nome=?,desc=?,url_foto=?,url_info=?,url_video=?,latitude=?,longitude=?,tipo=?) where _id=? VALUES(?,?,?,?,?,?,?,?,?,?);"
            
            let params = [carro.nome,carro.desc,carro.url_foto,carro.url_info,carro.url_video,carro.latitude,carro.longitude,carro.id] as [Any]
            
            let id = db.execSql(sql: sql, params: params as Array<AnyObject>)
            
            print("Carro \(carro.nome), id: \(id)/\(carro.id) Atualizado com sucesso")
            
        }
    }
    
    func delete(carro: Carro) {
    
        let sql = "delete from carro where _id = ?"
        
        db.execSql(sql: sql, params: [carro.id as AnyObject])
        
    }
    
    // Deleta todos os carro do tipo infomado
    
    func deletaCarrosTipo(tipo: String) {
        
        let carros = self.getCarrosByTipo(tipo: tipo)
        
        for c in carros {
            
            self.delete(carro: c)
            
        }
        
    }
    
    func close() {
        self.db.close()
    }
    
}
