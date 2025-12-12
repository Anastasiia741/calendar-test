//  WorkoutMockService.swift
//  Calendar-test
//  Created by Анастасия Набатова on 11/12/25.

import Foundation

protocol MockServiceProtocol {
    func loadWorkouts() async throws -> [WorkoutSummary]
    func loadDetails(for workoutId: String) async throws -> WorkoutDetails?
    func loadDiagram(for workoutId: String) async throws -> [DiagramPoint]
}

final class MockAPIService: MockServiceProtocol {

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        d.dateDecodingStrategy = .formatted(formatter)
        return d
    }()

    func loadWorkouts() async throws -> [WorkoutSummary] {
        struct ListWorkoutsFile: Codable {
            let description: String
            let data: [WorkoutSummary]
        }

        let file: ListWorkoutsFile = try await load("list_workouts.json")
        return file.data
    }

    func loadDetails(for workoutId: String) async throws -> WorkoutDetails? {
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

            func toDomain() -> WorkoutDetails {
                WorkoutDetails(
                    workoutKey: workoutKey,
                    workoutActivityType: workoutActivityType,
                    workoutStartDate: workoutStartDate,
                    distance: Double(distance) ?? 0,
                    duration: Double(duration) ?? 0,
                    comment: comment
                )
            }
        }

        let file: MetadataFile = try await load("metadata.json")
        return file.workouts[workoutId]?.toDomain()
    }

    func loadDiagram(for workoutId: String) async throws -> [DiagramPoint] {
        struct DiagramDataFile: Codable {
            let description: String
            let workouts: [String: DiagramWorkoutRaw]
        }

        struct DiagramWorkoutRaw: Codable {
            let description: String
            let data: [DiagramPointRaw]
            let states: [DiagramStateRaw]
        }

        struct DiagramPointRaw: Codable {
            let time_numeric: Double
            let heartRate: Int
            let speed_kmh: Double

            func toDomain() -> DiagramPoint {
                DiagramPoint(
                    timeNumeric: time_numeric,
                    heartRate: Double(heartRate),
                    speedKmh: speed_kmh
                )
            }
        }

        struct DiagramStateRaw: Codable {}

        let file: DiagramDataFile = try await load("diagram_data.json")
        guard let workout = file.workouts[workoutId] else { return [] }
        return workout.data.map { $0.toDomain() }
    }

    private func load<T: Decodable>(_ fileName: String) async throws -> T {
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: nil)
        else {
            throw ServiceError.fileNotFound(fileName)
        }
        let data = try Data(contentsOf: url)
        return try decoder.decode(T.self, from: data)
    }

    enum ServiceError: Error {
        case fileNotFound(String)
    }
}
