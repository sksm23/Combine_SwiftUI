//
//  Model.swift
//  Combine_SwiftUI
//
//  Created by Sunil Kumar on 01/06/23.
//

import Foundation

// MARK: - Response

struct Response: Codable, Identifiable {
  let id = UUID()
  let facilities: [Facility]
  let exclusions: [[Exclusion]]
}

// MARK: - Exclusion
struct Exclusion: Codable, Identifiable {
  let id = UUID()
  let facilityId: String
  let optionsId: String
}

// MARK: - Facility
struct Facility: Codable, Identifiable {
  let id = UUID()
  let facilityId: String
  let name: String
  var options: [Option]
}

// MARK: - Option
struct Option: Codable, Identifiable {
  let name: String
  let icon: String
  let id: String
}

struct SelectedProperty: Identifiable {
  let id = UUID()
  let facilityId: String
  let optionsId: String
}
