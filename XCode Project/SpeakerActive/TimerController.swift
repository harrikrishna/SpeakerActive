//
//  TimerController.swift
//  SpeakerActive
//
//  Created by Harri on 13/03/2023.
//

import SwiftUI
import AVFoundation
import IOKit.pwr_mgt


class TimerController: GlobalThings {
    
    //Variables/Setup
    
    var globalThings: GlobalThings
    init(globalThings: GlobalThings) {
    self.globalThings = globalThings}
        
    var timer: Timer?
    var audioPlayer: AVPlayer?
    var powerAssertion: IOPMAssertionID? // Add this line to declare powerAssertion variable

    
    //Start Timers
    
    func startTimers() {
        globalThings.tonePlaying = true
        globalThings.setValues()
        print ("timers started")
        playTone()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            
            //Counting
            
            if self.globalThings.intRemaining > 0 {
                self.globalThings.intRemaining -= 1}
            if self.globalThings.sleepRemaining > 0 {
                self.globalThings.sleepRemaining -= 1
                
                print ("Interval Remaining: \( self.globalThings.intRemaining!) Sleep Remaining: \(self.globalThings.sleepRemaining!)")
            }
            
            //Actions
            
            if self.globalThings.intRemaining == 0 {
                self.playTone()
                self.globalThings.intRemaining = self.globalThings.toneInterval * 60
            }
            
            if self.globalThings.sleepRemaining == 0 {
                self.stopTimers()
            }
            
        }
    }
    
    //Stop Timers
    
    func stopTimers() {
        timer?.invalidate()
        print ("timers stopped")
        globalThings.tonePlaying = false
        globalThings.setValues()
        globalThings.UIChanges()
        
        // Release power assertion if created
         if let powerAssertion = self.powerAssertion {
             IOPMAssertionRelease(powerAssertion)
             self.powerAssertion = nil
         }
    }
    
    //Play the Tone
    
    func playTone() {
        
        //let bundlePath = Bundle.main.bundlePath
        //print("Bundle path: \(bundlePath)")

        guard let sound = Bundle.main.path(forResource: "defaulttone", ofType: "wav") else {return}
        let playerItem = AVPlayerItem(url: URL(fileURLWithPath: sound))
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer!.volume = globalThings.toneVolume
        
        if globalThings.runScreenOff {
            // Create and activate power assertion
            var assertionID: IOPMAssertionID = 0
            let result = IOPMAssertionCreateWithName(kIOPMAssertionTypePreventUserIdleSystemSleep as CFString, IOPMAssertionLevel(kIOPMAssertionLevelOn), "Playing Tone" as CFString, &assertionID)
            if result == kIOReturnSuccess {
                self.powerAssertion = assertionID
            }}
        
        audioPlayer?.play()
        print ("Tone Playing")
    }
    
    //End
    
    deinit{
        stopTimers()
        globalThings.tonePlaying = false
    }
}
