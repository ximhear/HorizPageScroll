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
                TogglePagingView(count: 5) { index, toggleMode in
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
                }
                .background()
                .backgroundStyle(.blue.opacity(0.3))
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
