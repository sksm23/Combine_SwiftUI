//
//  ViewModel.swift
//  Combine_SwiftUI
//
//  Created by Sunil Kumar on 01/06/23.
//

import Foundation
import Combine
import SwiftUI

enum PropertyType: String {
  case property = "Property Type"
  case rooms = "Number of Rooms"
}

protocol ViewModelProtocol: ObservableObject {
  
  var facilities: [Facility] { get set }
  var exclusions: [[Exclusion]] { get set }
  var selectedProperties: [Option] { get set }

  func getContent()
  func updateSelection(with facility: Facility, option: Option) -> Bool
}

class ViewModel: ViewModelProtocol {
  
  private var cancellables = Set<AnyCancellable>()
  
  @Published var facilities: [Facility] = []
  @Published var exclusions: [[Exclusion]] = []
  @Published var selectedProperties: [Option] = []
  private var selectedProperty: SelectedProperty?
  
  
  // MARK: -
  func getContent() {
    
    NetworkManager.shared.getData(endpoint: .properties,
                                  type: Response.self)
    .sink { completion in
      
      switch completion {
        
      case .failure(let err):
        
        print("Error is \(err.localizedDescription)")
        
      case .finished:
        
        print("Finished")
      }
    }
  receiveValue: { [weak self] response in
    
    self?.facilities = response.facilities
    
    self?.exclusions = response.exclusions
    
  }
  .store(in: &cancellables)
  }
  
  func updateSelection(with facility: Facility, option: Option) -> Bool {
    
    let property = SelectedProperty(facilityId: facility.facilityId, optionsId: option.id)
    
    var facility = facility
    facility.options = [option]
    
    if PropertyType(rawValue: facility.name) != nil,
        selectedProperties.isEmpty{
      selectedProperty = property
    }
    else if selectedProperties.count > 1 {
      selectedProperty = property
    }
    
    for exclusion in exclusions {
      let combination1 = exclusion[0]
      let combination2 = exclusion[1]
      if selectedProperty?.facilityId == combination1.facilityId &&
          selectedProperty?.optionsId == combination1.optionsId &&
          facility.facilityId == combination2.facilityId &&
          option.id == combination2.optionsId {
        return false
      }
      else if !selectedProperties.contains(where: { $0.id == option.id } ) {
        selectedProperties.append(option)
        return true
      }
    }
    
    return true
  }
}
