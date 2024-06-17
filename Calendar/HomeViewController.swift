//
//  HomeViewController.swift
//  Calendar
//
//  Created by Farih Muhammad on 27/05/2024.
//

import UIKit
import SwiftUI
import EventKit

class HomeViewController: UIViewController , ContentViewDelegate{
    let timePickerViewModel = TimePickerViewModel(initialTime: Date())

    override func viewDidLoad() {
        super.viewDidLoad()
        addContentView()
        
    }
    
    private func addContentView() {
        // Create the SwiftUI view
        var contentView = ContentView()
        contentView.delegate = self
        // Create a UIHostingController with the SwiftUI view
        let hostingController = UIHostingController(rootView: contentView)
        
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
    func didTapCircleButton(remainingSteps: Double, activityTitle: String) {
        if remainingSteps <= 0 && activityTitle.lowercased().contains("steps"){
            // User has reached step goal
            let alertController = UIAlertController(title: "Congratulations!", message: "You've completed your step goal!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true, completion: nil)
        } else {
            // User hasn't reached step goal
            let alertController = UIAlertController(title: "Activity Recommendation", message: "Would you like to receive an activity recommendation?", preferredStyle: .alert)
            let chooseTimeAction = UIAlertAction(title: "Choose Time", style: .default) { _ in
                // Implement code to choose available time
                self.presentTimePicker(for: activityTitle)
            }
            // Add action to add event
            let addAction = UIAlertAction(title: "Yes", style: .default) { _ in
                // Retrieve preferred date/time from UserDefaults
                let userDefaults = UserDefaults.standard
                if let timeGoal = userDefaults.object(forKey: "timeGoal") as? Date {
                    // Get today's date
                    let today = Date()
                    
                    // Create a Calendar instance
                    var calendar = Calendar.current
                    calendar.timeZone = TimeZone.current
                    
                    // Get the time components from timeGoal
                    let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: timeGoal)
                    
                    // Create a new Date object with today's date and time components from timeGoal
                    if let combinedDate = calendar.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: timeComponents.second ?? 0, of: today) {
                        // Check for conflicting events
                        let calendarVC = CalendarViewController()
                        let conflictingEvents = calendarVC.hasConflictingEvents(startDate: combinedDate, duration: 3600)
                        if !conflictingEvents.isEmpty {
                            // There are conflicting events
                            let conflictingEventNames = conflictingEvents.joined(separator: ", ")
                            print("Conflicting events: \(conflictingEventNames)")

                            let alertController = UIAlertController(title: "Conflicting Events", message: "There are conflicting events: \(conflictingEventNames). Would you like to choose an available time?", preferredStyle: .alert)

                            let chooseTimeAction = UIAlertAction(title: "Choose Time", style: .default) { _ in
                                // Implement code to choose available time
                                self.presentTimePicker(for: activityTitle)
                            }
                            let addAnywayAction = UIAlertAction(title: "Add Anyway", style: .default) { _ in
                                // Add event anyway
                                calendarVC.createHealthEvent(with: activityTitle, startTime: combinedDate)
                                let successAlert = UIAlertController(title: "Event Added", message: "Your health event has been added to the calendar.", preferredStyle: .alert)
                                successAlert.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(successAlert, animated: true, completion: nil)
                            }
                            alertController.addAction(chooseTimeAction)
                            alertController.addAction(addAnywayAction)
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            // No conflicting events, add event directly
                            calendarVC.createHealthEvent(with: activityTitle, startTime: combinedDate)
                            let successAlert = UIAlertController(title: "Event Added", message: "Your health event has been added to the calendar.", preferredStyle: .alert)
                            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(successAlert, animated: true, completion: nil)
                        }
                    } else {
                        // Handle error in creating combined date
                        print("Error: Unable to create combined date")
                    }
                } else {
                    // Handle case where preferred date/time is not set in UserDefaults
                    print("Preferred date/time is not set in UserDefaults")
                }
            }

            // Add cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(chooseTimeAction)
//            alertController.addAction(addAction)
            alertController.addAction(cancelAction)

            // Present the alert
            present(alertController, animated: true, completion: nil)
        }
            
    }




        
    private func presentTimePicker(for activityTitle: String) {
        // Instantiate your SwiftUI time picker view with the view model
        let timePickerView = ConflictingTimePickerView(viewModel: timePickerViewModel, activityTitle: activityTitle) { selectedTime in
            // Handle the selected time
            let calendarVC = CalendarViewController()
            let conflictingEvents = calendarVC.hasConflictingEvents(startDate: selectedTime, duration: 3600)
            
            if !conflictingEvents.isEmpty {
                // There are conflicting events
                let conflictingEventNames = conflictingEvents.joined(separator: ", ")
                print("Conflicting events: \(conflictingEventNames)")

                // Present an alert for conflicting events
                let alertController = UIAlertController(title: "Conflicting Events", message: "There are conflicting events: \(conflictingEventNames). Would you like to choose an available time?", preferredStyle: .alert)

                let chooseTimeAction = UIAlertAction(title: "Choose Time", style: .default) { _ in
                    // Implement code to choose available time
                    self.presentTimePicker(for: activityTitle)
                }
                let addAnywayAction = UIAlertAction(title: "Add Anyway", style: .default) { _ in
                    // Add event anyway
                    calendarVC.createHealthEvent(with: activityTitle, startTime: selectedTime)
                    let successAlert = UIAlertController(title: "Event Added", message: "Your health event has been added to the calendar.", preferredStyle: .alert)
                    successAlert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(successAlert, animated: true, completion: nil)
                }
                alertController.addAction(chooseTimeAction)
                alertController.addAction(addAnywayAction)
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                // No conflicting events, add event directly
                calendarVC.createHealthEvent(with: activityTitle, startTime: selectedTime)
                
                // Show success alert
                let successAlert = UIAlertController(title: "Event Added", message: "Your health event has been added to the calendar.", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(successAlert, animated: true, completion: nil)
            }
        }
        
        // Wrap the SwiftUI view in a UIHostingController
        let hostingController = UIHostingController(rootView: timePickerView)
        
        // Present the UIHostingController
        present(hostingController, animated: true, completion: nil)
    }





    
}

class TimePickerViewModel: ObservableObject {
    @Published var selectedTime: Date

