//
//  GlobalThings.swift
//  SpeakerActive
//
//  Created by Harri on 12/03/2023.
//

import SwiftUI

class GlobalThings: ObservableObject {
    
    init(){
        
        toneInterval = UserDefaults.standard.double(forKey: "Default Interval")
        sleepTime = UserDefaults.standard.double(forKey: "Default Sleep")
        runScreenOff = UserDefaults.standard.bool(forKey: "Run Screen Off")
        toneVolume = UserDefaults.standard.float(forKey: "Tone Volume")
        selectedTheme = getSelectedTheme()
        setValues()
        
    }
    
    //Main Variables
    
    var timerController: TimerController!
    
    @Published var tonePlaying = false
    
    @Published var toneInterval = 20.0
    @Published var sleepTime = 120.0
    @Published var intRemaining: Double!
    @Published var sleepRemaining: Double!
    @Published var runScreenOff = true { didSet {
        UserDefaults.standard.set(runScreenOff, forKey: "Run Screen Off")
    }}
    @Published var toneVolume: Float = 1.0 { didSet {
        print ("Volume: \(toneVolume)")
        UserDefaults.standard.set(toneVolume, forKey: "Tone Volume")
    }}
    
    
    //UI Change Variables
    
    @Published var appIcon = "MenuBarOff"
    @Published var mainImage = "speakeroff"
    @Published var toneStatus = "Off"
    @Published var fontColour = Color.gray
    @Published var sliderUsing = false
    @Published var isHidden = true
    @Published var showAboutView = false
    @Published var updatingApp = false
    
    //OverallUI
    
    @Published var selectedTheme: ColorScheme! {
        didSet {
            if let theme = selectedTheme {
                let themeString = theme == .dark ? "dark" : "light"
                UserDefaults.standard.set(themeString, forKey: "Selected Theme")
            } else {
                UserDefaults.standard.removeObject(forKey: "Selected Theme")
            }
        }
    }
    @Published var backG = LinearGradient(colors: [Color("StartGradient"), Color("EndGradient")],startPoint: .topTrailing, endPoint: .bottomLeading)
        
    //FUNCTIONS
    
    //Main Action Toggle
    
    func actionToggle() {

            if  tonePlaying {
            
            timerController = TimerController(globalThings: self)
            timerController.startTimers()
            UIChanges()
                
            } else {
                
            timerController.stopTimers()
            timerController = nil
            tonePlaying = false
            UIChanges()
            }
        }
    
    //Set Values from UI and store to UserDefaults
    
    func setValues(){
        intRemaining = toneInterval * 60
        sleepRemaining = sleepTime * 60
        
        UserDefaults.standard.set(self.toneInterval, forKey: "Default Interval")
        UserDefaults.standard.set(self.sleepTime, forKey: "Default Sleep")
    }
    
    //Set/Retreive Theme
    
    func setTheme(){
        let themeString: String
        if let selectedTheme = selectedTheme {
            themeString = selectedTheme == .dark ? "dark" : "light"
        } else {
            themeString = "system"
        }
        UserDefaults.standard.set(themeString, forKey: "Selected Theme")
    }

    func getSelectedTheme() -> ColorScheme? {
        guard let themeString = UserDefaults.standard.string(forKey: "Selected Theme") else {
            return nil
        }
        
        switch themeString {
        case "dark":
            return .dark
        case "light":
            return .light
        case "system":
            return nil
        default:
            return nil
        }
    }

    
    // Loop Interval Reset
    
    func setIntOnly(){
        intRemaining = toneInterval
    }
    
    //UI Changes
    
    func UIChanges(){
        
        if (tonePlaying == true && sliderUsing == false){
            isHidden = false
            mainImage = "speakeron"
            toneStatus = "Playing"
            appIcon = "MenuBarOn"
            fontColour = Color("SAGreen")
            
        } else {
            isHidden = true
            mainImage = "speakeron"
            mainImage = "speakeroff"
            toneStatus = "Off"
            fontColour = Color.gray
            appIcon = "MenuBarOff"
        }
    }
}
