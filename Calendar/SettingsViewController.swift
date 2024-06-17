//import UIKit
//import SwiftUI
//
//@available(iOS 15.0, *)
//class SettingsViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addSettingsView()
//    }
//
//    private func addSettingsView() {
//        // Create the SwiftUI view
//        let settingsView = SettingsView()
//
//        // Create a UIHostingController with the SwiftUI view
//        let hostingController = UIHostingController(rootView: settingsView)
//
//        // Add the hosting controller as a child view controller
//        addChild(hostingController)
//
//        // Add the hosting controller's view to the view hierarchy
//        view.addSubview(hostingController.view)
//
//        // Set up constraints or frame
//        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
//            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//
//        // Notify the hosting controller that it has been moved to the parent view controller
//        hostingController.didMove(toParent: self)
//    }
//}
//
//class SettingsViewModel: ObservableObject {
//    @Published var tempStepValue: Int
//    @Published var savedStepValue: Int
//    @Published var tempCalorieValue: Int
//    @Published var savedCalorieValue: Int
//    @Published var tempHRValue: Int
//    @Published var savedHRValue: Int
//    @Published var tempRunValue: Int
//    @Published var savedRunValue: Int
//    @Published var tempFLValue: Int
//    @Published var savedFLValue: Int
//    @Published var tempTimeValue: Date
//    @Published var savedTimeValue: Date
//    @Published var completionConfettiEnabled: Bool = false
//    @Published var completionPastDays: Bool = false
//
//    private let defaults = UserDefaults.standard
//    private let defaultStepValue = 10000
//    private let defaultCalorieValue = 500
//    private let defaultHRValue = 60
//    private let defaultRunValue = 150
//    private let defaultFLValue = 10
//
//    // Default time value set to 00:00
//    private let defaultTimeValue: Date = {
//        var components = DateComponents()
//        components.hour = 0
//        components.minute = 0
//        return Calendar.current.date(from: components) ?? Date()
//    }()
//
//    init() {
//        self.tempStepValue = defaults.integer(forKey: "stepGoal")
//        self.savedStepValue = defaults.integer(forKey: "stepGoal") == 0 ? defaultStepValue : defaults.integer(forKey: "stepGoal")
//
//        self.tempCalorieValue = defaults.integer(forKey: "calorieGoal")
//        self.savedCalorieValue = defaults.integer(forKey: "calorieGoal") == 0 ? defaultCalorieValue : defaults.integer(forKey: "calorieGoal")
//
//        self.tempHRValue = defaults.integer(forKey: "hrGoal")
//        self.savedHRValue = defaults.integer(forKey: "hrGoal") == 0 ? defaultHRValue : defaults.integer(forKey: "hrGoal")
//
//        self.tempRunValue = defaults.integer(forKey: "runGoal")
//        self.savedRunValue = defaults.integer(forKey: "runGoal") == 0 ? defaultRunValue : defaults.integer(forKey: "runGoal")
//
//        self.tempFLValue = defaults.integer(forKey: "flGoal")
//        self.savedFLValue = defaults.integer(forKey: "flGoal") == 0 ? defaultFLValue : defaults.integer(forKey: "flGoal")
//
//        if let savedTime = defaults.object(forKey: "timeGoal") as? Date {
//            self.tempTimeValue = savedTime
//            self.savedTimeValue = savedTime
//        } else {
//            self.tempTimeValue = defaultTimeValue
//            self.savedTimeValue = defaultTimeValue
//        }
//    }
//
//    func saveStepGoal() {
//        savedStepValue = tempStepValue
//        defaults.set(savedStepValue, forKey: "stepGoal")
//    }
//
//    func saveCalorieGoal() {
//        savedCalorieValue = tempCalorieValue
//        defaults.set(savedCalorieValue, forKey: "calorieGoal")
//    }
//
//    func saveHRGoal() {
//        savedHRValue = tempHRValue
//        defaults.set(savedHRValue, forKey: "hrGoal")
//    }
//
//    func saveRunGoal() {
//        savedRunValue = tempRunValue
//        defaults.set(savedRunValue, forKey: "runGoal")
//    }
//
//    func saveFLGoal() {
//        savedFLValue = tempFLValue
//        defaults.set(savedFLValue, forKey: "flGoal")
//    }
//
//    func saveTimeGoal() {
//        savedTimeValue = tempTimeValue
//        defaults.set(savedTimeValue, forKey: "timeGoal")
//    }
//}
//
//@available(iOS 15.0, *)
//struct SettingsView: View {
//    @StateObject private var viewModel = SettingsViewModel()
//
//    var body: some View {
//        NavigationView {
//            List {
//                // IN-APP PURCHASES SECTION
//                Section(header: Text("In-App Purchases")) {
//                    NavigationLink(destination: Text("Coming soon")){
//                        HStack {
//                            ZStack {
//                                Image(systemName: "crown.fill")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.red)
//                            .cornerRadius(6)
//
//                            Text("Upgrade to Premium")
//                        }
//                    }
//                    NavigationLink(destination: Text("Coming soon")) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "arrow.clockwise")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.teal)
//                            .cornerRadius(6)
//
//                            Text("Restore Purchases")
//                        }
//                    }
//                }
//                //Goals
//                Section(header: Text("Goals")) {
//                    NavigationLink(destination: StepGoalView(tempValue: $viewModel.tempStepValue, savedValue: $viewModel.savedStepValue, saveGoal: viewModel.saveStepGoal, range: Array(stride(from: 1000, to: 50001, by: 100)), title: "Step Goal")) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "figure.walk")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.orange)
//                            .cornerRadius(6)
//
//                            Text("Steps")
//                            Spacer()
//                            Text("\(viewModel.savedStepValue)").foregroundColor(.gray)
//                        }
//                    }
//                    NavigationLink(destination: StepGoalView(tempValue: $viewModel.tempCalorieValue, savedValue: $viewModel.savedCalorieValue, saveGoal: viewModel.saveCalorieGoal, range: Array(stride(from: 0, to: 5001, by: 100)), title: "Calorie Goal")) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "flame")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.red)
//                            .cornerRadius(6)
//
//                            Text("Active calories")
//                            Spacer()
//                            Text("\(viewModel.savedCalorieValue)").foregroundColor(.gray)
//                        }
//                    }
//                    NavigationLink(destination: TimePickerView(tempTimeValue: $viewModel.tempTimeValue, savedTimeValue: $viewModel.savedTimeValue, saveTimeGoal: viewModel.saveTimeGoal)) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "moon.stars")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.blue)
//                            .cornerRadius(6)
//
//                            Text("Sleep hours")
//                            Spacer()
//                            Text("\(viewModel.savedTimeValue, style: .time)").foregroundColor(.gray)
//                        }
//                    }
//                    NavigationLink(destination: StepGoalView(tempValue: $viewModel.tempHRValue, savedValue: $viewModel.savedHRValue, saveGoal: viewModel.saveHRGoal, range: Array(0...100), title: "Heart Rate Goal")) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "heart.fill")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.pink)
//                            .cornerRadius(6)
//
//                            Text("Resting Heart Rate")
//                            Spacer()
//                            Text("\(viewModel.savedHRValue)").foregroundColor(.gray)
//                        }
//                    }
//                    NavigationLink(destination: StepGoalView(tempValue: $viewModel.tempRunValue, savedValue: $viewModel.savedRunValue, saveGoal: viewModel.saveRunGoal, range: Array(stride(from: 0, to: 1001, by: 50)), title: "Weekly Running Goal")) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "figure.run")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.cyan)
//                            .cornerRadius(6)
//
//                            Text("Weekly running minutes")
//                            Spacer()
//                            Text("\(viewModel.savedRunValue)").foregroundColor(.gray)
//                        }
//                    }
//                    NavigationLink(destination: StepGoalView(tempValue: $viewModel.tempFLValue, savedValue: $viewModel.savedFLValue, saveGoal: viewModel.saveFLGoal, range: Array(0...200), title: "Flights Climbed Goal")) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "figure.step.training")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.yellow)
//                            .cornerRadius(6)
//
//                            Text("Flights climbed")
//                            Spacer()
//                            Text("\(viewModel.savedFLValue)").foregroundColor(.gray)
//                        }
//                    }
//                }
//
//                // CONFIGURATIONS SECTION
//                Section(header: Text("Configurations")) {
//                    Toggle(isOn: $viewModel.completionConfettiEnabled) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "calendar")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.green)
//                            .cornerRadius(6)
//
//                            Text("Complete Past Days")
//                        }
//                    }
//                    Toggle(isOn: $viewModel.completionPastDays) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "sparkles")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.brown)
//                            .cornerRadius(6)
//
//                            Text("Completion Confetti")
//                        }
//                    }
//                }
//
//                // SPREAD THE WORD SECTION
//                Section(header: Text("Spread the Word")) {
//                    NavigationLink(destination: Text("Coming soon")) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "star.fill")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.purple)
//                            .cornerRadius(6)
//
//                            Text("Rate App")
//                        }
//                    }
//
//                    NavigationLink(destination: Text("Coming soon")) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "square.and.arrow.up")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.indigo)
//                            .cornerRadius(6)
//
//                            Text("Share App")
//                        }
//                    }
//                }
//
//                // SUPPORT & PRIVACY SECTION
//                Section(header: Text("Support & Privacy")) {
//                    NavigationLink(destination: Text("Coming soon")) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "envelope.fill")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.blue)
//                            .cornerRadius(6)
//
//                            Text("Contact Us")
//                        }
//                    }
//                    NavigationLink(destination: Text("Coming soon")) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "hand.raised.fill")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.gray)
//                            .cornerRadius(6)
//
//                            Text("Privacy Policy")
//                        }
//                    }
//                    NavigationLink(destination: Text("Coming soon")) {
//                        HStack {
//                            ZStack {
//                                Image(systemName: "doc.fill")
//                                    .font(.callout)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 28, height: 28)
//                            .background(Color.cyan)
//                            .cornerRadius(6)
//
//                            Text("Terms of Use")
//                        }
//                    }
//                }
//            }
//            .listStyle(GroupedListStyle())
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
//
//struct StepGoalView: View {
//    @Binding var tempValue: Int
//    @Binding var savedValue: Int
//    let saveGoal: () -> Void
//    let range: [Int]
//    let title: String
//
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        VStack {
//            Spacer()
//            Picker("Select \(title)", selection: $tempValue) {
//                ForEach(range, id: \.self) { value in
//                    Text("\(value)").tag(value)
//                }
//            }
//            .pickerStyle(WheelPickerStyle())
//            .padding()
//            Spacer()
//
//            Button(action: {
//                saveGoal()
//                presentationMode.wrappedValue.dismiss()
//            }) {
//                Text("Done")
//                    .font(.title2)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding(.horizontal, 30)
//        }
//        .padding()
//        .onDisappear {
//            if savedValue != tempValue {
//                tempValue = savedValue
//            }
//        }
//    }
//}
//
//struct TimePickerView: View {
//    @Binding var tempTimeValue: Date
//    @Binding var savedTimeValue: Date
//    let saveTimeGoal: () -> Void
//    @Environment(\.presentationMode) var presentationMode
//
//    @State private var isDonePressed = false
//
//    var body: some View {
//        VStack {
//            Spacer()
//            DatePicker("Select Preferred Time", selection: $tempTimeValue, displayedComponents: .hourAndMinute)
//                .datePickerStyle(WheelDatePickerStyle())
//                .labelsHidden()
//                .padding()
//
//            Spacer()
//
//            Button(action: {
//                isDonePressed = true
//                saveTimeGoal()
//                presentationMode.wrappedValue.dismiss()
//            }) {
//                Text("Done")
//                    .font(.title2)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding(.horizontal, 30)
//        }
//        .padding()
//        .onDisappear {
//            if !isDonePressed {
//                tempTimeValue = savedTimeValue
//            }
//        }
//    }
//}

import UIKit
import SwiftUI


class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSettingsView()
    }

    private func addSettingsView() {
        // Create the SwiftUI view
        let settingsView = SettingsView()
        
        // Create a UIHostingController with the SwiftUI view
        let hostingController = UIHostingController(rootView: settingsView)
        
        // Add the hosting controller as a child view controller
        addChild(hostingController)
        
        // Add the hosting controller's view to the view hierarchy
        view.addSubview(hostingController.view)
        
        // Set up constraints or frame
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Notify the hosting controller that it has been moved to the parent view controller
        hostingController.didMove(toParent: self)
    }
}

