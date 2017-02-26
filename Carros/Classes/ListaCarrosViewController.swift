//
//  ListaCarrosViewController.swift
//  Carros
//
//  Created by Ricardo Lecheta on 7/11/14.
//  Copyright (c) 2014 Ricardo Lecheta. All rights reserved.
//

import UIKit

class ListaCarrosViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var progress : UIActivityIndicatorView!
    
    // Modificação inclusão do segment control (tipo de carro)
    @IBOutlet var segmentControl: UISegmentedControl!
    
    var carros: Array<Carro> = []
    
    // Tipo do carro
    var tipo = "classicos"

    init() {
        super.init(nibName: "ListaCarrosViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Título
        self.title = "Carros"
        
        // delegate
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Para o scroll começar na posição do TableView
        self.automaticallyAdjustsScrollViewInsets = false;
        
        // Registra o CarroCell.xib como UITableViewCell da tabela
        let xib = UINib(nibName: "CarroCell", bundle:nil)
        self.tableView.register(xib, forCellReuseIdentifier: "cell")
        
        
        // Recupera tipo salvo nas preferências
        
        let idx = Prefs.getInt(chave: "tipoIdx")
        let s = Prefs.getString(chave: "tipoString")
        
        if( s != nil) {
            //como String é opcional precisamos testar antes
            self.tipo = s!
        }
        
        // Atualiza o índice no segmentControl
        self.segmentControl.selectedSegmentIndex = idx!
        
        
        // Busca carros
        self.buscarCarros()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Se a variável opcional está inicializada, retorna a quantidade de carros
        return self.carros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Cria a célula desta linha
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CarroCell

        let linha = (indexPath as NSIndexPath).row
        
        // Objeto do tipo carro
        let carro = self.carros[linha]

        cell.cellNome.text = carro.nome
        cell.cellDesc.text = carro.desc
        
        print("url \(carro.url_foto)")

        // Implementacao anterior
        
        // Busca a imagem (problema de performance aqui)
        //let data = try? Data(contentsOf: URL(string: carro.url_foto)!)
        //if(data != nil) {
        //    let image = UIImage(data: data!)
        //    cell.cellImg.image = image
       // }
        
        cell.cellImg.setUrl(url: carro.url_foto)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let linha = (indexPath as NSIndexPath).row
        
        let carro = self.carros[linha]

//        Alerta.alerta("Selecionou o carro: " + carro.nome, viewController: self)
        
        let vc = DetalhesCarroViewController()
        vc.carro = carro
        self.navigationController!.pushViewController(vc, animated: true)
        
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask  {
        // Apenas vertical
        return UIInterfaceOrientationMask.portrait
    }
    
    @IBAction func alterarTipo(_ sender: UISegmentedControl) {
        let idx = sender.selectedSegmentIndex
        
        switch (idx) {
        case 0:
            self.tipo = "classicos"
        case 1:
            self.tipo = "esportivos"
        default:
            self.tipo = "luxo"
        }
        
        // Salva tipo nas preferências
        Prefs.setInt(valor: idx, chave: "tipoInt")
        Prefs.setString(valor: self.tipo, chave: "tipoString")
        
    
        // Buscar os carros pelo tipo selecionado (classico, esportivo, luxo)
        self.buscarCarros()
    }
    
    func buscarCarros() {
        
        
        let http = URLSession.shared
        let url = URL(string: "http://www.livroiphone.com.br/carros/carros_" + tipo + ".json")!
        let request = URLRequest(url: url)
        
        
        let task = http.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                
                Alerta.alerta("Erro: " + error.localizedDescription , viewController: self)
            
            }else {
                
                if let data = data {
                
                self.carros = CarroService.parserJson(data)
                
                    DispatchQueue.main.sync(execute: {
                 
                    // Atualiza o TableView
                    
                    self.tableView.reloadData()
                    self.progress.stopAnimating()
                    
                })
            }
        }
    })
    
        task.resume()
        //self.carros = CarroService.getCarrosByTipoFromFile(tipo)
        
        // Atualiza o TableView
        //self.tableView.reloadData()
    }
}
