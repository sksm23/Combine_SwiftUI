//
//  ContentDetailsView.swift
//  Combine_SwiftUI
//
//  Created by Sunil Kumar on 01/06/23.
//

import SwiftUI

struct ContentDetailsView: View {
  
  let selectedProperties: [Option]
  
    var body: some View {
      List(selectedProperties) { option in
                  
          HStack {
            Image(option.icon)
            
            Text(option.name)
          }
      }
    }
}

struct ContentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
      ContentDetailsView(selectedProperties: [])
    }
}
