//
//  CalendarViewController.swift
//  Calendar
//
//  Created by Richard Topchii on 09.05.2021.
//

import UIKit
import CalendarKit
import EventKit
import EventKitUI


final class CalendarViewController: DayViewController, EKEventEditViewDelegate,ObservableObject {
    private var eventStore = EKEventStore()
    private var healthManager = HealthManager()
    @Published var todaysEvents: [EKEvent] = []
    @Published var allEvents: [EKEvent] = []
    
    private let progressView: UIProgressView = {
            let progressView = UIProgressView(progressViewStyle: .default)
            progressView.progress = 0
            progressView.translatesAutoresizingMaskIntoConstraints = false
            return progressView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendar"
        let addButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNewEvent))
        addButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 30), .foregroundColor: UIColor.red], for: .normal)
        navigationItem.rightBarButtonItem = addButton
//        let addButton2 = UIBarButtonItem(title: "Reschedule", style: .plain, target: self, action: #selector(scheduleEvents))
//        addButton2.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 30), .foregroundColor: UIColor.red], for: .normal)
//        navigationItem.leftBarButtonItem = addButton2
        // The app must have access to the user's calendar to show the events on the timeline
        requestAccessToCalendar()
        // Subscribe to notifications to reload the UI when
        subscribeToNotifications()
//        healthManager.fetchTodaySteps { [weak self] steps in
//            self?.showSimpleAlert(with: steps)
//        }
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
                    progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                    progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
                    progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
                    progressView.heightAnchor.constraint(equalToConstant: 2) // Set height for the progress view
                ])
    }
//    @objc func scheduleEvents() {
//        // Get all events for the current day
//        let currentDate = Date()
//        let eventDescriptors = eventsForDate(currentDate)
//
//        // Convert event descriptors to EKWrapper instances
//        let events = eventDescriptors.compactMap { $0 as? EKWrapper }
//
//        // Define a recursive function to handle event scheduling
//        func scheduleEventAtIndex(_ index: Int) {
//            guard index < events.count else {
//                // If all events are processed, reload data to reflect the changes on the UI
//                reloadData()
//                return
//            }
//
//            let currentEvent = events[index]
//            let previousEvent = index > 0 ? events[index - 1] : nil
//
//            // Calculate the duration of the current event
//            let duration = currentEvent.ekEvent.endDate.timeIntervalSince(currentEvent.ekEvent.startDate)
//
//            // Calculate the expected start time of the current event based on the end time of the previous event
//            let expectedStartTime = previousEvent?.ekEvent.endDate ?? currentEvent.ekEvent.startDate
//
//            // Check if the current event's start time is not equal to the expected start time
//            if currentEvent.ekEvent.startDate != expectedStartTime {
//                // Prompt the user for confirmation to reschedule the event
//                let alert = UIAlertController(title: "Reschedule Event", message: "Do you want to reschedule \(currentEvent.ekEvent.title ?? "this event")?", preferredStyle: .alert)
//
//                alert.addAction(UIAlertAction(title: "Reschedule", style: .default, handler: { [self] _ in
//                    // If the user confirms, adjust the start time while maintaining the duration
//                    currentEvent.ekEvent.startDate = expectedStartTime! + 1
//                    currentEvent.ekEvent.endDate = expectedStartTime!.addingTimeInterval(duration)
//
//                    // Save the changes to the event store
//                    do {
//                        try eventStore.save(currentEvent.ekEvent, span: .thisEvent)
//                    } catch {
//                        print("Failed to save event changes:", error)
//                    }
//
//                    // Proceed to the next event
//                    scheduleEventAtIndex(index + 1)
//                }))
//
//                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
//                    // If the user cancels, proceed to the next event
//                    scheduleEventAtIndex(index + 1)
//                }))
//
//                // Present the alert
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                // If no rescheduling is needed, proceed to the next event
//                scheduleEventAtIndex(index + 1)
//            }
//        }
//
//        // Start scheduling from the first event
//        scheduleEventAtIndex(0)
//    }











    @objc func addNewEvent() {
        // Get the current date
        let currentDate = Date()
        
        // Call the method to create a new event at the current date
        let newEvent = createNewEvent(at: currentDate)
        
        // Present an EKEventEditViewController to allow editing or canceling the event
        presentEditingViewForEvent(newEvent.ekEvent)
    }