    init(initialTime: Date) {
        self.selectedTime = initialTime
    }
}



struct ConflictingTimePickerView: View {
    @ObservedObject var viewModel: TimePickerViewModel
    var activityTitle:String
    var onDone: (Date) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingConflictAlert = false
    @State private var conflictingEventNames = ""
    
    var body: some View {
        VStack {
            Spacer()
            DatePicker("Select Preferred Time", selection: $viewModel.selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()
                .onChange(of: viewModel.selectedTime) { newValue in
                    // Print the new value of the time picker
                    print("New Time Value:", newValue)
                }
            
            Spacer()
            
            Button(action: {
                // Check for conflicting events
                let calendarVC = CalendarViewController()
                let conflictingEvents = calendarVC.hasConflictingEvents(startDate: viewModel.selectedTime, duration: 3600)
                
                if !conflictingEvents.isEmpty {
                    // There are conflicting events
                    conflictingEventNames = conflictingEvents.joined(separator: ", ")
                    showingConflictAlert = true
                    
                } else {
                    // No conflicting events, proceed with onDone callback
                    onDone(viewModel.selectedTime)
                    presentationMode.wrappedValue.dismiss() // Dismiss the picker
                }
                
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
        .alert(isPresented: $showingConflictAlert) {
            Alert(title: Text("Conflicting Events"),
                  message: Text("There are conflicting events: \(conflictingEventNames). Would you like to choose an available time?"),
                  primaryButton: .default(Text("Choose Time"), action: {
                      // Implement code to choose available time
                      // You may want to handle this case based on your app's design
                  }),
                  secondaryButton: .default(Text("Add Anyway"), action: {
                      // Add event anyway
                      let calendarVC = CalendarViewController()
                      calendarVC.createHealthEvent(with: self.activityTitle, startTime: self.viewModel.selectedTime)
                self.viewModel.selectedTime = Date()
                                            
                      // Call onDone callback and dismiss presentation mode
                      self.onDone(self.viewModel.selectedTime)
                      self.presentationMode.wrappedValue.dismiss()
                  })
            )
        }
    }
}







//
//  ContentView.swift
//  StepByStep
//
//  Created by Farih Muhammad on 27/05/2024.
//


protocol ContentViewDelegate: AnyObject {
    func didTapCircleButton(remainingSteps: Double, activityTitle: String)
}

struct Actvity:Identifiable{
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let ammount: String
}


struct ContentView: View {
    let theOpenAIClass = OpenAIConnector()
    @ObservedObject var healthManager = HealthManager()
    @StateObject private var eventViewModel = EventViewModel()
    @State private var selectedActivity: Actvity?
    @State var displayType: DisplayType = .list
    weak var delegate: ContentViewDelegate?
    @State private var isShowingAllActivities = false // State to control navigation to all activities view
    @AppStorage("stepGoal") var stepGoal: Int = 10000
    @State private var currentIndex = 0 // Track index of current recommendation


    var steps: [Step] {
        healthManager.steps.sorted { $0.date > $1.date }
    }
    @State private var recommendations: [String] = []

//    var recommendations: [String] {
//        var recommendations: [String] = Array(repeating: "", count: 2) // Initialize with empty strings or appropriate default values
//
//        // Add recommendations based on conditions at specific indices
//        if let step = steps.first {
//            let remainingSteps = max(0, stepGoal - step.count)
//            recommendations[0] = "🚶‍♂️ Complete the remaining \(remainingSteps) steps today"
//        } else {
//            print("No steps data available")
//        }
//
//        if let sleepHoursString = healthManager.activities["timeAsleep"]?.ammount,
//           let sleepHoursStringWithoutHours = Double(sleepHoursString.replacingOccurrences(of: " hours", with: "")),
//           sleepHoursStringWithoutHours < 8 {
//            recommendations[1] = "😴 Take a nap for better rest"
//        } else {
//            print("No sleep data available or sleep hours are sufficient")
//        }
//
//        if let frequentEvents = eventViewModel.mostFrequentEvents {
//            for event in frequentEvents.prefix(20) {
//                if let eventTitle = event.title {
//                    recommendations.append("\(eventTitle)")
//                    print("\(eventTitle)")
//                } else {
//                    print("Event title is nil for some events")
//
//
//                }
//            }
//        } else {
//            print("No frequent events available")
//        }
//
//        return recommendations
//    }



    // append title complete remaining calculated steps from stepgoal
    // append take a nap if sleep is less than 8 hours
    // append EventViewModel most frequent event
    
    var ongoingEvent: EKEvent? {
            let now = Date()
            return eventViewModel.todaysEvents
                .filter { !$0.isAllDay }
                .first { $0.startDate <= now && $0.endDate >= now }
        }

        var upcomingEvent: EKEvent? {
            let now = Date()
            return eventViewModel.todaysEvents
                .filter { !$0.isAllDay }
                .first { $0.startDate > now }
        }


    var body: some View {
        VStack {


            ScrollView{
                HStack {
                                Text("At a Glance")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.leading)

                                Spacer()

                    NavigationLink(destination:         ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 2)) {
                            let activities = healthManager.activities.sorted(by: { $0.value.id < $1.value.id })
                            ForEach(Array(activities.enumerated()), id: \.element.key) { index, item in
                                Button(action: {
                                    openHealthApp()
                                                    }){
                                    ActivityCard(activity: item.value, isFirst: index == 0)
                                    .padding(.bottom)}

                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        }
                        .padding(.horizontal,10)

                    }
                    .navigationBarTitle("Health", displayMode: .inline)
                    .padding(.horizontal)) {
                        Text("See All")
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                            }
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 2)) {
                    let activities = Array(healthManager.activities.values.sorted(by: { $0.id < $1.id }).prefix(4))
                    ForEach(activities, id: \.id) { activity in
                        Button(action: {
                            openHealthApp()
                                            }){
                        ActivityCard(activity: activity, isFirst: activities.first?.id == activity.id)
                        .padding(.bottom)}

                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                .padding(.horizontal,10)
                if let step = steps.first {
                    let remainingSteps = max(0, stepGoal - step.count)
                    
//                    if let combinedDate = getCombinedDate() {
                        
                        RecommendationCard(activityTitle: recommendations[safe: currentIndex] ?? "No recommendations", timeGoal: Date(), addAction: {
                            delegate?.didTapCircleButton(remainingSteps: Double(remainingSteps), activityTitle: recommendations[currentIndex])
                        }) {
                            // Next button action
                            currentIndex += 1
                            if currentIndex >= recommendations.count {
//                                currentIndex = 0 // Wrap around to the beginning
                                //                                replace repopulate the recommendations with chat gpt recommendations
//                                if let newRecommendation =  theOpenAIClass.processPrompt(prompt:           "reference of list of common events\n🏋️ exercise\n🚿 shower\n🏃‍♂️🏃 run\n🛌 PREPARE FOR BED\n🚶‍♂️walk to campus\n🏊‍♂️ swim\nPUSH NECK TRAPS SHOULDERS\nLEGS SHOULDERS\nLEGS\nPUSH\n🥤belanja/buy juice\nPULL\nPULL AND NECK\nOnsite: LEC - Machine Learning\nOnsite: LEC - Software Engineering\nREFLECT/TED TALKS/READ/STOCKS/EDITING/ARABIC/FUTURE RESEARCH\nOnsite: LEC - Artificial Intelligence\nOnsite: LEC - Algorithm Design and Analysis\nLearning time - Chinese for Beginners\nOnsite: LEC - Research Methodology in Computer Science\n\nreference on list of health goals so that the activities allow user to fulfill these goals daily\nUser Defaults:\nDaily Step Goal (stepGoal): 5100\nActive Calorie Goal (calorieGoal): 1200\nResting Heart Rate Goal (hrGoal): 71\nRunning Distance Goal (runGoal): 100\nFlights Climbed Goal (flGoal): 10\nSleep Duration Goal (timeGoal): 4 hrs 10 mins\n\nreference on health stats for todays to compare if its reaching target goal\nResting Heart Rate: \"64 BPM\"\nFlights Climbed: \"5\"\nActive Calories: \"500\"\nResting Heart Rate: \"64 BPM\"\nSteps: \"7,000\"\nWeekly Running:\"0 min\"\n\nrecommend a list of activity titles with emoji NOT THE SAME AS INPUT\nin the format [\"emoji titleName\"]"){
//                                    recommendations[0] = new
//                                }
                                fetchNewRecommendations()
                                currentIndex = 0 // Reset index to loop through recommendations again


                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 10)
                        .padding(.bottom)
                        
//                    }
                }
//            if let step = steps.first {
//                Button(action: {
//                    let remainingSteps = max(0, stepGoal - step.count)
//                    delegate?.didTapCircleButton(remainingSteps: Double(remainingSteps))
//                }) {
//                    VStack {
//                        Text("+ Event Recommendation")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                    }
//                    .frame(maxWidth: .infinity, minHeight: 65)
//                    .background(Color.purple)
//                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
//                    //                    ZStack {
//                    //                        Circle()
//                    //                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.150))
//                    //                                                .frame(width: 270, height: 270) // Larger frame for the gray circle
//                    //
//                    //                        Circle()
//                    //                            .trim(from: 0, to: CGFloat(step.count) / CGFloat(stepGoal))
//                    //                            .stroke(isUnderStepGoal(step.count) ? Color.blue : Color.green, style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
//                    //                            .frame(width: 230, height: 230) // Smaller frame for the stroke circle
//                    //                            .rotationEffect(.degrees(-90))
//                    //                        VStack {
//                    //                            Text("Today")
//                    //                                .font(.headline)
//                    //                            Text("\(step.count)")
//                    //                                .font(.system(size: 50))
//                    //                                .bold()
//                    //                            Text("Goal: \(stepGoal)")
//                    //                        }
//                    //                        .foregroundColor(.white)
//                    //                        .font(.system(.body, design: .rounded))
//                    //                    }
//                }
//                .buttonStyle(PlainButtonStyle())
//                //                .padding(.all, 50)
//            }


                VStack(alignment: .leading) {
                                    Text("Events")
                        .font(.title)
                        .fontWeight(.bold)
//                        .padding(.leading)


                                    if let ongoing = ongoingEvent {
                                        EventCard(event: ongoing, eventType: "Ongoing Event")

                                    }

                                    if let upcoming = upcomingEvent {
                                        EventCard(event: upcoming, eventType: "Upcoming Event")
                                          

                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)

            
            //            Text("ⓘ  Click to receive an activity recommendation").foregroundColor(.gray).font(.caption)

            //
            //            Picker("Selection", selection: $displayType) {
            //                ForEach(DisplayType.allCases) { displayType in
            //                    Image(systemName: displayType.icon).tag(displayType)
            //                }
            //            }
            //            .pickerStyle(.segmented)
            //
            //            switch displayType {
            //            case .list:
            //                StepListView(steps: Array(steps.dropFirst()))
            //            case .chart:
            //                StepsChartView(steps: steps)
            //            }
        }
        }
//        .onAppear {
//            Task {
//                await healthManager.requestAuthorization()
//                do {
//                    try await healthManager.calculateSteps()
//                } catch {
//                    print(error)
//                }
//            }
//        }
        .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            fetchNewRecommendations()
        }
    }
        .padding(.horizontal)
        
//        .sheet(item: $selectedActivity) { activity in
//            // Present details for selected activity
//            Text("Selected Activity: \(activity.title)")
//        }
    }
    private func getCombinedDate() -> Date? {
            let userDefaults = UserDefaults.standard
            guard let timeGoal = userDefaults.object(forKey: "timeGoal") as? Date else { return nil }
            let calendar = Calendar.current
            let today = Date()
            let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: timeGoal)
            return calendar.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: timeComponents.second ?? 0, of: today)
        }
    private func fetchNewRecommendations() {
        recommendations.removeAll()

        var prompt = "reference of list of common events\n"
                
            // Append frequent events if available, otherwise default events
            if let frequentEvents = eventViewModel.mostFrequentEvents {
                for event in frequentEvents.prefix(20) {
                    if let eventTitle = event.title {
                        prompt += "\(eventTitle)\n"
                    }
                }
            }
//        else {
//                prompt += """
//                    🥤belanja/buy juice
//                    PULL
//                    PULL AND NECK
//                    Onsite: LEC - Machine Learning
//                    Onsite: LEC - Software Engineering
//                    REFLECT/TED TALKS/READ/STOCKS/EDITING/ARABIC/FUTURE RESEARCH
//                    Onsite: LEC - Artificial Intelligence
//                    Onsite: LEC - Algorithm Design and Analysis
//                    Learning time - Chinese for Beginners
//                    Onsite: LEC - Research Methodology in Computer Science
//                    """
//            }

            let defaults = UserDefaults.standard
            
            let stepGoal = defaults.integer(forKey: "stepGoal")
            let calorieGoal = defaults.integer(forKey: "calorieGoal")
            let hrGoal = defaults.integer(forKey: "hrGoal")
            let runGoal = defaults.integer(forKey: "runGoal")
            let flGoal = defaults.integer(forKey: "flGoal")
            
            var timeGoalString = ""
            if let savedTimeData = defaults.data(forKey: "timeGoal"),
               let savedTime = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTimeData) as? DateComponents {
                timeGoalString = "\(savedTime.hour ?? 0) hrs \(savedTime.minute ?? 0) mins"
            }
            
