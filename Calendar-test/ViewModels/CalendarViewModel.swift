//  CalendarViewModel.swift
//  Calendar-test
//  Created by Анастасия Набатова on 11/12/25.

import SwiftUI
internal import Combine

final class CalendarViewModel: ObservableObject {
    @Published var currentMonth: Date = Date()
    @Published var selectedDate: Date? = nil
    @Published var workoutsByDay: [DateOnly: [WorkoutSummary]] = [:]
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private let service: MockServiceProtocol
    private let calendar = Calendar.current

    init(service: MockServiceProtocol) {
        self.service = service
        Task {
            await load()
        }
    }

    @MainActor
       private func load() async {
           let workouts = (try? await service.loadWorkouts()) ?? []
                 workoutsByDay = Dictionary(grouping: workouts) { summary in
                     DateOnly(date: summary.workoutStartDate, calendar: calendar)
                 }

                 selectedDate = Date()
       }

       func workoutsForSelectedDay() -> [WorkoutSummary] {
           guard let selectedDate else { return [] }
           return workoutsByDay[DateOnly(date: selectedDate, calendar: calendar)] ?? []
       }
    
    func goToPreviousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newDate
        }
    }

    func goToNextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    func select(date: Date) {
            Task {
                await MainActor.run {
                    isLoading = true
                }

                try? await Task.sleep(nanoseconds: 800_000_000)

                await MainActor.run {
                    selectedDate = date
                    isLoading = false
                }
            }
        }
   }


struct DateOnly: Hashable {
    let year: Int
    let month: Int
    let day: Int

    init(date: Date, calendar: Calendar) {
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        self.year = comps.year!
        self.month = comps.month!
        self.day = comps.day!
    }
}
