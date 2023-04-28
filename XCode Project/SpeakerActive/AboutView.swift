//
//  AboutView.swift
//  SpeakerActive
//
//  Created by Harri on 18/04/2023.
//

import SwiftUI
import LaunchAtLogin
import Sparkle

extension Bundle {
    var versionNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
}

struct AboutView: View {
    
    @EnvironmentObject var globalThings: GlobalThings
    @Environment(\.colorScheme) var colorSchemeSystem
    let updaterViewModel: UpdaterViewModel

    var body: some View {
        
        ScrollView (showsIndicators: false) {
            
                Spacer().frame(height: 8)
                AboutHeaderView()
            if globalThings.updatingApp == true {
                UpdaterViewToggle()
            } else {
                Spacer().frame(height: 8)
                OptionsView(updaterViewModel: updaterViewModel)
                Spacer().frame(height: 8)
                TroubleshootingView()
                Spacer().frame(height: 8)
                ContactView()
            }
            }
            .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
            .frame(width: 450.0, height: nil, alignment: .top)
            .environmentObject(globalThings)
            .opacity(1)
            .background(globalThings.backG)
            .colorScheme(globalThings.selectedTheme ?? colorSchemeSystem)
            //.transaction { vstackTransaction in // get the transaction
                //vstackTransaction.disablesAnimations = true }
                // modify the transaction's animation
    }
    
    struct AboutHeaderView: View {
        
        @EnvironmentObject var globalThings: GlobalThings
        
        var body: some View {
            
            VStack (alignment: .leading) {
                HStack{
                    Text("About")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, -4)
                    
                    Spacer()
                    Button("Back") {
                        globalThings.showAboutView.toggle()
                        globalThings.updatingApp = false
                    }.font(.system(size: 13, weight:Font.Weight.bold))
                }
                Text("SpeakerActive version \(Bundle.main.versionNumber) © Harri Lyons 2023")
                    .font(.footnote)
                    .fontWeight(.light)
                    .foregroundColor(Color.gray)
                Divider()
                    .padding(.top, -3)
                if globalThings.updatingApp == false {
                    Text("A menu bar app to keep your speakers awake. Prevents annoying power-saving switch-offs by playing an inaudible, low-frequency tone at regular intervals until the sleep timer runs out.")
                        .font(.footnote)
                        .fontWeight(.light)
                        .padding(.bottom, 6)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }.fixedSize(horizontal: false, vertical: true)
        }
    }
    
    struct OptionsView: View {
        
        @EnvironmentObject var globalThings: GlobalThings
        let updaterViewModel: UpdaterViewModel
        
