//
//  DetalhesCarroViewController.swift
//  Carros
//
//  Created by Ricardo Lecheta on 7/11/14.
//  Copyright (c) 2014 Ricardo Lecheta. All rights reserved.
//

import UIKit

class DetalhesCarroViewController: UIViewController {
    
    @IBOutlet var img : DownloadImageView!
    @IBOutlet var tDesc : UITextView!
    
    var carro: Carro?
    
    init() {
        super.init(nibName: "DetalhesCarroViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let c = carro {
            self.title = c.nome
            
            self.tDesc.text = c.desc;
    
            print(c.url_foto)
            
            self.img.setUrl(url: c.url_foto)
            
            let btnDeletar = UIBarButtonItem(title: "Deletar", style: .plain, target: self, action: "onClickDeletar")
            
            self.navigationItem.rightBarButtonItem = btnDeletar
            
            
            //let img = UIImage(named: c.url_foto)
            //self.img.image = img
        }
    }
    
    // Controlar a troca de orientação (vertical/horizontal)
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        print("viewWillTransitionToSize \(size)")
        
        if(size.width > size.height) {
            print("Horizontal")
            tDesc.isHidden = true
            
            // Horizontal: Esconde tudo
            self.tabBarController!.tabBar.isHidden = true
            self.navigationController!.navigationBar.isHidden = true
        } else {
            print("Vertical")
            
            // Vertical: Mostra tudo
            self.tabBarController!.tabBar.isHidden = false
            self.navigationController!.navigationBar.isHidden = false
            
            tDesc.isHidden = false
        }
        
        // Atualiza o status da action bar
        self.setNeedsStatusBarAppearanceUpdate()
    }
    

    func onClickDeletar() {
      
        let alert = UIAlertController(title: "Confima?", message: "nil", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (UIAlertAction) in self.deletar()}))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { (UIAlertAction) in }))
        
     
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func deletar() {
        
        let db = CarroDB()
        
        db.delete(carro: self.carro!)
        
        Alerta.alerta("Carro Excluido com sucesso", viewController: self, action: { (UIAlertAction) -> Void in
        
            self.goBack()
        
        })
        
    }
    
    func goBack() {
        
        self.navigationController!.popViewController(animated: true)
    }
    
}
