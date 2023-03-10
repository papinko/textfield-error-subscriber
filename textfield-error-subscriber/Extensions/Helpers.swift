//
//  Helpers.swift
//  textfield-error-subscriber
//
//  Created by Nikolai on 04.02.23.
//

import Foundation
import SwiftUI

// MARK: Setting general properties with an extension
extension TextField {
    func TextfieldModifier(roundedCornes : CGFloat, startColor : Color, endColor : Color, textColor : Color, borderColor : Color) -> some View {
        self
            .frame(height: 38)
            .padding(.leading, 10)
            .background(LinearGradient(gradient: Gradient(  colors: [startColor, endColor]),
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing))
            .cornerRadius(roundedCornes)
            .foregroundColor(textColor)
            .overlay(
                RoundedRectangle(cornerRadius: roundedCornes)
                    .stroke(borderColor, lineWidth: 1.0)
            )
            .shadow(color: borderColor,radius: 1)
            // Changing the Keyboard Sumbit Button
            .submitLabel(.done)
            // For a better overview, open the keyboard and move the TextField to the top.
            .ignoresSafeArea(.keyboard, edges: .top)
    }
}

extension String {
    func isTextFieldValid(excludedSymbols: String, min: Int, max: Int?) throws {
        
        // Checking of all allowed conditions with a local functions
        try IsInExcludedSymbol(excludedSymbols: excludedSymbols)
        try IsMinLenght(min: min)
        try IsMaxLenght(max: max)
        
        func IsInExcludedSymbol(excludedSymbols: String) throws {
            if(!excludedSymbols.isEmpty){
                let characterset = CharacterSet(charactersIn: excludedSymbols)
                if self.rangeOfCharacter(from: characterset.inverted) != nil {
                    throw TextFieldValidationError.symbolExluded
                }
            }
        }
        
        func IsMinLenght(min: Int) throws {
            if(self.count < min && !self.isEmpty){
                throw TextFieldValidationError.isTooShort
            }
        }
        
        func IsMaxLenght(max: Int?) throws {
            guard let maxLenght = max else {return}
            if(self.count > maxLenght){
                throw TextFieldValidationError.isTooLong
            }
        }
    }
}

