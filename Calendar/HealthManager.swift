//
//  HealthManager.swift
//  Calendar
//
//  Created by Farih Muhammad on 19/05/2024.
//

//import Foundation
//import HealthKit
//
//extension Date {
//    static var startOfDay: Date {
//        Calendar.current.startOfDay(for: Date())
//    }
//}
//
//@available(iOS 15.0, *)
//class HealthManager {
//    let healthStore = HKHealthStore()
//    var stepsToday: Double = 0.0
//
//    init() {
//        requestAuthorization()
//    }
//
//    private func requestAuthorization() {
//        let steps = HKQuantityType(.stepCount)
//        let healthTypes: Set = [steps]
//
//        Task {
//            do {
//                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
//                print("Authorization successful")
//            } catch {
//                print("Error fetching health data: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func fetchTodaySteps(completion: @escaping (Double) -> Void) {
//        let steps = HKQuantityType(.stepCount)
//        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
//        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
//            if let error = error {
//                print("Error fetching today's step data: \(error.localizedDescription)")
//                return
//            }
//            guard let quantity = result?.sumQuantity() else {
//                print("No step data available")
//                return
//            }
//            let stepCount = quantity.doubleValue(for: .count())
//            DispatchQueue.main.async {
//                self.stepsToday = stepCount
//                print("Steps today: \(stepCount)")
//                completion(stepCount)  // Call the completion handler with the step count
//            }
//        }
//        healthStore.execute(query)
//        print("Query executed")
//    }
//}

//import Foundation
//import HealthKit
//import Observation
//
//enum HealthError: Error {
//    case healthDataNotAvailable
//}
//
//@Observable
//class HealthStore {
//
//    var steps: [Step] = []
//    var healthStore: HKHealthStore?
//    var lastError: Error?
//
//    init() {
//        if HKHealthStore.isHealthDataAvailable() {
//            healthStore = HKHealthStore()
//        } else {
//            lastError = HealthError.healthDataNotAvailable
//        }
//    }
//
//    func calculateSteps() async throws {
//
//        guard let healthStore = self.healthStore else { return }
//
//        let calendar = Calendar(identifier: .gregorian)
//        let startDate = calendar.date(byAdding: .day, value: -7, to: Date())
//        let endDate = Date()
//
//        let stepType = HKQuantityType(.stepCount)
//        let everyDay = DateComponents(day:1)
//        let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
//        let stepsThisWeek = HKSamplePredicate.quantitySample(type: stepType, predicate:thisWeek)
//
//        let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: stepsThisWeek, options: .cumulativeSum, anchorDate: endDate, intervalComponents: everyDay)
//
//        let stepsCount = try await sumOfStepsQuery.result(for: healthStore)
//
//        guard let startDate = startDate else { return }
//
//        stepsCount.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
//            let count = statistics.sumQuantity()?.doubleValue(for: .count())
//            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
//            if step.count > 0 {
//                // add the step in steps collection
//                self.steps.append(step)
//            }
//        }
//
//    }
//
//    func requestAuthorization() async {
//
//        guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else { return }
//        guard let healthStore = self.healthStore else { return }
//
//        do {
//            try await healthStore.requestAuthorization(toShare: [], read: [stepType])
//        } catch {
//            lastError = error
//        }
//
//    }
//
//}

//import Foundation
//import HealthKit
//
//extension Date {
//    static var startOfDay: Date {
//        Calendar.current.startOfDay(for: Date())
//    }
//}

