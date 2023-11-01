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
      ScrollView(.vertical) {
        Text("Use the advanced search to find Pokémon by type, weakness, ability and more!")
          .font(.subheadline)
          .lineLimit(nil)
        let width = (UIScreen.main.bounds.width / 2) - 40
        LazyVGrid(columns: [GridItem(.adaptive(minimum: width))], alignment: .leading , spacing: 8) {
          ForEach(model.results, id: \.id) { result in
            NavigationLink(value: result) {
              VStack(spacing: 8) {
                HStack {
                  Text(result.name)
                  Spacer()
                  Text("#\(result.id)")
                }
                
                HStack(spacing: 4) {
                  if let types = result.types {
                    VStack(alignment: .leading) {
                      ForEach(types, id: \.self) { type in
                        Text(type.type.name)
                      }
                    }
                  }
                  
                  Spacer()
                  WebImage(url: result.image)
                    .frame(width: 56, height: 56)
                    .scaledToFit()
                }
              }
              .frame(width: width - 8)
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
      .searchable(text: $model.searchText, placement: .navigationBarDrawer, prompt: "search a pokémon")
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Text("Pokédex")
            .font(.largeTitle)
            .fontWeight(.bold)
          Text("X")
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
