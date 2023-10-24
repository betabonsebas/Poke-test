//
//  DetailView.swift
//  Poke-Test
//
//  Created by Sebastian Bonilla on 22/10/23.
//

import SDWebImageSwiftUI
import SwiftUI

struct DetailView: View {
  @EnvironmentObject private var model: PokemonDetail
  @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
  
  var body: some View {
    Group {
      if orientation.isPortrait {
        ScrollView {
          VStack(alignment: .leading) {
            WebImage(url: model.image)
              .resizable()
              .scaledToFit()
              .clipped()
            HStack (spacing: 4) {
              Text("Type:")
                .font(.headline)
              Text(model.typesString)
                .font(.body)
            }
            HStack(spacing: 4) {
              Text("Abilities:")
                .font(.headline)
              Text(model.abilitiesString)
                .font(.body)
            }
            HStack(alignment: .top, spacing: 4){
              Text("Moves:")
                .font(.headline)
              Text(model.movesString)
                .font(.body)
            }
          }
        }
      } else {
        HStack {
          WebImage(url: model.image)
            .resizable()
            .scaledToFit()
            .clipped()
          ScrollView {
            VStack(alignment: .leading) {
              HStack (spacing: 4) {
                Text("Type:")
                  .font(.headline)
                Text(model.typesString)
                  .font(.body)
              }
              HStack(spacing: 4) {
                Text("Abilities:")
                  .font(.headline)
                Text(model.abilitiesString)
                  .font(.body)
              }
              HStack(alignment: .top, spacing: 4){
                Text("Moves:")
                  .font(.headline)
                Text(model.movesString)
                  .font(.body)
              }
            }
          }
        }
      }
    }
    .navigationTitle(model.name)
    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { output in
      orientation = UIDevice.current.orientation
    }
  }
}
