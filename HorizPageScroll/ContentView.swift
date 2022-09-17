//
//  ContentView.swift
//  HorizPageScroll
//
//  Created by gzonelee on 2022/09/08.
//

import SwiftUI

struct ContentView: View {
    @State var compactMode: Bool = false
    var body: some View {
        VStack {
            HStack {
                Text("Toggle Paging View")
                    .bold()
            }
            .padding()
            Button(compactMode ? "Full" : "Compact") {
                compactMode.toggle()
            }
            VStack {
                TTT()
//                TogglePagingView(count: 1200,
//                                 thumbSize: .init(width: 80, height: 40),
//                                 slideBarHeight: 20,
//                                 spacing: 20,
//                                 slideSidePadding: 16,
//                                 compactMode: $compactMode
//                ) { index, toggleMode in
//                    content(index: index)
//                } compactContent: { index in
//                    content(index: index)
//                }  thumbContent: {
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.red)
//                        .opacity(0.5)
//                } slideBarContent: {
//                    RoundedRectangle(cornerRadius: 5)
//                        .fill(Color.accentColor)
//                }
            }
            .padding()
            HStack {
                Text("Bottom Area")
                    .bold()
            }
        }
    }
    
    @ViewBuilder func content(index: Int) -> some View {
        GeometryReader { proxy in
            VStack {
                Text("\(index) page")
                    .bold()
                    .foregroundColor(.red)
                    .padding()
                    .background()
                    .backgroundStyle(.green)
                Grid {
                    GridRow {
                        Image(systemName: "applelogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("Apple")
                    }
                    GridRow {
                        Text("Globe")
                        Image(systemName: "globe")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    GridRow {
                        Image(systemName: "hand.wave")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("Hand")
                    }
                    GridRow {
                        Text("Plus")
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    GridRow {
                        Image(systemName: "book")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("Book")
                    }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background()
            .backgroundStyle(.yellow)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
