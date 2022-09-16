//
//  ContentView.swift
//  HorizPageScroll
//
//  Created by gzonelee on 2022/09/08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Title")
            }
            VStack {
                TogglePagingView(count: 5,
                                 thumbSize: .init(width: 80, height: 40),
                                 slideBarHeight: 20,
                                 spacing: 10,
                                 slideSidePadding: 16
                ) { index, toggleMode in
                    VStack {
                        Text("Page \(index)")
                        Spacer()
                        Text("Page \(index)")
                            .backgroundStyle(.blue)
                            .onTapGesture {
                                toggleMode()
                            }
                        Spacer()
                        Text("Page \(index)")
                    }
                } compactContent: { index in
                    VStack {
                        Text("Page \(index)")
                            .backgroundStyle(.blue)
                        Spacer()
                        Text("Page \(index)")
                            .backgroundStyle(.blue)
                        Spacer()
                        Text("Page \(index)")
                            .backgroundStyle(.blue)
                    }
                }  thumbContent: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red)
                        .opacity(0.5)
                } slideBarContent: {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.accentColor)
                }
//                .background()
//                .backgroundStyle(.blue.opacity(0.3))
            }
            .padding()
            HStack {
               Text("Bottom")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
