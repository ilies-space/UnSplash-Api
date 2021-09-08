//
//  ContentView.swift
//  UnSplash Api
//
//  Created by ilies on 7/9/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Home : View {
    
    @State var expand = false
    @State var search = ""
    @ObservedObject var RandomImages = getData()
    @State var page = 1
    @State var isSearching = false
    
    var body: some View {
        
        VStack( spacing: 0) {
            HStack {
                
                if !self.expand{
                    VStack(alignment: .leading, spacing: 8) {
                        
                        
                        Text("Unsplash")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Beutiful,Free Photos")
                            .font(.caption)
                        
                        
                        
                    }
                    .foregroundColor(.black)
                    
                }
                
                
                Spacer(minLength: 0)
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray )
                    .onTapGesture {
                        withAnimation {
                            self.expand = true
                        }
                    }
                if self.expand {
                    
                    TextField("Search ...", text: self.$search)
                    
                    Button(action: {
                        
                        withAnimation {
                            self.expand = false
                        }
                        
                        if self.isSearching {
                            self.search = ""
                            self.isSearching = false
                            self.RandomImages.images.removeAll()
                            self.RandomImages.updateData()
                        }
                        
                    }){
                        Image(systemName: "xmark")
                            .font(.system(size: 15,weight: .bold))
                            .foregroundColor(.black)
                    }
                    .padding(.leading,10)
                }
                
                
                if self.search != "" {
                    Button(action: {
//                        delete old list
                        self.RandomImages.images.removeAll()
                        self.isSearching = true
//                        Search for image by name
                        self.SearchData()
                    }){
                        Text("Find")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
                
                
                
                
                
            }
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding()
            .background(Color.white)
            
            
            if self.RandomImages.images.isEmpty {
                //                empty or loading state ....
                
                Spacer()
                
                Indicator()
                
                Spacer()
                
            }else {
                //                image availible case ...
                
                ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
                    //                    Collection View
                    
                    VStack(spacing: 15){
                        
                        ForEach(self.RandomImages.images, id: \.self){i in
                            
                            HStack(spacing : 20 ){
                                ForEach (i) { j in
                                    
                                    AnimatedImage(url: URL(string: j.urls["thumb"]!))
                                        .resizable()
                                        .frame(width:(UIScreen.main.bounds.width - 50) / 2, height: 200 )
                                        .aspectRatio(contentMode: .fill)
                                        .cornerRadius(20)
                                        .contextMenu(ContextMenu(menuItems: {
                                            
                                            //                                            save btn
                                            
                                            Button(action: {
                                                
                                                
                                                SDWebImageDownloader()
                                                    .downloadImage(with: URL(string: j.urls["full"]!)) { (image,_,_,_) in
                                                        
                                                        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                                                        
                                                    }
                                                
                                                   
                                            }){
                                                HStack{
                                                    Text("SAVE")
                                                    Spacer()
                                                    Image(systemName:
                                                            "square.and.arrow.down.fill")
                                                }
                                                .foregroundColor(.black)
                                            }
                                        }))
                                }
                            }
                            
                            
                        }
                        
                        if !self.RandomImages.images.isEmpty{
                            
                            if self.isSearching && self.search != "" {
                                
                                HStack{
                                    Text("Page\(self.page)")
                                    Spacer()
                                    Button(action: {
                                        self.RandomImages.images.removeAll()
                                        self.page += 1
                                        self.SearchData()
                                    })
                                    {
                                        Text("Next")
                                    }
                                }
                                .padding(.horizontal,25)
                                
                            }else{
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        self.RandomImages.images.removeAll()
                                        self.RandomImages.updateData()
                                    })
                                    {
                                        Text("Next")
                                    }
                                }
                                .padding(.horizontal,25)
                            }
                        }
                        
                        
                        

                        
                        
                    }
                    
                    .padding(.top)
                    
                }
            }
            
        }
        .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.all ))
        .edgesIgnoringSafeArea(.top)
    }
    
    
    func SearchData()  {
        let key = "gKc-uC-4eHiLAK3qhJmfhVb-kz2RcaOU_f7DJDLvGWo"
        let query = self.search.replacingOccurrences(of: " ", with: "%20")
        let url = "https://api.unsplash.com/search/photos/?page=\(self.page)&query=\(query)&client_id=\(key)"
        
        print(url)
        
        self.RandomImages.SearchData(url : url)
    }
}






//Fetch data

class getData : ObservableObject {
    
    @Published var images : [[Photo]] = []
    
    
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



