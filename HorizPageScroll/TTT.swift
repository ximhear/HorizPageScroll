//
//  TTT.swift
//  HorizPageScroll
//
//  Created by gzonelee on 2022/09/06.
//

import SwiftUI

struct TTT: View {
    var body: some View {
        VStack {
            TabView {
                VStack {
                    Text("1")
                }
                .badge(2)
                .tabItem {
                    Label("Received", systemImage: "tray.and.arrow.down.fill")
                }
                VStack {
                    Text("2")
                }
                .tabItem {
                    Label("Sent", systemImage: "tray.and.arrow.up.fill")
                }
                VStack {
                    Text("3")
                }
                .badge("!")
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
            }
        }
    }
}

struct TTT_Previews: PreviewProvider {
    static var previews: some View {
        TTT()
    }
}