            prompt += """
                \nreference on list of health goals so that the activities allow user to fulfill these goals daily\n
                User Defaults:
                Daily Step Goal (stepGoal): \(stepGoal)
                Active Calorie Goal (calorieGoal): \(calorieGoal)
                Resting Heart Rate Goal (hrGoal): \(hrGoal)
                Running Distance Goal (runGoal): \(runGoal)
                Flights Climbed Goal (flGoal): \(flGoal)
                Sleep Duration Goal (timeGoal): \(timeGoalString)\n
                reference on health stats for todays to compare if its reaching target goal\n
                """
        let activities = Array(healthManager.activities.values.sorted(by: { $0.id < $1.id }).prefix(4))
        for activity in activities {
             let amount = activity.ammount
                prompt += "\(activity.title): \(amount)\n"
            
        }

        prompt += """
            recommend a list of activity titles with emoji NOT THE SAME AS INPUT
            in the format ["emoji titleName"]
            """
        print(prompt)
            if let newRecommendations = theOpenAIClass.processPrompt(prompt: prompt) {
                var formattedRecommendations = newRecommendations.replacingOccurrences(of: "[", with: "")
                    formattedRecommendations = formattedRecommendations.replacingOccurrences(of: "]", with: "")
                    formattedRecommendations = formattedRecommendations.replacingOccurrences(of: ",", with: "")
                formattedRecommendations = formattedRecommendations.replacingOccurrences(of: "\"", with: "")

                    // Split the string into an array based on newline characters
                    recommendations = formattedRecommendations.components(separatedBy: "\n").filter { !$0.isEmpty }
                        if let step = steps.first {
                            let remainingSteps = max(0, stepGoal - step.count)
                            recommendations.append("🚶‍♂️ Complete the remaining \(remainingSteps) steps today")
                        } else {
                            print("No steps data available")
                        }
                
                        if let sleepHoursString = healthManager.activities["timeAsleep"]?.ammount,
                           let sleepHoursStringWithoutHours = Double(sleepHoursString.replacingOccurrences(of: " hours", with: "")),
                           sleepHoursStringWithoutHours < 8 {
                            recommendations.append("😴 Take a nap for better rest")
                        } else {
                            print("No sleep data available or sleep hours are sufficient")
                        }
                print(recommendations)

            }
        }
    private func openHealthApp() {
            if let url = URL(string: "x-apple-health://") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
}
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


struct RecommendationCard: View {
    var activityTitle: String
    var timeGoal: Date
    var addAction: () -> Void
    var nextAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recommendations ✨")
                .font(.headline)
                .foregroundColor(.white)
                .opacity(0.85)
            Text(activityTitle)
                .font(.title2)
                .bold()
                .lineLimit(nil)
                .foregroundColor(.white)