//    func showSimpleAlert(with steps: Double) {
//        if steps < 10000 {
//            let remainingSteps = max(0, 10000 - steps)
//            let alert = UIAlertController(title: "Would you like to add a new health event?", message: "You've done \(String(format: "%.0f", steps)) steps", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
//                print("canceled")
//            }))
//            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { [weak self] _ in
//                print("agreed")
//                self?.createHealthEvent(with: remainingSteps)
//            }))
//            self.present(alert, animated: true)
//        } else {
//            let alert = UIAlertController(title: "Good Job!", message: "You've completed 10000 or more steps today!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                print("Good Job acknowledged")
//            }))
//            self.present(alert, animated: true)
//        }
//        print("yippie")
//    }
    
    
//    func createHealthEvent(with remainingSteps: Double) {
//        let newEvent = EKEvent(eventStore: eventStore)
//        newEvent.title = "Complete the remaining \(String(format: "%.0f", remainingSteps)) steps today"
//        newEvent.startDate = Date()
//        newEvent.endDate = Date().addingTimeInterval(3600) // 1 hour duration
//        newEvent.calendar = eventStore.defaultCalendarForNewEvents
//
//        do {
//            try eventStore.save(newEvent, span: .thisEvent)
//            let alert = UIAlertController(title: "Event Created", message: "Your health event has been added to the calendar.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(alert, animated: true)
//        } catch {
//            let alert = UIAlertController(title: "Error", message: "Failed to create event.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(alert, animated: true)
//        }
//    }

    func createHealthEvent(with activityTitle: String, startTime: Date? = nil) {
        let newEvent = EKEvent(eventStore: eventStore)
        newEvent.title = activityTitle
        if let startTime = startTime {
            newEvent.startDate = startTime
        } else {
            newEvent.startDate = Date()
        }
        newEvent.endDate = newEvent.startDate.addingTimeInterval(3600) // 1 hour duration
        newEvent.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(newEvent, span: .thisEvent)
            let alert = UIAlertController(title: "Event Created", message: "Your health event has been added to the calendar.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        } catch {
            let alert = UIAlertController(title: "Error", message: "Failed to create event.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

//    func createHealthEvent(with title: String, startTime: Date? = nil) -> EKWrapper {
//        let newEvent = EKEvent(eventStore: eventStore)
//        newEvent.title = title
//        if let startTime = startTime {
//            newEvent.startDate = startTime
//        } else {
//            newEvent.startDate = Date()
//        }
//        newEvent.endDate = newEvent.startDate.addingTimeInterval(3600) // 1 hour duration
//        newEvent.calendar = eventStore.defaultCalendarForNewEvents
//
//        do {
//            try eventStore.save(newEvent, span: .thisEvent)
//            let alert = UIAlertController(title: "Event Created", message: "Your health event has been added to the calendar.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(alert, animated: true)
//        } catch {
//            let alert = UIAlertController(title: "Error", message: "Failed to create event.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(alert, animated: true)
//        }
//
//        return EKWrapper(eventKitEvent: newEvent)
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Need to set toolbar hidden, as it might be displayed in black due to EventKitUI / EditingViewController setting it
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    private func requestAccessToCalendar() {
        // Code to handle the response to the request.
        // We create the completion handler first, as we need to ask for a permission differently in iOS 17
        let completionHandler: EKEventStoreRequestAccessCompletionHandler =  { [weak self] granted, error in
            // Looks like starting iOS 17 completion handler is not executed on the main thread by default.
            // iOS 17 error?
            DispatchQueue.main.async {
                guard let self else { return }
                self.initializeStore()
                self.subscribeToNotifications()
                self.reloadData()
            }
        }
        
        // Request access to the events
//         More info: https://developer.apple.com/documentation/technotes/tn3152-migrating-to-the-latest-calendar-access-levels
        if #available(iOS 17.0, *) {
//                        eventStore.requestFullAccessToEvents(completion: completionHandler)
        } else {
            eventStore.requestAccess(to: .event, completion: completionHandler)
        }
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storeChanged(_:)),
                                               name: .EKEventStoreChanged,
                                               object: eventStore)
    }
    
    private func initializeStore() {
        eventStore = EKEventStore()
    }
    
    @objc private func storeChanged(_ notification: Notification) {
        reloadData()
    }
    
    // MARK: - DayViewDataSource
    
    // This is the `DayViewDataSource` method that the client app has to implement in order to display events with CalendarKit
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        // The `date` always has it's Time components set to 00:00:00 of the day requested
        let startDate = date
        var oneDayComponents = DateComponents()
        oneDayComponents.day = 1
        // By adding one full `day` to the `startDate`, we're getting to the 00:00:00 of the *next* day
        let endDate = calendar.date(byAdding: oneDayComponents, to: startDate)!
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, // Start of the current day
                                                      end: endDate, // Start of the next day
                                                      calendars: nil) // Search in all calendars
        
        let eventKitEvents = eventStore.events(matching: predicate) // All events happening on a given day
        let calendarKitEvents = eventKitEvents.map(EKWrapper.init)
        
        return calendarKitEvents
    }
    
    // MARK: - DayViewDelegate
    
    // MARK: Event Selection
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let ckEvent = eventView.descriptor as? EKWrapper else {
            return
        }
        presentDetailViewForEvent(ckEvent.ekEvent)
    }
    
    private func presentDetailViewForEvent(_ ekEvent: EKEvent) {
        let eventController = EKEventViewController()
        eventController.event = ekEvent
        eventController.allowsCalendarPreview = true
        eventController.allowsEditing = true
        navigationController?.pushViewController(eventController,
                                                 animated: true)
    }
    
    // MARK: Event Editing
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        // Cancel editing current event and start creating a new one
        endEventEditing()
        let newEKWrapper = createNewEvent(at: date)
        create(event: newEKWrapper, animated: true)
    }
    
    private func createNewEvent(at date: Date) -> EKWrapper {
        let newEKEvent = EKEvent(eventStore: eventStore)
        newEKEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        var components = DateComponents()
        components.hour = 1
        let endDate = calendar.date(byAdding: components, to: date)
        
        newEKEvent.startDate = date
        newEKEvent.endDate = endDate
        newEKEvent.title = "New event"
        
        let newEKWrapper = EKWrapper(eventKitEvent: newEKEvent)
        newEKWrapper.editedEvent = newEKWrapper
        return newEKWrapper
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? EKWrapper else {
            return
        }
        
        // Reset the progress view
        
        // Toggle the presence of the check mark emoji in the event title
        if descriptor.ekEvent.title?.contains("✅") ?? false {
            // If the title contains the check mark emoji, remove it
            descriptor.ekEvent.title = descriptor.ekEvent.title?.replacingOccurrences(of: "✅", with: "").trimmingCharacters(in: .whitespaces)
        } else {
            // If the title does not contain the check mark emoji, add it
            descriptor.ekEvent.title = "✅ \(descriptor.ekEvent.title ?? "")"
        }
        
        // Create a timer with a 5-second delay
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            // Increment the progress of the progress view
            self.progressView.progress += 0.1 / 0.5
            
            // If the progress reaches 100%, stop the timer
            if self.progressView.progress >= 1.0 {
                timer.invalidate()
                progressView.progress = 0

                // Save the changes to the event
                do {
                    try self.eventStore.save(descriptor.ekEvent, span: .thisEvent)
                    self.reloadData()
                } catch {
                    print("Failed to save event changes:", error)
                }
            }
        }
        // Add the timer to the run loop
        RunLoop.current.add(timer, forMode: .common)
        
        endEventEditing()
        beginEditing(event: descriptor, animated: true)
    }




    
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        guard let editingEvent = event as? EKWrapper else { return }
        if let originalEvent = event.editedEvent {
            editingEvent.commitEditing()
            
            if originalEvent === editingEvent {
                // If editing event is the same as the original one, it has just been created.
                // Showing editing view controller
                presentEditingViewForEvent(editingEvent.ekEvent)
            } else {
                // If editing event is different from the original,
                // then it's pointing to the event already in the `eventStore`
                // Let's save changes to oriignal event to the `eventStore`
                try! eventStore.save(editingEvent.ekEvent,
                                     span: .thisEvent)
            }
        }
        reloadData()
    }
    
    
    private func presentEditingViewForEvent(_ ekEvent: EKEvent) {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.event = ekEvent
        eventEditViewController.eventStore = eventStore
        eventEditViewController.editViewDelegate = self
        present(eventEditViewController, animated: true, completion: nil)
    }
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
        endEventEditing()
    }
    
    // MARK: - EKEventEditViewDelegate
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        endEventEditing()
        reloadData()
        controller.dismiss(animated: true, completion: nil)
    }
    // MARK: - Conflicting Events
    func hasConflictingEvents(startDate: Date?, duration: TimeInterval) -> [String] {
            guard let startDate = startDate else { return [] }

            let endDate = startDate.addingTimeInterval(duration)
            let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
            
            let events = eventStore.events(matching: predicate)
            var conflictingEventNames: [String] = []

            for event in events {
                if !event.isAllDay && event.startDate < endDate && event.endDate > startDate {
                    // Add the name of the conflicting event
                    conflictingEventNames.append(event.title)
                }
            }

            // Return the array of conflicting event names
            return conflictingEventNames
        }


    func endTimeOfConflictingEvent(startDate: Date?, duration: TimeInterval) -> Date? {
        guard let startDate = startDate else { return nil }
        
        let endDate = startDate.addingTimeInterval(duration)
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        let events = eventStore.events(matching: predicate)
        var endTimeOfConflictingEvent: Date?
        
        for event in events {
            if event.startDate < endDate && event.endDate > startDate {
                if let endTime = endTimeOfConflictingEvent {
                    if event.endDate > endTime {
                        endTimeOfConflictingEvent = event.endDate
                    }
                } else {
                    endTimeOfConflictingEvent = event.endDate
                }
            }
        }
        
        return endTimeOfConflictingEvent
    }

    // MARK: - Fetching events
    private func fetchTodaysEvents() {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        var components = DateComponents()
        components.day = 1
        let endDate = calendar.date(byAdding: components, to: startDate)!

        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = eventStore.events(matching: predicate)
        self.todaysEvents = events
    }
    func fetchAllEvents() {
            let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        var components = DateComponents()
        components.day = 1 //these many days from now
        let endDate = calendar.date(byAdding: components, to: startDate)!

        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = eventStore.events(matching: predicate).sorted { $0.startDate < $1.startDate }
        self.allEvents = events

        }


}

