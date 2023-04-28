//
//  ContentView.swift
//  SpeakerActive
//
//  Created by Harri on 12/03/2023.
//

import SwiftUI

struct ContentView: View {
    
    //Variables
    
    @EnvironmentObject var globalThings: GlobalThings
    @Environment(\.colorScheme) var colorSchemeSystem
    let updaterViewModel: UpdaterViewModel
            
    //Main UI
    
    var body: some View {
        
        if globalThings.showAboutView {
            AboutView(updaterViewModel: updaterViewModel)
                .environmentObject(globalThings)
                
        } else {
            
            VStack{
                HStack (alignment: .top) {
                    Image(globalThings.mainImage)
                        .resizable()
                        .frame(width:150, height:150)
                        .cornerRadius(7)
                        .onTapGesture {
                            globalThings.setValues()
                            globalThings.tonePlaying.toggle()
                            globalThings.actionToggle()
                            print(globalThings.tonePlaying, globalThings.toneInterval, globalThings.sleepTime, globalThings.sliderUsing)
                        }
                    VStack(alignment: .leading) {
                        HStack(spacing:0){
                            Text("Speaker")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                
                            Text("Active")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(globalThings.tonePlaying ? Color("SAGreen") : .primary)
                            
                        }
                        Divider()
                            .padding(.top, -7.0)
                            .frame(width:250)
                        Text("Click the speaker to play/stop the tone loop")
                            .font(.footnote)
                            .fontWeight(.light)
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 10)
                            .padding(.top, -8)
                        
                        
                        HStack {
                            Text("Tone Status:")
                                .fontWeight(.bold)
                            Text("\(globalThings.toneStatus)")
                                .fontWeight(.bold)
                            .foregroundColor(globalThings.fontColour)}
                        .padding(.bottom, 1.0)
                        
                        HStack (alignment: .bottom) {
                            Text("Interval: \(timeString(from: globalThings.toneInterval))")
                                .fontWeight(.bold)
                            Text("⏵  \(timeLeftString(from: globalThings.intRemaining))")
                                .fontWeight(.bold)
                                .foregroundColor(globalThings.fontColour)
                                .opacity(globalThings.isHidden ? 0 : 1)
                        }.padding(.bottom, 2.0)
                        
                        HStack (alignment: .bottom) {
                            Text("Time Left: \(timeString(from: globalThings.sleepTime))")
                                .fontWeight(.bold)
                            Text("⏵  \(timeLeftString(from: globalThings.sleepRemaining))")
                                .fontWeight(.bold)
                                .foregroundColor(globalThings.fontColour)
                                .opacity(globalThings.isHidden ? 0 : 1)
                        }.padding(.bottom, 2.0)
                    }
                    .padding(.leading, 15.0)
                }
                .padding(.top, -3.0)
                
                Divider()
                    .padding(.top, 7.0)
                    .frame(width:425)
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("Interval")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        Text("Interval between tones")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                    }
                    Spacer()
                    Slider(value: $globalThings.toneInterval, in: 1...60, onEditingChanged: { editing in
                        print("Slider editing: \(editing)")
                        globalThings.sliderUsing = editing
                        globalThings.toneInterval = round(globalThings.toneInterval * 1) / 1
                        globalThings.UIChanges()
                        globalThings.setValues()
                    }) {}
                        .tint(globalThings.fontColour)
                        .frame(width: 180)
                        .padding(.trailing, 10.0)
                    
                    
                    Text("\(timeString(from: globalThings.toneInterval))")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                }
                
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("Sleep Timer")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        Text("Total time remaining")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                    }
                    Spacer()
                    Slider(value: Binding(
                        get: { globalThings.sleepTime },
                        set: { globalThings.sleepTime = round($0 / 15) * 15 }
                    ), in: 15...240, onEditingChanged: { editing in
                        print("Slider editing: \(editing)")
                        globalThings.sliderUsing = editing
                        globalThings.UIChanges()
                        globalThings.setValues()
                    })
                    
                    .tint(globalThings.fontColour)
                    .frame(width: 180)
                    .padding(.trailing, 10.0)
                    Text("\(timeString(from: globalThings.sleepTime))")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                }
                
                Divider()
                    .padding(.top, 0)
                    .frame(width:425)
                
                HStack (alignment: .bottom){
                    Spacer()
                    
                    Button("About") {
                        globalThings.showAboutView.toggle()
                    }
                    .font(.system(size: 13, weight:Font.Weight.bold))
                    Button("Quit") {
                        NSApplication.shared.terminate(nil)
                    }
                    .font(.system(size: 13, weight:Font.Weight.bold))
                    
                }
                .padding(.trailing, 5)
            }
            .padding()
            .background(globalThings.backG)
            .colorScheme(globalThings.selectedTheme ?? colorSchemeSystem)
            .opacity(1)
            .frame(width: 450.0, alignment: .center)
            .environmentObject(globalThings)
            
            /*.popover(isPresented: $showAboutView) {
             AboutView()
             .environmentObject(globalThings)
             .onAppear{
             aboutClickable = false}
             .onDisappear {
             aboutClickable = true}
             }*/
        }
    }
    
    //Time Formatters
    
    func timeString(from minutes: Double) -> String {
        if minutes == 60 {
            return "1 hour"
        }else if minutes == 120 {
            return "2 hours"}
        else if minutes == 180 {
            return "3 hours"}
        else if minutes == 240 {
            return "4 hours"}
            else if minutes < 60 {
            return String(format: "%.0f mins", minutes)
        } else {
            let hours = Int(minutes / 60)
            let mins = Int(minutes.truncatingRemainder(dividingBy: 60))
            return "\(hours)h \(mins)m"
        }
    }
    
    func timeLeftString(from seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        var formattedString = formatter.string(from: TimeInterval(seconds))!
        
        if formattedString.hasPrefix("0:") {
            formattedString = String(formattedString.dropFirst(2))
        } else if formattedString.hasPrefix("00:") {
            formattedString = String(formattedString.dropFirst(3))
        }
        if formattedString.hasPrefix("0") {
            formattedString = String(formattedString.dropFirst())
        }
        
        return formattedString
    }




}
    
    //Preview code
    
    struct ContentView_Previews: PreviewProvider {
        
        static var previews: some View {
            let globalThings = GlobalThings()
            let updaterViewModel = UpdaterViewModel()
            ContentView(updaterViewModel: updaterViewModel)
                .environmentObject(globalThings)
        }
    }