//@available(iOS 15.4, *)
//class HealthManager: ObservableObject {
//    let healthStore = HKHealthStore()
//    var stepsToday: Double = 0.0
//    var steps: [Step] = []
//    var lastError: Error?
//
//    init() {
//        if HKHealthStore.isHealthDataAvailable() {
//            requestAuthorization()
//        } else {
//            lastError = HealthError.healthDataNotAvailable
//        }
//    }
//
//    private func requestAuthorization() {
//        let steps = HKQuantityType(.stepCount)
//        let healthTypes: Set = [steps]
//
//        Task {
//            do {
//                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
//                print("Authorization successful")
//            } catch {
//                print("Error fetching health data: \(error.localizedDescription)")
//                lastError = error
//            }
//        }
//    }
//
//    func fetchTodaySteps(completion: @escaping (Double) -> Void) {
//        let steps = HKQuantityType(.stepCount)
//        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
//        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
//            if let error = error {
//                print("Error fetching today's step data: \(error.localizedDescription)")
//                return
//            }
//            guard let quantity = result?.sumQuantity() else {
//                print("No step data available")
//                return
//            }
//            let stepCount = quantity.doubleValue(for: .count())
//            DispatchQueue.main.async {
//                self.stepsToday = stepCount
//                print("Steps today: \(stepCount)")
//                completion(stepCount)  // Call the completion handler with the step count
//            }
//        }
//        healthStore.execute(query)
//        print("Query executed")
//    }
//
//    func calculateSteps() async {
//            guard let healthStore = HKHealthStore.isHealthDataAvailable() ? self.healthStore : nil else {
//                lastError = HealthError.healthDataNotAvailable
//                return
//            }
//
//            let calendar = Calendar(identifier: .gregorian)
//            let startDate = calendar.date(byAdding: .day, value: -7, to: Date())!
//            let endDate = Date()
//
//            let stepType = HKQuantityType(.stepCount)
//            let everyDay = DateComponents(day: 1)
//            let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
//            let stepsThisWeek = HKSamplePredicate.quantitySample(type: stepType, predicate: thisWeek)
//
//            let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: stepsThisWeek, options: .cumulativeSum, anchorDate: endDate, intervalComponents: everyDay)
//
//            let stepsCount = try? await sumOfStepsQuery.result(for: healthStore)
//
//            stepsCount?.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
//                let count = statistics.sumQuantity()?.doubleValue(for: .count())
//                let step = Step(count: Int(count ?? 0), date: statistics.startDate)
//                if step.count > 0 {
//                    self.steps.append(step)
//                }
//            }
//        }
//}
//
//struct Step: Identifiable {
//    let id = UUID()
//    let count: Int
//    let date: Date
//}
//
//enum HealthError: Error {
//    case healthDataNotAvailable
//}

//import Foundation
//import HealthKit
//
//
//enum HealthError: Error {
//    case healthDataNotAvailable
//}
//
//@available(iOS 16.0, *)
//class HealthManager: ObservableObject {
//    let healthStore = HKHealthStore()
//    @Published var stepsToday: Double = 0.0
//    @Published var steps: [Step] = []
//    var lastError: Error?
//
//    init() {
//        requestAuthorization()
//    }
//
//    private func requestAuthorization() {
//        let steps = HKQuantityType(.stepCount)
//        let healthTypes: Set = [steps]
//
//        Task {
//            do {
//                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
//                print("Authorization successful")
//                await calculateSteps()
//            } catch {
//                print("Error fetching health data: \(error.localizedDescription)")
//                lastError = error
//            }
//        }
//    }
//
//    func fetchTodaySteps(completion: @escaping (Double) -> Void) {
//        let steps = HKQuantityType(.stepCount)
//        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
//        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
//            if let error = error {
//                print("Error fetching today's step data: \(error.localizedDescription)")
//                return
//            }
//            guard let quantity = result?.sumQuantity() else {
//                print("No step data available")
//                return
//            }
//            let stepCount = quantity.doubleValue(for: .count())
//            DispatchQueue.main.async {
//                self.stepsToday = stepCount
//                print("Steps today: \(stepCount)")
//                completion(stepCount)
//            }
//        }
//        healthStore.execute(query)
//        print("Query executed")
//    }
//
//    func calculateSteps() async {
//        guard let healthStore = HKHealthStore.isHealthDataAvailable() ? self.healthStore : nil else {
//            lastError = HealthError.healthDataNotAvailable
//            return
//        }
//
//        let calendar = Calendar(identifier: .gregorian)
//        let startDate = calendar.date(byAdding: .day, value: -7, to: Date())!
//        let endDate = Date()
//
//        let stepType = HKQuantityType(.stepCount)
//        let everyDay = DateComponents(day: 1)
//        let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
//        let stepsThisWeek = HKSamplePredicate.quantitySample(type: stepType, predicate: thisWeek)
//
//        let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: stepsThisWeek, options: .cumulativeSum, anchorDate: endDate, intervalComponents: everyDay)
//
//        let stepsCount = try? await sumOfStepsQuery.result(for: healthStore)
//
//        stepsCount?.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
//            let count = statistics.sumQuantity()?.doubleValue(for: .count())
//            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
//            if step.count > 0 {
//                self.steps.append(step)
//            }
//        }
//    }
//}
//
//struct Step: Identifiable {
//    let id = UUID()
//    let count: Int
//    let date: Date
//}

