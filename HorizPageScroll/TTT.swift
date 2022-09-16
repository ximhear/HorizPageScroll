//
//  TTT.swift
//  HorizPageScroll
//
//  Created by gzonelee on 2022/09/06.
//

import SwiftUI

struct TTT: View {
    let data = (1...100).map { "Item \($0)" }

    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(proxy.size.width))], spacing: 0) {
                    ForEach(data, id: \.self) { item in
                        VStack {
                            Text("\(proxy.size.width))")
                            Text("\(proxy.size.height))")
                            Text(item)
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .background()
                        .backgroundStyle(.red)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            UIScrollView.appearance().isPagingEnabled = true
        }
        .onDisappear {
            UIScrollView.appearance().isPagingEnabled = false
        }
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
