//
//  ContentView.swift
//  UnSplash Api
//
//  Created by ilies on 7/9/2021.
//

import SwiftUI

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
                }
                
                
                if self.search != "" {
                    Button(action: {
                        
                    }){
                        Text("Find")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
                
                
                
                Button(action: {
                    
                    withAnimation {
                        self.expand = false
                    }
                    
                }){
                    Image(systemName: "xmark")
                        .font(.system(size: 15,weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.leading,10)
                
            }
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding()
            .background(Color.white)
            
            Spacer()
        }
        .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.all ))
        .edgesIgnoringSafeArea(.top)
    }
}