class SettingsViewModel: ObservableObject {
    @Published var tempStepValue: Int
    @Published var savedStepValue: Int
    @Published var tempCalorieValue: Int
    @Published var savedCalorieValue: Int
    @Published var tempHRValue: Int
    @Published var savedHRValue: Int
    @Published var tempRunValue: Int
    @Published var savedRunValue: Int
    @Published var tempFLValue: Int
    @Published var savedFLValue: Int
    @Published var tempTimeValue: DateComponents
    @Published var savedTimeValue: DateComponents
    @Published var completionConfettiEnabled: Bool = false
    @Published var completionPastDays: Bool = false

    private let defaults = UserDefaults.standard
    private let defaultStepValue = 10000
    private let defaultCalorieValue = 500
    private let defaultHRValue = 60
    private let defaultRunValue = 150
    private let defaultFLValue = 10
    
    // Default time value set to 00:00
    private let defaultTimeValue: DateComponents = {
        var components = DateComponents()
        components.hour = 0
        components.minute = 0
        return components
    }()
    
    
    init() {
        self.tempStepValue = defaults.integer(forKey: "stepGoal")
        self.savedStepValue = defaults.integer(forKey: "stepGoal") == 0 ? defaultStepValue : defaults.integer(forKey: "stepGoal")

        self.tempCalorieValue = defaults.integer(forKey: "calorieGoal")
        self.savedCalorieValue = defaults.integer(forKey: "calorieGoal") == 0 ? defaultCalorieValue : defaults.integer(forKey: "calorieGoal")

        self.tempHRValue = defaults.integer(forKey: "hrGoal")
        self.savedHRValue = defaults.integer(forKey: "hrGoal") == 0 ? defaultHRValue : defaults.integer(forKey: "hrGoal")

        self.tempRunValue = defaults.integer(forKey: "runGoal")
        self.savedRunValue = defaults.integer(forKey: "runGoal") == 0 ? defaultRunValue : defaults.integer(forKey: "runGoal")

        self.tempFLValue = defaults.integer(forKey: "flGoal")
        self.savedFLValue = defaults.integer(forKey: "flGoal") == 0 ? defaultFLValue : defaults.integer(forKey: "flGoal")
        
        if let savedTimeData = defaults.data(forKey: "timeGoal"),
           let savedTime = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTimeData) as? DateComponents {
            self.tempTimeValue = savedTime
            self.savedTimeValue = savedTime
        } else {
            self.tempTimeValue = defaultTimeValue
            self.savedTimeValue = defaultTimeValue
        }
    }
    
    func saveStepGoal() {
        savedStepValue = tempStepValue
        defaults.set(savedStepValue, forKey: "stepGoal")
    }

    func saveCalorieGoal() {
        savedCalorieValue = tempCalorieValue
        defaults.set(savedCalorieValue, forKey: "calorieGoal")
    }

    func saveHRGoal() {
        savedHRValue = tempHRValue
        defaults.set(savedHRValue, forKey: "hrGoal")
    }

    func saveRunGoal() {
        savedRunValue = tempRunValue
        defaults.set(savedRunValue, forKey: "runGoal")
    }

    func saveFLGoal() {
        savedFLValue = tempFLValue
        defaults.set(savedFLValue, forKey: "flGoal")
    }

    func saveTimeGoal() {
        savedTimeValue = tempTimeValue
        if let savedTimeData = try? NSKeyedArchiver.archivedData(withRootObject: savedTimeValue, requiringSecureCoding: false) {
            defaults.set(savedTimeData, forKey: "timeGoal")
        }
    }
}


struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                // IN-APP PURCHASES SECTION
                Section(header: Text("In-App Purchases")) {
                    NavigationLink(destination: Text("Coming soon")){
                        HStack {
                            ZStack {
                                Image(systemName: "crown.fill")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.red)
                            .cornerRadius(6)
                            
                            Text("Upgrade to Premium")
                        }
                    }
                    NavigationLink(destination: Text("Coming soon")) {
                        HStack {
                            ZStack {
                                Image(systemName: "arrow.clockwise")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.teal)
                            .cornerRadius(6)
                            
                            Text("Restore Purchases")
                        }
                    }
                }
                //Goals
                Section(header: Text("Goals")) {
                    NavigationLink(destination: StepGoalView(tempValue: $viewModel.tempStepValue, savedValue: $viewModel.savedStepValue, saveGoal: viewModel.saveStepGoal, range: Array(stride(from: 1000, to: 50001, by: 100)), title: "Step Goal")) {
                        HStack {
                            ZStack {
                                Image(systemName: "figure.walk")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.orange)
                            .cornerRadius(6)
                            
                            Text("Steps")
                            Spacer()
                            Text("\(viewModel.savedStepValue)").foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination: StepGoalView(tempValue: $viewModel.tempCalorieValue, savedValue: $viewModel.savedCalorieValue, saveGoal: viewModel.saveCalorieGoal, range: Array(stride(from: 0, to: 5001, by: 100)), title: "Calorie Goal")) {
                        HStack {
                            ZStack {
                                Image(systemName: "flame")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.red)
                            .cornerRadius(6)
                            
                            Text("Active calories")
                            Spacer()
                            Text("\(viewModel.savedCalorieValue)").foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination: TimePickerView(tempTimeValue: $viewModel.tempTimeValue, savedTimeValue: $viewModel.savedTimeValue, saveTimeGoal: viewModel.saveTimeGoal)) {
                        HStack {
                            ZStack {
                                Image(systemName: "moon.stars")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.blue)
                            .cornerRadius(6)

                            Text("Sleep duration")
                            Spacer()
                            Text("\(viewModel.savedTimeValue.hour ?? 0) hrs \(viewModel.savedTimeValue.minute ?? 0) mins").foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination: StepGoalView(tempValue: $viewModel.tempHRValue, savedValue: $viewModel.savedHRValue, saveGoal: viewModel.saveHRGoal, range: Array(0...100), title: "Heart Rate Goal")) {
                        HStack {
                            ZStack {
                                Image(systemName: "heart.fill")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.pink)
                            .cornerRadius(6)
                            
                            Text("Resting Heart Rate")
                            Spacer()
                            Text("\(viewModel.savedHRValue)").foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination: StepGoalView(tempValue: $viewModel.tempRunValue, savedValue: $viewModel.savedRunValue, saveGoal: viewModel.saveRunGoal, range: Array(stride(from: 0, to: 601, by: 50)), title: "Weekly Running Goal")) {
                        HStack {
                            ZStack {
                                Image(systemName: "figure.run")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.cyan)
                            .cornerRadius(6)
                            
                            Text("Weekly running minutes")
                            Spacer()
                            Text("\(viewModel.savedRunValue)").foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination: StepGoalView(tempValue: $viewModel.tempFLValue, savedValue: $viewModel.savedFLValue, saveGoal: viewModel.saveFLGoal, range: Array(0...200), title: "Flights Climbed Goal")) {
                        HStack {
                            ZStack {
                                Image(systemName: "figure.step.training")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.yellow)
                            .cornerRadius(6)
                            
                            Text("Flights climbed")
                            Spacer()
                            Text("\(viewModel.savedFLValue)").foregroundColor(.gray)
                        }
                    }
                }

                // CONFIGURATIONS SECTION
                Section(header: Text("Configurations")) {
                    Toggle(isOn: $viewModel.completionConfettiEnabled) {
                        HStack {
                            ZStack {
                                Image(systemName: "calendar")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.green)
                            .cornerRadius(6)
                            
                            Text("Complete Past Days")
                        }
                    }
                    Toggle(isOn: $viewModel.completionPastDays) {
                        HStack {
                            ZStack {
                                Image(systemName: "sparkles")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.brown)
                            .cornerRadius(6)
                            
                            Text("Completion Confetti")
                        }
                    }
                }
                
                // SPREAD THE WORD SECTION
                Section(header: Text("Spread the Word")) {
                    NavigationLink(destination: Text("Coming soon")) {
                        HStack {
                            ZStack {
                                Image(systemName: "star.fill")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.purple)
                            .cornerRadius(6)
                            
                            Text("Rate App")
                        }
                    }
                    
                    NavigationLink(destination: Text("Coming soon")) {
                        HStack {
                            ZStack {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.indigo)
                            .cornerRadius(6)
                            
                            Text("Share App")
                        }
                    }
                }
                
                // SUPPORT & PRIVACY SECTION
                Section(header: Text("Support & Privacy")) {
                    NavigationLink(destination: Text("Coming soon")) {
                        HStack {
                            ZStack {
                                Image(systemName: "envelope.fill")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.blue)
                            .cornerRadius(6)
                            
                            Text("Contact Us")
                        }
                    }
                    NavigationLink(destination: Text("Coming soon")) {
                        HStack {
                            ZStack {
                                Image(systemName: "hand.raised.fill")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.gray)
                            .cornerRadius(6)
                            
                            Text("Privacy Policy")
                        }
                    }
                    NavigationLink(destination: Text("Coming soon")) {
                        HStack {
                            ZStack {
                                Image(systemName: "doc.fill")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 28, height: 28)
                            .background(Color.cyan)
                            .cornerRadius(6)
                            
                            Text("Terms of Use")
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StepGoalView: View {
    @Binding var tempValue: Int
    @Binding var savedValue: Int
    let saveGoal: () -> Void
    let range: [Int]
    let title: String
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            Picker("Select \(title)", selection: $tempValue) {
                ForEach(range, id: \.self) { value in
                    Text("\(value)").tag(value)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()
            Spacer()
            
            Button(action: {
                saveGoal()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 30)
        }
        .padding()
        .onDisappear {
            if savedValue != tempValue {
                tempValue = savedValue
            }
        }
    }
}
struct TimePickerView: View {
    @Binding var tempTimeValue: DateComponents
    @Binding var savedTimeValue: DateComponents
    let saveTimeGoal: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedHours: Int
    @State private var selectedMinutes: Int
    @State private var isDonePressed = false
    
    init(tempTimeValue: Binding<DateComponents>, savedTimeValue: Binding<DateComponents>, saveTimeGoal: @escaping () -> Void) {
        _tempTimeValue = tempTimeValue
        _savedTimeValue = savedTimeValue
        self.saveTimeGoal = saveTimeGoal
        
        // Initialize selectedHours and selectedMinutes based on tempTimeValue
        _selectedHours = State(initialValue: tempTimeValue.wrappedValue.hour ?? 0)
        _selectedMinutes = State(initialValue: tempTimeValue.wrappedValue.minute ?? 0)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Picker("Select Duration", selection: $selectedHours) {
                ForEach(0..<24, id: \.self) { hour in
                    Text("\(hour) hours").tag(hour)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .onChange(of: selectedHours) { newValue in
                tempTimeValue.hour = newValue
            }
            .padding()
            
            Picker("Select Minutes", selection: $selectedMinutes) {
                ForEach(0..<60, id: \.self) { minute in
                    Text("\(minute) minutes").tag(minute)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .onChange(of: selectedMinutes) { newValue in
                tempTimeValue.minute = newValue
            }
            .padding()

            Spacer()
            
            Button(action: {
                isDonePressed = true
                saveTimeGoal()
                
//                let defaults = UserDefaults.standard
//
//                        let stepGoal = defaults.integer(forKey: "stepGoal")
//                        let calorieGoal = defaults.integer(forKey: "calorieGoal")
//                        let hrGoal = defaults.integer(forKey: "hrGoal")
//                        let runGoal = defaults.integer(forKey: "runGoal")
//                        let flGoal = defaults.integer(forKey: "flGoal")
//
//                        var timeGoalString = ""
//                        if let savedTimeData = defaults.data(forKey: "timeGoal"),
//                           let savedTime = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTimeData) as? DateComponents {
//                            timeGoalString = "\(savedTime.hour ?? 0) hrs \(savedTime.minute ?? 0) mins"
//                        }
//
//                        print("User Defaults:")
//                        print("Daily Step Goal (stepGoal): \(stepGoal)")
//                        print("Active Calorie Goal (calorieGoal): \(calorieGoal)")
//                        print("Resting Heart Rate Goal (hrGoal): \(hrGoal)")
//                        print("Running Distance Goal (runGoal): \(runGoal)")
//                        print("Flights Climbed Goal (flGoal): \(flGoal)")
//                        print("Sleep Duration Goal (timeGoal): \(timeGoalString)")
                presentationMode.wrappedValue.dismiss()

            }) {
                Text("Done")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 30)
        }
        .padding()
        .onDisappear {
            if !isDonePressed {
                // Reset tempTimeValue to savedTimeValue when dismissed without saving
                tempTimeValue = savedTimeValue
                selectedHours = tempTimeValue.hour ?? 0
                selectedMinutes = tempTimeValue.minute ?? 0
            }
        }
    }
}
