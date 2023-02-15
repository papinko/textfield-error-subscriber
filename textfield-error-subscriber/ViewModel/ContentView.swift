//
//  ContentView.swift
//  textfield-error-subscriber
//
//  Created by Nikolai on 04.02.23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var text: String = ""
    @State var isValid: Bool = false
    
    var body: some View {
        VStack(spacing: 15) {
            
            // Show the actual allowed symbols for the TextField
            AllowedSymbolsView
            
            // TextFiled
            DefaulTextfield(placeholder: "test",
                            text: $text,
                            isValid: $isValid,
                            minLenght: 3,
                            maxLenght: 6,
                            allowedSymbols: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
            
            // This button should be enabled if the text in the TextField has no problem
            SaveView
        }
        .padding()
    }
    
    // Example: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
    @ViewBuilder
    private var AllowedSymbolsView: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Allowed symbols:")
                .foregroundColor(.black)
                .font(.title3)
                .padding(.top, 8)
            
            Text("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
                .foregroundColor(.gray)
                .font(.body)
                .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity)
        .background() {
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray.opacity(0.2))
                .frame(maxWidth: .infinity)
                .shadow(radius: 2, x: 2, y: 2)
        }
    }
    
    @ViewBuilder
    private var SaveView: some View {
        Button {
            // action
        } label: {
            Text("Save")
                .foregroundColor(.white)
                .font(.title3)
        }
        .frame(minHeight: 35)
        .frame(maxWidth: .infinity)
        .background() {
            RoundedRectangle(cornerRadius: 8)
                .fill( isValid ? .green : .gray)
                .frame(maxWidth: .infinity)
                .shadow(radius: 2, x: 2, y: 2)
        }
        // If the Text on the TextField is ok -> make this button a clickable
        .disabled(!isValid)
    }
}


#if DEBUB
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
