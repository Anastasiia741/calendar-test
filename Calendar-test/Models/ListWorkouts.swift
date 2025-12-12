//  WorkoutSummary.swift
//  Calendar-test
//  Created by Анастасия Набатова on 11/12/25.

import Foundation

enum WorkoutActivityType: String, Codable, CaseIterable {
    case walkingRunning = "Walking/Running"
    case yoga = "Yoga"
    case water = "Water"
    case cycling = "Cycling"
    case strength = "Strength"

    var displayName: String {
        switch self {
        case .walkingRunning: return "Бег/ходьба"
        case .yoga: return "Йога"
        case .water: return "Водные"
        case .cycling: return "Велоспорт"
        case .strength: return "Силовые"
        }
    }
}

struct WorkoutSummary: Identifiable, Codable {
    let workoutKey: String
    let workoutActivityType: WorkoutActivityType
    let workoutStartDate: Date
    var id: String { workoutKey }
}

struct ListWorkout: Identifiable {
    let workoutKey: String
    let workoutActivityType: WorkoutActivityType
    let workoutStartDate: Date
    let distance: Double
    let duration: Double
    let comment: String?

    var id: String { workoutKey }
}

struct MetadataFile: Codable {
    let description: String
    let workouts: [String: WorkoutMetadataRaw]
}

struct WorkoutMetadataRaw: Codable {
    let workoutKey: String
    let workoutActivityType: WorkoutActivityType
    let workoutStartDate: Date

    let distance: String
    let duration: String

    let comment: String?

    func toDomain() -> ListWorkout {
        let distanceValue = Double(distance) ?? 0
        let durationValue = Double(duration) ?? 0

        return ListWorkout(
            workoutKey: workoutKey,
            workoutActivityType: workoutActivityType,
            workoutStartDate: workoutStartDate,
            distance: distanceValue,
            duration: durationValue,
            comment: comment
        )
    }
}

struct DiagramPoint: Identifiable, Equatable {
    let id = UUID()

    let timeNumeric: Double
    let heartRate: Double
    let speedKmh: Double
}
