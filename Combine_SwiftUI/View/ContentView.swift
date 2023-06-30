//
//  ContentView.swift
//  Combine_SwiftUI
//
//  Created by Sunil Kumar on 01/06/23.
//

import SwiftUI

struct ContentView<VM: ViewModel>: View {
  
  @ObservedObject var viewModel: VM
  
  var body: some View {
    NavigationView {
      VStack {
        List(viewModel.facilities) { facility in
          Section(header: Text(facility.name)) {
            ForEach(facility.options) { option in
              HStack {
                Image(option.icon)
                Button {
                  if viewModel.updateSelection(with: facility, option: option) {
                    print("Selected: \(option.name) for property \(facility.name)")
                  }
                  else {
                    print("Cannot select \(option.name) for property \(facility.name)")
                  }
                } label: {
                  //let type = SelectionType(rawValue: facility.name) ?? .none
                  Text(option.name)
                   // .foregroundColor(viewModel.selectedOptions[type]?.name == facility.name ? .black : .green)
                }
              }
            }
          }
        }
        
        Spacer()
        
        NavigationLink {
          ContentDetailsView(selectedProperties: viewModel.selectedProperties)
        } label: {
          Text("Continue")
        }
        .navigationTitle("Properties")
      }
    }
    .onAppear {
      viewModel.getContent()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(viewModel: ViewModel())
  }
}
