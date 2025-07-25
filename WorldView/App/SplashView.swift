//
//  SplashView.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var locationManager = LocationManager.shared
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            LottieView(name: AppConstants.LottieFiles.earth, loopMode: .loop)
                .frame(width: 400, height: 400)
                .onAppear {
                    locationManager.requestPermission()
                    
                    // Wait for location to be updated or timeout
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        if locationManager.country != nil {
                            isActive = true
                        }
                    }
                }
                .onChange(of: locationManager.country) { 
                    isActive = true
                }
                .fullScreenCover(isPresented: $isActive) {
                    MainView()
                }
        }
    }
}
