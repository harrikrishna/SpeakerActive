//
//  ThemeSwitcher.swift
//  SpeakerActive
//
//  Created by Harri on 21/04/2023.
//

import SwiftUI

enum ThemeType: Int, Identifiable, CaseIterable {
    var id: Self { self }
    case system
    case light
    case dark
}

extension ThemeType {
    var title: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}

struct ThemeSwitcherToggles: View {
    
    @EnvironmentObject var globalThings: GlobalThings
    @Environment(\.colorScheme) var systemTheme
    @AppStorage("systemThemeVal") private var appTheme: Int = ThemeType.allCases.first!.rawValue
    
    
    private var selectedTheme: ColorScheme? {
        guard let theme = ThemeType(rawValue: appTheme) else { return nil }
        switch theme {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return nil
        }
    }
    
    var body: some View {
        
        HStack {
            Toggle("System Default", isOn: Binding(
                get: { self.appTheme == 0 },
                set: { _ in self.appTheme = 0}
                    
            )).toggleStyle(CheckboxStyle())
            Spacer()
            
            Toggle("Light Theme", isOn: Binding(
                get: { self.appTheme == 1 },
                set: { _ in self.appTheme = 1}
                    
            )).toggleStyle(CheckboxStyle())
            Spacer()
            
            Toggle("Dark Theme", isOn: Binding(
                get: { self.appTheme == 2 },
                set: { _ in self.appTheme = 2}
                    
            )).toggleStyle(CheckboxStyle())
            
        }.environmentObject(globalThings)
            .preferredColorScheme(selectedTheme)
            .onChange(of: appTheme) { newValue in
                
                globalThings.selectedTheme = selectedTheme
                globalThings.setTheme()
                //print("Theme: \(globalThings.selectedTheme) System: \(systemTheme)")
            }
            
    }
    
}
