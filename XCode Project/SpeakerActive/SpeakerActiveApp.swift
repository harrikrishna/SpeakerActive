//
//  SpeakerActiveApp.swift
//  SpeakerActive
//
//  Created by Harri on 12/03/2023.
//

import SwiftUI
import Sparkle

@main
struct SpeakerActiveApp: App {

    //Initialisation
    
    @ObservedObject var globalThings = GlobalThings()
    @StateObject var updaterViewModel = UpdaterViewModel()
    
    //MenuBarExtra
    var body: some Scene {
        
        MenuBarExtra("SpeakerActive", image: globalThings.appIcon) {
            ContentView(updaterViewModel: updaterViewModel)
                .environmentObject(globalThings)
                
        }.menuBarExtraStyle(.window)
    }
}