import Foundation
import EventKit

class EventViewModel: ObservableObject {
    @Published var todaysEvents: [EKEvent] = []
    internal let eventStore = EKEventStore()
    @Published var allEvents: [EKEvent] = []
    @Published var mostFrequentEvents: [EKEvent]? // Add a property to hold most frequent events


    init() {
        requestAccessToCalendar()
    }

    private func requestAccessToCalendar() {
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            guard granted, error == nil else { return }
            DispatchQueue.main.async {
                self?.fetchTodaysEvents()
                self?.fetchAllEvents()
                self?.printMostFrequentEvent() // Call the method after fetching events
                self?.calculateMostFrequentEvents()

            }
        }
    }
    func calculateMostFrequentEvents() {
            var eventFrequency: [String: Int] = [:]

            // Calculate event frequencies
            for event in allEvents {
                let title = event.title ?? "Untitled Event"
                eventFrequency[title, default: 0] += 1
            }

            // Sort events by frequency in descending order
            let sortedEvents = eventFrequency.sorted { $0.value > $1.value }

            // Take top 5 events by frequency
            let topEvents = sortedEvents.prefix(20).map { eventFrequency in
                allEvents.first { $0.title == eventFrequency.key }
            }

            // Remove nil values from topEvents
            self.mostFrequentEvents = topEvents.compactMap { $0 }
//        if let frequentEvents = self.mostFrequentEvents {
//                    for event in frequentEvents.prefix(20) {
//                        if let eventTitle = event.title {
//                            print("\(eventTitle)")
//                        } else {
//                            print("Event title is nil for some events")
//
//
//                        }
//                    }
//                } else {
//                    print("No frequent events available")
//                }
        }

    func fetchTodaysEvents() {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        var components = DateComponents()
        components.day = 1
        let endDate = calendar.date(byAdding: components, to: startDate)!

        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = eventStore.events(matching: predicate).sorted { $0.startDate < $1.startDate }
        self.todaysEvents = events
    }
    func fetchAllEvents() {
        let calendar = Calendar.current

        // Calculate start date: 360 days ago
        var startDateComponents = DateComponents()
        startDateComponents.day = -360
        let startDate = calendar.date(byAdding: startDateComponents, to: Date())!

        // Calculate end date: 360 days from now
        var endDateComponents = DateComponents()
        endDateComponents.day = 360
        let endDate = calendar.date(byAdding: endDateComponents, to: Date())!

        // Create a predicate for the event store
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)

        // Fetch events matching the predicate
        let events = eventStore.events(matching: predicate).sorted { $0.startDate < $1.startDate }

        // Assign fetched events to your array (assuming you have a property to hold events)
        self.allEvents = events


        }
    func printMostFrequentEvent() {
//        var eventFrequency: [String: Int] = [:]
//
//        for event in allEvents {
//            let title = event.title ?? "Untitled Event"
//            eventFrequency[title, default: 0] += 1
//        }
//
//        if let mostFrequentEvent = eventFrequency.max(by: { $0.value < $1.value }) {
//            print("The most frequent event is '\(mostFrequentEvent.key)' with \(mostFrequentEvent.value) occurrences.")
//        } else {
//            print("No events found.")
//        }
        var eventFrequency: [String: Int] = [:]

                // Calculate event frequencies
                for event in allEvents {
                    let title = event.title ?? "Untitled Event"
                    eventFrequency[title, default: 0] += 1
                }

                // Sort events by frequency in descending order
                let sortedEvents = eventFrequency.sorted { $0.value > $1.value }

                // Print top 20 most frequent events
//                let topEvents = sortedEvents.prefix(20)
//                for (index, event) in topEvents.enumerated() {
//                    print("\(index + 1). '\(event.key)' - \(event.value) occurrences")
//                }

                // If there are no events, print a message
                if eventFrequency.isEmpty {
                    print("No events found.")
                }

    }

    func rescheduleEvent(event: EKEvent) {
        // Find the index of the event to be rescheduled
        guard let index = todaysEvents.firstIndex(where: { $0.eventIdentifier == event.eventIdentifier }) else {
            return
        }

        // Calculate new start time as the end time of the previous event, or current time if first event
        let newStartDate: Date
        if index > 0 {
            let previousEvent = todaysEvents[index - 1]
            newStartDate = previousEvent.endDate
        } else {
            newStartDate = Date() // Start now if it's the first event
        }

        // Calculate new end time based on the duration from the original event
        let duration = event.endDate.timeIntervalSince(event.startDate)
        let newEndDate = newStartDate.addingTimeInterval(duration)

        // Update event times
        if event.startDate != newStartDate{
            event.startDate = newStartDate + 1
            event.endDate = newStartDate.addingTimeInterval(duration)
        }

        // Save changes to the event store
        do {
            try eventStore.save(event, span: .thisEvent)
            
            // Refetch updated events from event store
            fetchTodaysEvents()
        } catch {
            print("Error saving event:", error)
        }
    }
}

