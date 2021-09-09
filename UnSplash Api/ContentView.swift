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
    
    @ObservedObject var  photosModel = PhotosModel()
    @ObservedObject var RandomImages = getData()
    
    
    @State var isSearching = false
    @State var search = ""
    
    var body: some View {
        
        VStack( spacing: 0) {
            HStack {
                
                if !photosModel.expand{
                    VStack(alignment: .leading, spacing: 8) {
                        
                        
                        Text("Unsplash")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Beautiful Free Images & Pictures")
                            .font(.caption)
                        
                        
                        
                    }
                    .foregroundColor(.black)
                    
                }
                
                
                Spacer(minLength: 0)
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray )
                    .onTapGesture {
                        withAnimation {
                            photosModel.expand = true
                        }
                    }
                if photosModel.expand {
                    
                    TextField("Search ...", text: self.$search)
                    
                    
                    if self.search != "" {
                        Button(action: {
                            //                        delete old list
                            self.RandomImages.images.removeAll()
                            self.isSearching = true
                            //                        Search for image by name
                            self.SearchData()
                            photosModel.expand = false
                        }){
                            Text("Find")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    
                    
                    
                    
                    Button(action: {
                        
                        withAnimation {
                            photosModel.expand = false
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
                
                
                
                
                
                
                
            }
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding()
            .background(Color.white)
            
            
            if self.RandomImages.images.isEmpty {
                
                Spacer()
                
                if self.RandomImages.noReuslt {
                    
                    VStack{
                        Text("No result ...")
                        Button(action: {
                            self.search = ""
                            self.isSearching = false
                            self.RandomImages.images.removeAll()
                            self.RandomImages.updateData()
                        }){
                            Text("Try again ...")
                        }
                        
                    }
                }else{
                    Indicator()
                }
                
                //                empty or loading state ....
                
                
                
                
                
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
                                    Text("Page\(photosModel.page)")
                                    Spacer()
                                    Button(action: {
                                        self.RandomImages.images.removeAll()
                                        photosModel.page += 1
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
        let url = "https://api.unsplash.com/search/photos/?page=\(photosModel.page)&query=\(query)&client_id=\(key)"
        
        print(url)
        
        self.RandomImages.SearchData(url : url)
    }
}





