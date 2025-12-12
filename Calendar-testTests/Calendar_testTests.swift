//  Calendar_testTests.swift
//  Calendar-testTests
//  Created by Анастасия Набатова on 12/12/25.

import XCTest

@testable import Calendar_test

final class Calendar_testTests: XCTestCase {
    let workouts: [WorkoutSummary] = []

    @MainActor
    func test_workoutsForSelectedDay_filtersOnlySameDay() async {
        let calendar = Calendar.current

        let d1 = makeDate(2025, 12, 10, 8, 0)
        let d1b = makeDate(2025, 12, 10, 18, 0)
        let d2 = makeDate(2025, 12, 11, 9, 0)
        let w1 = WorkoutSummary(
            workoutKey: "1",
            workoutActivityType: .walkingRunning,
            workoutStartDate: d1
        )
        let w2 = WorkoutSummary(
            workoutKey: "2",
            workoutActivityType: .yoga,
            workoutStartDate: d1b
        )
        let w3 = WorkoutSummary(
            workoutKey: "3",
            workoutActivityType: .cycling,
            workoutStartDate: d2
        )
        let vm = CalendarViewModel(service: MockService())

        await Task.yield()

        vm.workoutsByDay = [DateOnly(date: d1, calendar: calendar): [ w1, w2, ],
                            DateOnly(date: d2, calendar: calendar): [w3],]
        vm.selectedDate = d1

        let result = vm.workoutsForSelectedDay()
        XCTAssertEqual(result.map(\.workoutKey),["1", "2",])
    }

    @MainActor
    func test_goToNextMonth_changesMonth() async {
        let vm = CalendarViewModel(service: MockService())
        await Task.yield()

        vm.currentMonth = makeDate(2025, 12, 15, 12, 0)
        vm.goToNextMonth()

        let comps = Calendar.current.dateComponents([.year, .month,], from: vm.currentMonth)
        XCTAssertEqual(comps.year, 2026)
        XCTAssertEqual(comps.month, 1)
    }

    func test_dateFormatting() {
        let date = makeDate(2025, 12, 5, 14, 7)

        XCTAssertEqual(date.timeHHmm, "14:07")
        XCTAssertEqual(date.monthTitleRU, "Декабрь 2025")
        XCTAssertEqual(date.dateTimeRU, "5 декабря 2025, 14:07")
    }

    private func makeDate(_ y: Int, _ m: Int, _ d: Int, _ hh: Int, _ mm: Int) -> Date {
        var c = DateComponents()
        c.calendar = Calendar(identifier: .gregorian)
        c.year = y
        c.month = m
        c.day = d
        c.hour = hh
        c.minute = mm
        return c.date!
    }

}

final class MockService: MockServiceProtocol {

    private let workouts: [WorkoutSummary]

    init(workouts: [WorkoutSummary] = []) {
        self.workouts = workouts
    }

    func loadWorkouts() async throws -> [WorkoutSummary] { workouts }

    func loadDetails(for workoutId: String) async throws -> WorkoutDetails? { nil }

    func loadDiagram( for workoutId: String) async throws -> [DiagramPoint] { [] }
}
