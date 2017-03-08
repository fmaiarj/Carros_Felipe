//
//  File.swift
//  Carros
//
//  Created by Luiz Felipe Oliveira Maia on 23/02/17.
//  Copyright © 2017 Ricardo Lecheta. All rights reserved.
//

import UIKit

class DownloadImageView: UIImageView {
    
    var progress: UIActivityIndicatorView!
    
    let queue = OperationQueue()
    
    let mainQueue = OperationQueue.main
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        createProgress()
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        createProgress()
        
    }
    
    func createProgress() {
        
        progress =  UIActivityIndicatorView(activityIndicatorStyle: .gray)
        addSubview(progress)
        
    }
    
    override func layoutSubviews() {
        
        progress.center =  convert(self.center, to: self.superview)
    }
    
    
    func setUrl(url: String) {
        
        
        setUrl(url: url, cache: true)
    }
    
    func setUrl(url: String, cache: Bool) {
        
        self.image = nil
        
        queue.cancelAllOperations()
        
        progress.startAnimating()
        
        queue.addOperation({self.downloadImg(url: url, cache: true) } )
    }
    
    func downloadImg(url: String, cache: Bool) {
        
        var data: Data!
        
        if(!cache) {
            
            
            do{
            
                try data =  Data(contentsOf: URL(fileURLWithPath: url))
            
                print("chamada")
            }catch {
                print("Error ao ler cache - 1")
            }
            
        }else{
        
            
            var path = StringUtils.replace(url, string: "/", withString: "_")
            path = StringUtils.replace(path, string: "\\", withString:"_")
            path = StringUtils.replace(path, string: ":", withString: "_")
            path =  NSHomeDirectory() + "/Documents/" + path
            
            print(path)
            // Se o arquivo existe no cache
            let existis = FileManager.default.fileExists(atPath: path)
            
        
            if(existis) {
                do{
                
                    try data = Data(contentsOf: URL(fileURLWithPath: path))
                
                }catch {
                    print("Error ao ler cache - 2" )
                }
                
            }else{
                do{
                    try data = Data(contentsOf: URL(string: url)!)
                    
                    try data.write(to: URL(fileURLWithPath: path), options: Data.WritingOptions.atomic)
                    
                    
                }catch{
                    print("Error ao ler cache - 3")
                    print (data.isEmpty)
                    
                }
            }
            
        }
        
       
        mainQueue.addOperation( { self.showImg(data: data) } )
    
}

    func showImg(data: Data) {
        
        
        if(!data.isEmpty) {
            self.image = UIImage(data: data)
        }
        
        progress.stopAnimating()
    }

}
