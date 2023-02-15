//
//  DefaulTextfield.swift
//  textfield-error-subscriber
//
//  Created by Nikolai on 04.02.23.
//

import SwiftUI


struct DefaulTextfield : View {
    
    // Placeholder Text of TextField
    @State      var placeholder         : String
    
    // The IN/OUT Text of TextField
    @Binding    var text                : String
    
    // Is the IN/OUT Text has any issue?
    @Binding    var isValid             : Bool
    
    // Min Text lenght of TextField
    @State var minLenght: Int? = nil
    
    // Max Text lenght of TextField
    @State var maxLenght: Int? = nil
    
    // The symbols, the is allowed to write into the TextField
    @State var allowedSymbols: String? = nil
    
    // Initialize a TextFiled Subscriber
    @StateObject private var subscriber = IssueManagerModel()
    
    var body: some View {
        VStack(alignment: .center) {
            
            HStack(alignment: .center) {
                // Extend the existing TextField control
                TextField(placeholder, text: $subscriber.value)
                    .TextfieldModifier(roundedCornes: 8, startColor: Color(UIColor.systemGray5), endColor: Color(UIColor.systemGray5) , textColor: Color.black, borderColor: .clear)
                
                // Show circle delete button, wenn any Characters was wrote
                if subscriber.isTextFieldClearAllowed {
                    Button {
                        // Delete Text from a TextField
                        withAnimation {
                            subscriber.value = ""
                        }
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            // if textFieldError is not a nil -> show the issue text under textField
            if let issue = subscriber.textFieldError {
                ErrorMessageView(textFieldErrorText: issue)
            }
             
        } // VStack
        .frame(maxWidth: .infinity)
        // Initialize the subscriber values 
        .onAppear {
            if let min = minLenght {
                subscriber.minLenght = min
            }
            
            if let max = maxLenght {
                subscriber.maxLenght = max
            }
            
            if let symbols = allowedSymbols {
                subscriber.allowedSymbols = symbols
            }
            
            subscriber.value = text
            subscriber.isValid = isValid
        }
        // Transfer the isValid-Property to INOUT isValid
        .onChange(of: subscriber.isValid, perform: { newValue in
            withAnimation(.easeInOut(duration: 0.35)) {
                self.isValid = newValue
            }
        })
    }
    
    // MARK: Error Message showing View
    struct ErrorMessageView : View {
        
        @State var textFieldErrorText: TextFieldValidationError
        
        var body: some View {
            HStack {
                Text(textFieldErrorText.localizedDescription)
                    .foregroundColor(.red)
                    .font(.footnote)
                
                Spacer()
            }
            .padding(.leading, 7)
        }
    }
}

// MARK: Types of Issue
enum TextFieldValidationError: Error, LocalizedError {
    
    case isTooShort     // Text of TextFiled is too short
    case isTooLong      // Text of TextFiled is too long
    case symbolExluded  // Text of TextFiled contains prohibited symbols
    
    var errorDescription: String?
    {
        switch self {
        case .isTooShort:
            return NSLocalizedString("Is to short", comment: "")
        case .isTooLong:
            return NSLocalizedString("Is too long", comment: "")
        case .symbolExluded:
            return NSLocalizedString("Not allowed symbol(s)", comment: "")
        }
    }
}




#if DEBUG
struct DefaulTextfield_Previews: PreviewProvider {
    static var previews: some View {
        DefaulTextfield(placeholder: "", text: .constant(""), isValid: .constant(false))
    }
}
#endif
