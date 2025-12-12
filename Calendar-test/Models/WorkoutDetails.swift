//  WorkoutMetadata.swift
//  Calendar-test
//  Created by Анастасия Набатова on 11/12/25.

import Foundation

struct WorkoutDetails: Identifiable {
    let workoutKey: String
    let workoutActivityType: WorkoutActivityType
    let workoutStartDate: Date
    let distance: Double
    let duration: Double
    let comment: String?
    var id: String { workoutKey }
}
