//
//  ContentView.swift
//  Poke-Test
//
//  Created by Sebastian Bonilla on 14/06/23.
//

import SDWebImageSwiftUI
import SwiftUI

struct ContentView: View {
  
  @EnvironmentObject private var model: PokemonModel
  
  var body: some View {
    NavigationStack {
      ScrollView(.horizontal) {
        
        LazyHGrid(rows: [GridItem(.adaptive(minimum: 200))], alignment: .center , spacing: 8) {
          ForEach(model.results, id: \.id) { result in
            NavigationLink(value: result) {
              VStack(spacing: 8) {
                WebImage(url: result.image)
                  .frame(width: 56, height: 56)
                  .scaledToFit()
                VStack(alignment: .leading) {
                  HStack {
                    Text(result.name)
                      .font(.headline)
                  }
                  HStack(spacing: 4) {
                    Text("Type:")
                      .font(.headline)
                    Text(result.typesString)
                      .font(.body)
                  }
                }
              }
              .padding(16)
              .overlay {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                  .stroke(.blue, lineWidth: 1)
              }
            }
          }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
      }
      .navigationDestination(for: PokemonDetail.self, destination: { pokemon in
        DetailView().environmentObject(pokemon)
      })
      .searchable(text: $model.searchText)
      .navigationTitle("Pokedex")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