        var body: some View {
            VStack (alignment: .leading) {
                DisclosureGroup("Options"){
                    ScrollView (showsIndicators: false) {
                        
                        //Run in Sleep Mode
                        GroupBox {
                            VStack(alignment: .leading){
                                Toggle(isOn: $globalThings.runScreenOff) {
                                    Text("Run in sleep mode")
                                        .fontWeight(.bold)
                                        .font(.system(size: 12))
                                }
                                .toggleStyle(CheckboxStyle())
                                HStack{
                                    Text("Keeps tone playing while screen is asleep (hopefully at least - see Troubleshooting).")
                                        .font(.footnote)
                                        .fontWeight(.light)
                                        .padding(.leading, 20)
                                    
                                    Spacer()
                                }
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        //Run in Sleep Mode
                        GroupBox {
                            HStack{
                                Form{
                                    LaunchAtLogin.Toggle()
                                }.toggleStyle(CheckboxStyle())
                                Spacer()
                            }
                        }.frame(height:25)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        //Dark/Light Mode
                        GroupBox  {
                            HStack{
                                ThemeSwitcherToggles()
                            }
                            .frame(height:25)
                        }.frame(alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                        
                        //Volume Slider
                        GroupBox  {
                            HStack{
                                Text("Tone volume:")
                                    .fontWeight(.bold)
                                    .font(.system(size: 12))
                                Text(String(format: "%.0f", globalThings.toneVolume * 10))
                                    .fontWeight(.bold)
                                    .font(.system(size: 12))
                                    .frame(width:20)
                                
                                Spacer()
                                                                
                                Slider(value: $globalThings.toneVolume, in: 0.1...1.0, onEditingChanged: { editing in
                                    globalThings.toneVolume = round(globalThings.toneVolume * 10) / 10}){}
                                    .tint(Color("SAGreen"))
                                    .frame(width: 200)
                                    .padding(.trailing, 20.0)
                                    .controlSize(_: .mini)
                                
                                //Spacer()
                                
                            }.frame(height: 25, alignment: .leading)
                                .padding (.leading, 20)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        //Updates Button
                        HStack {
                            Spacer()
                            Button("Check for Updates") {
                                globalThings.updatingApp = true
                                updaterViewModel.checkForUpdates()
                            }
                            .font(.system(size: 12, weight:Font.Weight.bold))
                        }
                        Spacer()
                    }.fixedSize(horizontal: false, vertical: true)
                }.disclosureGroupStyle(MyDisStyle())
                .fontWeight(.bold)
            }
        }
    }
    
    struct TroubleshootingView: View {
        var body: some View {

            DisclosureGroup("Troubleshooting") {
                HStack {
                    VStack (alignment: .leading) {
                        Text("**Volume issues:** The tone should be inaudible at such a low frequency, but if your ears are superhuman or the speakers pop loudly when they re-activate, try reducing the volume in the Options above. Likewise if your speakers aren't waking up, try cranking it up a little (and adjusting your system volumes - you'll need some level of general system audio for it to work, the amount depending on your individual speakers' power-saving threshold.)")
                            .font(.footnote)
                            .fontWeight(.light)
                            .padding (.top, 3)
                            .padding (.bottom, 3)
                        Text("**Sleep mode issues:** If like mine your speakers are connected to more things than just your Mac then you'll probably want the tone to run while the screen is off. I've added an option for this which works fine for me but I haven't been able to test it on other systems. If it doesn't work for you the app may need to be used alongside a screen-waking app like Caffeine or Lungo.")
                            .font(.footnote)
                            .fontWeight(.light)
                            .padding (.top, 3)
                            .padding (.bottom, 3)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                    
                }
                }
                .fontWeight(.bold)
                .disclosureGroupStyle(MyDisStyle())
        }
    }
    
    struct ContactView: View {
        
        @EnvironmentObject var globalThings: GlobalThings
                
        var body: some View {
            
                DisclosureGroup("Contact") {
                    HStack {
                        VStack (alignment: .leading) {
                            Text("I selfishly only made this app to keep my own speakers on really, which the original version did for several years. Figured someone else out there might find it useful too so I've jazzed it all up with proper menus & options for a bit of a UI Design project. If you run into any problems with it drop me a line at **harrilyons@gmail.com** and I'll try to fix any issues.")
                                .tint(Color("SAGreen"))
                                .font(.footnote)
                                .fontWeight(.light)
                                .padding (.top, 3)
                                .padding (.bottom, 3)
                            Text("If anyone ends up using this every day like I do and wants to buy me a coffee someday (more likely a beer in all honesty) then you can at **www.ko-fi.com/harrikrishna**")
                                .tint(Color("SAGreen"))
                                .font(.footnote)
                                .fontWeight(.light)
                                .padding (.top, 3)
                                .padding (.bottom, 3)
                            
                        }.fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    }
                }
                .fontWeight(.bold)
                .disclosureGroupStyle(MyDisStyle())
            
        }
    }
    
    struct UpdaterViewToggle: View {
        @EnvironmentObject var globalThings: GlobalThings
        var body: some View {
            HStack{
                Spacer()
                Button ("⏷"){ globalThings.updatingApp = false }
                .buttonStyle(.plain)
                .foregroundColor(Color("SAGreen"))
                Spacer()
            }
        }
    }
}

// Disclosure Group Styling

struct MyDisStyle: DisclosureGroupStyle {
    
    @EnvironmentObject var globalThings: GlobalThings
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Button {
                withAnimation(.easeOut) {
                    configuration.isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    
                    Text(configuration.isExpanded ? "⏷" : "⏵")
                        .foregroundColor(Color("SAGreen"))
                        .font(.caption.lowercaseSmallCaps())
                        .animation(nil, value: configuration.isExpanded)
                    configuration.label
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            if configuration.isExpanded {
                
                VStack (alignment: .leading){
                    configuration.content
                }
                    .transition(.opacity.combined(with: .move(edge: .leading)))
                    
            }
        }
    }
}

// Checkbox Styling

struct CheckboxStyle: ToggleStyle {
    
    @EnvironmentObject var globalThings: GlobalThings
 
    func makeBody(configuration: Self.Configuration) -> some View {
 
        return HStack {
                
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 12, height: 12)
                .foregroundColor(configuration.isOn ? Color("SAGreen") : .gray)

            configuration.label
                .fontWeight(.bold)
                .font(.system(size: 12))
        }.onTapGesture {
            configuration.isOn.toggle()
        }
 
    }
}


struct AboutView_Previews: PreviewProvider {
    
    static var previews: some View {
        let globalThings = GlobalThings()
        let updaterViewModel = UpdaterViewModel()
        AboutView(updaterViewModel: updaterViewModel)
            .environmentObject(globalThings)
            
            
    }
}

