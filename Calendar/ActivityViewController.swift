//
//  ActivityViewController.swift
//  Calendar
//
//  Created by Farih Muhammad on 14/06/2024.
//

import UIKit
import SwiftUI


class ActivityViewController: UIViewController {
    var eventViewModel = EventViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create an instance of the SwiftUI view
        let todayEventsView = TodayEventsView(eventViewModel: eventViewModel)

        // Create a UIHostingController to host the SwiftUI view
        let hostingController = UIHostingController(rootView: todayEventsView)

        // Embed the SwiftUI view controller in the current view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        hostingController.didMove(toParent: self)
    }
}



import EventKit


struct TodayEventsView: View {
    @ObservedObject var eventViewModel: EventViewModel
       @State private var currentIndex = 0


    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Today's Events")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.vertical)
                
                
                if eventViewModel.todaysEvents.indices.contains(currentIndex) {
                                    RescheduleEventCard(eventViewModel: eventViewModel, event: eventViewModel.todaysEvents[currentIndex], currentIndex: $currentIndex)
                                        .padding(.bottom)
                                }

            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            if eventViewModel.todaysEvents.count > 10 {
                VStack {
                    Text("Reminder: You have too many activities today. Take a break and rest!")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, minHeight: 75)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.bottom)
                            }

            VStack(alignment: .leading) {
                ForEach(eventViewModel.todaysEvents, id: \.eventIdentifier) { event in
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .font(.headline)
                            .padding(.bottom, 2)
                        
                        Text("\(event.startDate, style: .time) - \(event.endDate, style: .time)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Divider()
                    }                            .padding(.bottom)

                    
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}



import SwiftUI
import EventKit


struct RescheduleEventCard: View {
    @ObservedObject var eventViewModel: EventViewModel
    var event: EKEvent
    @Binding var currentIndex: Int
    @State private var isRescheduled: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.title ?? "No Title")
                .font(.headline)
                .padding(.bottom, 2)
                .foregroundColor(.black)

            Text("\(event.startDate, style: .time) - \(event.endDate, style: .time)")
                .font(.subheadline)
                .foregroundColor(.gray)

            

            HStack(spacing: 16) {
                if isRescheduled {
                    Text("Event Rescheduled")
                        .foregroundColor(.green)
                } else {
                    Button(action: {
                        self.rescheduleEvent()
                    }) {
                        Text("Reschedule")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }

                Button(action: {
                    self.moveToNextEvent()
                }) {
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
        .padding(.bottom, 10)
    }

    private func rescheduleEvent() {
        eventViewModel.rescheduleEvent(event: event)
        isRescheduled = true
    }

    private func moveToNextEvent() {
            currentIndex += 1
            isRescheduled = false
            if currentIndex >= eventViewModel.todaysEvents.count {
                currentIndex = 0 // Loop back to the beginning
            }
        }
}

extension EKEvent: Identifiable {
    public var id: String {
        return eventIdentifier // Assuming eventIdentifier is unique for each event
    }
}
