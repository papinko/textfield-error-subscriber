//
//  DefaulTextfield.swift
//  textfield-error-subscriber
//
//  Created by Nikolai on 04.02.23.
//

import SwiftUI


struct DefaulTextfield : View {
    
    @State      var placeholder         : String
    @Binding    var text                : String
    @Binding    var isValid             : Bool
    
    // MARK: Properties
    @State var minLenght: Int? = nil
    @State var maxLenght: Int? = nil
    @State var allowedSymbols: String? = nil
    
    @StateObject private var subscriber = IssueManagerModel()
    
    var body: some View {
        VStack(alignment: .center) {
            
            HStack(alignment: .center) {
                TextField(placeholder, text: $subscriber.value)
                    .TextfieldModifier(roundedCornes: 8, startColor: Color(UIColor.systemGray5), endColor: Color(UIColor.systemGray5) , textColor: Color.black, borderColor: .clear)
                
                if subscriber.isTextFieldClearAllowed {
                    Button {
                        withAnimation {
                            subscriber.value = ""
                        }
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if let issue = subscriber.textFieldError {
                ErrorMessageView(textFieldErrorText: issue)
            }
             
        } // VStack
        .frame(maxWidth: .infinity)
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
        .onChange(of: subscriber.isValid, perform: { newValue in
            withAnimation(.easeInOut(duration: 0.35)) {
                self.isValid = newValue
            }
        })
    }
    
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

enum TextFieldValidationError: Error, LocalizedError {
    
    case isTooShort
    case isTooLong
    case symbolExluded
    
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
