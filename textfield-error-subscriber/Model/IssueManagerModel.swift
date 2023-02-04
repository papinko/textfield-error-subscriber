//
//  IssueManagerModel.swift
//  textfield-error-subscriber
//
//  Created by Nikolai on 04.02.23.
//

import Foundation
import Combine
import SwiftUI


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
                    withAnimation(.easeInOut(duration: 0.35)) {
                        self.textFieldError = error as? TextFieldValidationError
                    }
                    return false
                }
            }
            .sink(receiveValue: { [weak self] (isValid) in
                withAnimation(.easeInOut(duration: 0.35)) {
                    self?.isValid = isValid
                }
            })
            .store(in: &cancellables)
    }
}


