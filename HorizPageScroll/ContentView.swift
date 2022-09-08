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
                TogglePagingView()
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
