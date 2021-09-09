//
//  PhotosModel.swift
//  UnSplash Api
//
//  Created by ilies on 8/9/2021.
//

import SwiftUI





class PhotosModel : ObservableObject{
    
    
    
    
    
    @Published var expand = false
    
    @Published var page = 1
    
    
    
}


//Fetch data

class getData : ObservableObject {
    
    @Published var images : [[Photo]] = []
    
    @Published var noReuslt : Bool = false
    
    
    init() {
        //        initial data
        updateData()
    }
    
    
    
    func updateData()  {
        
        let key = "gKc-uC-4eHiLAK3qhJmfhVb-kz2RcaOU_f7DJDLvGWo"
        let url = "https://api.unsplash.com/photos/random/?count=30&client_id=\(key)"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _ ,err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            //            JSON Decoding
            
            do {
                
                let json = try JSONDecoder().decode([Photo].self, from: data!)
                
                for i in stride(from: 0, to: json.count, by: 2){
                    
                    var ArrayData : [Photo] = []
                    
                    for j in i..<i+2 {
                        
                        if j < json.count {
                            ArrayData.append(json[j])
                        }
                    }
                    DispatchQueue.main.async {
                        self.images.append(ArrayData)
                    }
                }
                
            }catch{
                print("Catch err ....")
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    
    
    func SearchData(url : String)  {
        
        
        let session = URLSession(configuration: .default)
        
        print("search link : \(url)")
        
        session.dataTask(with: URL(string: url)!) { (data, _ ,err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            //            JSON Decoding
            
            do {
                
                let json = try JSONDecoder().decode(SearchPhoto.self, from: data!)
                
                if json.results.isEmpty {
                    self.noReuslt = true
                }else{
                    self.noReuslt = false
                }
                
                for i in stride(from: 0, to: json.results.count, by: 2){
                    
                    var ArrayData : [Photo] = []
                    
                    for j in i..<i+2 {
                        
                        if j < json.results .count {
                            ArrayData.append(json.results[j])
                        }
                    }
                    DispatchQueue.main.async {
                        self.images.append(ArrayData)
                    }
                }
                
            }catch{
                print("Catch err ....")
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    
    
    
}



struct Photo : Identifiable,Decodable,Hashable {
    
    var id : String
    var urls : [String : String]
}


//Search result model
struct SearchPhoto : Decodable {
    
    var results : [Photo]
}


struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
        
        
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
}
