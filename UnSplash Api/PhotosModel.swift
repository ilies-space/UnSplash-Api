//
//  PhotosModel.swift
//  UnSplash Api
//
//  Created by ilies on 8/9/2021.
//

import SwiftUI





struct PhotosModel {
    
    
    
    @State var page = 1

    @State var expand = false
    
    
    
    func openSearchBar() -> Void {
        self.expand = true
    }
    
    func closeSearchBar() -> Void {
        self.expand = false
    }

    
}
