import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @State private var displayText: String = "0"
    @State private var currentNumber: Double = 0
    @State private var previousNumber: Double = 0
    @State private var operation: String = ""
    @State private var performingOperation: Bool = false
    
    // MARK: - UI Layout
    let buttons: [[CalculatorButton]] = [
        [.clear, .operation("/"), .operation("*"), .operation("-")],
        [.number(7), .number(8), .number(9), .operation("+")],
        [.number(4), .number(5), .number(6)],
        [.number(1), .number(2), .number(3)],
        [.number(0), .decimal, .equals]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text(displayText)
                .font(.system(size: 64))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                .background(Color.gray.opacity(0.1))
            
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { button in
                        CalculatorButtonView(button: button) {
                            self.buttonAction(button)
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    // MARK: - Button Action
    private func buttonAction(_ button: CalculatorButton) {
        switch button {
        case .number(let value):
            handleNumberPress(value)
        case .operation(let op):
            handleOperationPress(op)
        case .equals:
            performCalculation()
        case .clear:
            clear()
        case .decimal:
            handleDecimalPress()
        }
    }
    
    // MARK: - Button Handlers
    private func handleNumberPress(_ value: Int) {
        if performingOperation {
            displayText = "\(value)"
            performingOperation = false
        } else {
            displayText = displayText == "0" ? "\(value)" : "\(displayText)\(value)"
        }
        currentNumber = Double(displayText) ?? 0
    }
    
    private func handleOperationPress(_ op: String) {
        if !performingOperation {
            previousNumber = currentNumber
        }
        performingOperation = true
        operation = op
    }
    
    private func handleDecimalPress() {
        if !displayText.contains(".") {
            displayText += "."
        }
    }
    
    private func performCalculation() {
        switch operation {
        case "+":
            currentNumber = previousNumber + currentNumber
        case "-":
            currentNumber = previousNumber - currentNumber
        case "*":
            currentNumber = previousNumber * currentNumber
        case "/":
            currentNumber = previousNumber / currentNumber
        default:
            break
        }
        
        // Update display text with the result and reset variables
        displayText = "\(currentNumber)"
        previousNumber = 0
        performingOperation = false
        operation = ""
    }
    
    private func clear() {
        currentNumber = 0
        previousNumber = 0
        operation = ""
        displayText = "0"
        performingOperation = false
    }
}

// MARK: - Calculator Button View
struct CalculatorButtonView: View {
    let button: CalculatorButton
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(button.title)
                .font(.system(size: 32))
                .frame(width: self.buttonWidth, height: self.buttonHeight)
                .background(button.backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(buttonWidth / 2)
        }
    }
    
    private var buttonWidth: CGFloat {
        button == .number(0) ? 140 : 70
    }
    
    private var buttonHeight: CGFloat {
        70
    }
}

// MARK: - Calculator Button Enum
enum CalculatorButton: Hashable {
    case number(Int)
    case operation(String)
    case equals
    case clear
    case decimal
    
    var title: String {
        switch self {
        case .number(let value): return "\(value)"
        case .operation(let op): return op
        case .equals: return "="
        case .clear: return "C"
        case .decimal: return "."
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .number: return Color.blue
        case .operation: return Color.orange
        case .equals: return Color.green
        case .clear: return Color.red
        case .decimal: return Color.blue
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