            Text(timeGoal, style: .time)
                .font(.subheadline)
                .foregroundColor(.white)
                .opacity(0.7)
                .padding(.bottom, 8)

            HStack(spacing: 16) {
                Button(action: addAction) {
                    Text("Add")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }

                Button(action: nextAction) {
                    Text("Next")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.purple)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
    }
}


struct EventCard: View {
    var event: EKEvent
    var eventType: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(eventType)
                .font(.headline)
                .padding(.bottom, 2)
                .foregroundColor(.black)
            Text(event.title)
                .font(.title2)
                .bold()
                .lineLimit(nil) // Allow the title to wrap
                .foregroundColor(.black)
            Text("\(event.startDate, style: .time) - \(event.endDate, style: .time)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            if let location = event.location, !location.isEmpty {
                Text(location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
        .padding(.bottom, 10)
    }
}




struct ActivityCard: View {
    @ObservedObject var healthManager = HealthManager()
    var steps: [Step] {
        healthManager.steps.sorted { $0.date > $1.date }
    }
    @State var activity: Actvity
    var isFirst: Bool
    @AppStorage("stepGoal") var stepGoal: Int = 10000
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemOrange)
                .cornerRadius(15)
            
            VStack(alignment: .leading) {
                if isFirst, let step = steps.first {
                    ZStack {
                        Circle()
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.150))
                            .frame(width: 130, height: 130)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(step.count) / CGFloat(stepGoal))
                            .stroke(isUnderStepGoal(step.count) ? Color.blue : Color.green, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .frame(width: 110, height: 110)
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            HStack{
                                Image(systemName: activity.image).foregroundColor(.pink)
                                Text(activity.title).font(.caption)
                            }
                            Text("\(step.count)")
                                .font(.system(size: 30))
                                .bold()
                            Text("Goal: \(stepGoal)")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .font(.system(.body, design: .rounded))
                    }
                    .padding(.horizontal, 10)
                } else {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Image(systemName: activity.image)
                                .foregroundColor(.pink)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(activity.title)
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                            Spacer()

                        }.padding(.leading, 10)
                        Spacer()