import Foundation
import HealthKit

enum HealthError: Error {
    case healthDataNotAvailable
}
extension Date{
    static var startOfDay: Date{
        Calendar.current.startOfDay(for: Date())
    }
    static var startOfWeek: Date{
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear,.weekOfYear], from: Date())
        components.weekday = 2
        return calendar.date(from: components)!
    }
    func startOfDay() -> Date {
            return Calendar.current.startOfDay(for: self)
        }

        func endOfDay() -> Date {
            return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
        }

}

extension Double{
    func formattedString()->String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}


class HealthManager: ObservableObject {
    let healthStoreNEW = HKHealthStore()
    @Published var activities: [String:Actvity] = [:]
    @Published var healthStore: HKHealthStore?
    @Published var lastError: Error?
    @Published var steps: [Step] = []

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            lastError = HealthError.healthDataNotAvailable
        }
        let healthTypes: Set<HKObjectType> = [
                    HKObjectType.quantityType(forIdentifier: .stepCount)!,
                    HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                    HKObjectType.workoutType(),
                    HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
                    HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
                    HKQuantityType(.flightsClimbed)
                ]
//        self.activities["todayFlightsClimbed"] = Actvity(id: 5, title: "Flights Climbed", subtitle: "Today", image: "figure.step.training", ammount: 0.formattedString())
//        self.activities["timeAsleep"] = Actvity(id: 2, title: "Time Asleep", subtitle: "Today", image: "moon.stars", ammount: "\(0.formattedString()) hours")
//        self.activities["todaySteps"] = Actvity(id: 0, title: "Steps", subtitle: "Today", image: "figure.walk", ammount: 0.formattedString())
//        self.activities["todayCalories"] = Actvity(id: 1, title: "Active Calories", subtitle: "", image: "flame", ammount: 0.formattedString())
//        self.activities["weekRunning"] = Actvity(id: 4, title: "Running", subtitle: "Weekly", image: "figure.run", ammount: "\(0) min")
//        self.activities["restingHeartRate"] = Actvity(id: 3, title: "Resting Heart Rate", subtitle: "", image: "heart.fill", ammount: "\(0.formattedString()) BPM")

