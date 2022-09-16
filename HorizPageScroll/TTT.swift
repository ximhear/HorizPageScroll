//
//  TTT.swift
//  HorizPageScroll
//
//  Created by gzonelee on 2022/09/06.
//

import SwiftUI

struct TTT: View {
    var body: some View {
        TabView {
            ForEach(0..<3, id: \.self) { index in
                aaa()
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .padding()
    }
    
    @ViewBuilder func aaa() -> some View {
        GeometryReader { proxy in
            VStack {
                Text("aaa")
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background()
            .backgroundStyle(.red)
        }
    }
    @ViewBuilder func bbb() -> some View {
        VStack {
            Text("bbb")
        }
    }
    @ViewBuilder func ccc() -> some View {
        VStack {
            Text("ccc")
        }
    }
}

struct TTT_Previews: PreviewProvider {
    static var previews: some View {
        TTT()
    }
}