                        Text(activity.ammount)
                            .foregroundColor(.black)
                            .font(.system(size: 24))
                            .bold()
                            .padding()
                        Spacer()

                    }
                }
            }
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
    }
}



import Foundation

public class OpenAIConnector {
    let openAIURL = URL(string: "https://api.openai.com/v1/chat/completions")
    var openAIKey: String {
        return "YOUR-API-KEY"
    }
    
    private func executeRequest(request: URLRequest, withSessionConfig sessionConfig: URLSessionConfiguration?) -> Data? {
        let semaphore = DispatchSemaphore(value: 0)
        let session: URLSession
        if let sessionConfig = sessionConfig {
            session = URLSession(configuration: sessionConfig)
        } else {
            session = URLSession.shared
        }
        var requestData: Data?
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let data = data {
                requestData = data
            }
            semaphore.signal()
        }
        task.resume()
        
        let timeout = DispatchTime.now() + .seconds(20)
        _ = semaphore.wait(timeout: timeout)
        return requestData
    }
    
    public func processPrompt(prompt: String) -> String? {
        guard let url = openAIURL else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": prompt]
            ],
            "max_tokens": 100
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        } catch {
            print("Error creating request body: \(error)")
            return nil
        }
        
        guard let requestData = executeRequest(request: request, withSessionConfig: nil) else { return nil }
        
        let responseHandler = OpenAIResponseHandler()
        return responseHandler.decodeJson(data: requestData)?.choices.first?.message.content
    }
}

struct OpenAIResponseHandler {
    func decodeJson(data: Data) -> OpenAIResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(OpenAIResponse.self, from: data)
            return response
        } catch {
            print("Error decoding OpenAI API Response: \(error)")
            return nil
        }
    }
}

struct OpenAIResponse: Codable {
    var choices: [Choice]
}

struct Choice: Codable {
    var message: Message
}

struct Message: Codable {
    var content: String
}