//        let steps = HKQuantityType(.stepCount)
//        let calories = HKQuantityType(.activeEnergyBurned)
//        let workout = HKObjectType.workoutType()
//        let heartRate = HKQuantityType(.restingHeartRate)
//        let timeAsleep = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
//        let healthTypes: Set = [steps, calories, workout, heartRate, timeAsleep]

        Task{
            do{
                try await healthStoreNEW.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                fetchWeeklyRunningStats()
                fetchRestingHeartRate()
                fetchDailySteps()
                fetchTimeAsleep()
                fetchTodayFlightsClimbed()
            }catch{
                print("error fetching health data")
            }
        }

    }
    func fetchTodayFlightsClimbed() {
        let flightsClimbedType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: flightsClimbedType, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching flights climbed data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let flightsClimbedCount = quantity.doubleValue(for: HKUnit.count())
            DispatchQueue.main.async {
                // Optionally, you can update some UI or store this data as needed
                let activity = Actvity(id: 5, title: "Flights Climbed", subtitle: "Today", image: "figure.walk", ammount: flightsClimbedCount.formattedString())
                self.activities["todayFlightsClimbed"] = activity
//                print("Updated todayFlightsClimbed: \(activity)")

            }
        }
        healthStore!.execute(query)
    }


    func fetchTimeAsleep() {
            let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
            let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date(), options: .strictEndDate)
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
                guard let samples = samples as? [HKCategorySample], error == nil else {
                    print("Error fetching sleep analysis data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                var totalTimeAsleep: TimeInterval = 0

                for sample in samples {
                    if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                        totalTimeAsleep += sample.endDate.timeIntervalSince(sample.startDate)
                    }
                }

                // Convert totalTimeAsleep to hours
                let hours = totalTimeAsleep / 3600

                let activity = Actvity(id: 2, title: "Time Asleep", subtitle: "Today", image: "moon.stars", ammount: "\(hours.formattedString()) hours")
                DispatchQueue.main.async {
                    self.activities["timeAsleep"] = activity
//                    print("Updated timeAsleep: \(activity)")

                }
            }
        healthStoreNEW.execute(query)
        }
    func fetchDailySteps() {
            let steps = HKQuantityType(.stepCount)
            let calendar = Calendar.current
            let startDate = calendar.date(byAdding: .day, value: -7, to: Date().startOfDay())!
            let endDate = Date()

            var interval = DateComponents()
            interval.day = 1

            let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: startDate, intervalComponents: interval)

            query.initialResultsHandler = { query, result, error in
                guard let result = result else {
                    print("error fetching daily steps: \(String(describing: error))")
                    return
                }

                DispatchQueue.main.async {
                    self.steps.removeAll()

                    result.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                        let count = statistics.sumQuantity()?.doubleValue(for: .count())
                        let step = Step(count: Int(count ?? 0), date: statistics.startDate)
                        if step.count > 0 {
                            self.steps.append(step)
                        }
                    }
                }
            }
            healthStoreNEW.execute(query)
        }
    func fetchTodaySteps(){
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching todays step data")
                return
            }
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Actvity(id: 0, title: "Steps", subtitle: "Today", image: "figure.walk", ammount: stepCount.formattedString())
            DispatchQueue.main.async {
                self.activities["todaySteps"] = activity
//                print("Updated todaySteps: \(activity)")

            }
            
        }
        healthStoreNEW.execute(query)
    }
    func fetchTodayCalories(){
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching todays calorie data")
                return
            }
            let calorieBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = Actvity(id: 1, title: "Active Calories", subtitle: "", image: "flame", ammount: calorieBurned.formattedString())
            DispatchQueue.main.async {
                self.activities["todayCalories"] = activity
//                print("Updated todayCalories: \(activity)")

            }
        }
        healthStoreNEW.execute(query)
    }
    func fetchWeeklyRunningStats(){
        let workout =  HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate,workoutPredicate])
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 25, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("error fetching todays calorie data")
                return
            }
            var count:Int = 0
            for workout in workouts{
                let duration = Int(workout.duration)/60
                count+=duration
            }
            let activity = Actvity(id: 4, title: "Weekly Running", subtitle: "Weekly", image: "figure.run", ammount: "\(count) min")
            DispatchQueue.main.async {
                self.activities["weekRunning"] = activity
//                print("Updated weekRunning: \(activity)")

            }

        }
        healthStoreNEW.execute(query)
    }
    func fetchRestingHeartRate() {
        let heartRate = HKQuantityType(.restingHeartRate)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: heartRate, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, error in
            guard let quantity = result?.averageQuantity(), error == nil else {
                print("error fetching resting heart rate data")
                return
            }
            let heartRateValue = quantity.doubleValue(for: HKUnit(from: "count/min"))
            let activity = Actvity(id: 3, title: "Resting Heart Rate", subtitle: "", image: "heart.fill", ammount: "\(heartRateValue.formattedString()) BPM")
            DispatchQueue.main.async {
                self.activities["restingHeartRate"] = activity
//                print("Updated restingHeartRate: \(activity)")

            }
        }
        healthStoreNEW.execute(query)
    }


//    func calculateSteps() async throws {
//        guard let healthStore = self.healthStore else { return }
//        let calendar = Calendar(identifier: .gregorian)
//        let startDate = calendar.date(byAdding: .day, value: -7, to: Date())
//        let endDate = Date()
//
//        let stepType = HKQuantityType(.stepCount)
//        let everyDay = DateComponents(day: 1)
//        let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
//        let stepsThisWeek = HKSamplePredicate.quantitySample(type: stepType, predicate: thisWeek)
//
//        let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: stepsThisWeek, options: .cumulativeSum, anchorDate: endDate, intervalComponents: everyDay)
//
//        let stepsCount = try await sumOfStepsQuery.result(for: healthStore)
//
//        guard let startDate = startDate else { return }
//
//        // Clear the steps array before fetching new steps
//        DispatchQueue.main.async {
//            self.steps.removeAll()
//        }
//
//        stepsCount.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
//            let count = statistics.sumQuantity()?.doubleValue(for: .count())
//            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
//            DispatchQueue.main.async {
//                if step.count > 0 {
//                    self.steps.append(step)
//                }
//            }
//        }
//    }

    func requestAuthorization() async {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        guard let healthStore = self.healthStore else { return }
        do {
            try await healthStore.requestAuthorization(toShare: [], read: [stepType])
        } catch {
            lastError = error
        }
    }
}

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}

