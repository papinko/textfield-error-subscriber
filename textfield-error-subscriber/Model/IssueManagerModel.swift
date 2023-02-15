//
//  IssueManagerModel.swift
//  textfield-error-subscriber
//
//  Created by Nikolai on 04.02.23.
//

import Foundation
import Combine
import SwiftUI

// MARK:    TextFiled Subscriber
//          Subscriber check any changes on TextField and look, whether conditions (allowedSymbols, minLenght, maxLenght) is fulfilled
class IssueManagerModel : ObservableObject {
    // If a throws appears -> set error
    @Published var textFieldError: TextFieldValidationError? = nil
    
    // Textfield value
    @Published var value: String = ""
    
    // is value of the textfield a valid
    @Published var isValid: Bool = false
    
    // A String with all symbols that is allowed to enter
    @Published var allowedSymbols: String = ""
    
    // Min lenght of the TextField
    @Published var minLenght: Int = 0
    
    // Max lenght of the TextField, default -> nil
    @Published var maxLenght: Int? = nil
    
    // Is clear of TextField button is shown
    @Published var isTextFieldClearAllowed: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    // Initializing the TextField Subscriber
    init() {
        TextFieldSubscriber()
    }
    
    // Subscribe to any change of the Textfield value
    private func TextFieldSubscriber() {
        $value
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { (text) -> Bool in
                do {
                    // Look, if any condition fulfilled
                    try text.isTextFieldValid(excludedSymbols: self.allowedSymbols, min: self.minLenght, max: self.maxLenght);
                    
                    // no throw -> textError to nil
                    self.textFieldError = nil
                    
                    // Additionally, check for text length, for the circle delete button on TextField
                    if(text.isEmpty){
                        withAnimation(.easeInOut(duration: 0.35)) {
                            self.isTextFieldClearAllowed = false
                        }
                        return false
                    } else {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            self.isTextFieldClearAllowed = true
                        }
                        return true
                    }
                } catch {
                    // if the String Extension "isTextFieldValid" return a throw, the TextFieldValidationError will be assigned
                    withAnimation(.easeInOut(duration: 0.35)) {
                        self.textFieldError = error as? TextFieldValidationError
                    }
                    return false
                }
            }
            .sink(receiveValue: { [weak self] (isValid) in
                withAnimation(.easeInOut(duration: 0.35)) {
                    // if isValid == true -> the TextFiels has no problems
                    self?.isValid = isValid
                }
            })
            .store(in: &cancellables)
    }
}


