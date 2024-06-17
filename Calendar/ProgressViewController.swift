//
//  ProgressViewController.swift
//  Calendar
//
//  Created by Farih Muhammad on 14/06/2024.
//


import UIKit
import SwiftUI


class ProgressViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Ensure iOS version compatibility
            // Create ProgressView and embed in UIHostingController
            let progressView = ProgressView()
            let hostingController = UIHostingController(rootView: progressView)
            addChild(hostingController)
            view.addSubview(hostingController.view)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            hostingController.didMove(toParent: self)
    }
}


struct ProgressView: View {
    @State private var displayType: DisplayType = .list
    @ObservedObject private var healthManager = HealthManager()
    @AppStorage("stepGoal") private var stepGoal: Int = 10000

    var steps: [Step] {
        healthManager.steps.sorted { $0.date > $1.date }
    }

    var streak: Int {
        var streakCount = 0
        var currentStreak = 0
        
        // Iterate through the steps in reverse order (from oldest to newest)
        for index in stride(from: steps.count - 1, through: 0, by: -1) {
            let step = steps[index]
            
            // Check if the step count meets or exceeds the goal
            if step.count >= stepGoal {
                // Increment the current streak
                currentStreak += 1
            } else {
                // If current streak is longer than recorded streak, update streak count
                if currentStreak > streakCount {
                    streakCount = currentStreak
                }
                // Reset current streak
                currentStreak = 0
            }
            
            // Log the streak calculation for this step (optional, for debugging)
            print("Step \(steps.count - index): \(step.count) steps. Streak: \(currentStreak)")
        }
        
        return currentStreak
    }

    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink(destination: VStack {
                                VStack {
                                    Text("\(streak)")
                                        .font(.largeTitle)
                                }
                                .frame(maxWidth: .infinity, minHeight: 75)
                                .background(streak == 0 ? Color.gray : Color.orange)
                                .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                                .overlay(alignment: .topLeading) {
                                    HStack {
                                        Image(systemName: "flame")
                                            .foregroundStyle(streak == 0 ? .black : .red)
                                        Text("Streak")
                                    }
                                    .padding()
                                }

                                Picker("Selection", selection: $displayType) {
                                    ForEach(DisplayType.allCases, id: \.self) { displayType in
                                        Image(systemName: displayType.icon).tag(displayType)
                                    }
                                }
                                .pickerStyle(.segmented)

                                switch displayType {
                                case .list:
                                    StepListView(steps: Array(steps))
                                case .chart:
                                    StepsChartView(steps: steps)
                                }
                }.padding(.horizontal)){
                                
                                    VStack (alignment: .leading){
                                        Text("🚶‍♂️ Steps")
                                            .font(.title)
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 75)
                                    .background(Color.orange)
                                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                                    .padding()
                                
                            }

                NavigationLink(destination: Text("coming soon")) {
                    VStack(alignment: .leading) {
                        Text("🛌 Sleep")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, minHeight: 75)
                    .background(Color.blue  )
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .padding()
                }

                NavigationLink(destination: Text("coming soon")) {
                    VStack(alignment: .leading) {
                        Text("🔥 Calories")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, minHeight: 75)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .padding()
                }

                NavigationLink(destination: Text("coming soon")) {
                    VStack(alignment: .leading) {
                        Text("❤️ Resting Heart Rate")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, minHeight: 75)
                    .background(Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .padding()
                }
            }
        }
    }
}


import SwiftUI
import Charts
import EventKit


struct StepsChartView: View {
    
    let steps: [Step]
    
    var body: some View {
        Chart {
            ForEach(steps) { step in
                BarMark(x: .value("Date", step.date), y: .value("Count", step.count))
                    .foregroundStyle(isUnderStepGoal(step.count) ? .red: .green)
            }
        }
    }
}

import SwiftUI


struct StepListView: View {
    let steps: [Step]
    
    var body: some View {
        List(steps) { step in
            HStack {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(isUnderStepGoal(step.count) ? .red : .green)
                Text("\(step.count)")
                Spacer()
                Text(step.date.formatted(date:.abbreviated, time:.omitted))
            }
        }.listStyle(.plain)
    }
}


func isUnderStepGoal(_ count: Int) -> Bool {
    let stepGoal = UserDefaults.standard.integer(forKey: "stepGoal")
    return count < stepGoal
}

import SwiftUI

enum DisplayType: Int, Identifiable, CaseIterable{
    case list
    case chart
    var id: Int{
        rawValue
    }
}

extension DisplayType {
    
    var icon: String {
        switch self {
        case .list:
            return "list.bullet"
        case .chart:
            return "chart.bar"
        }
    }
}
