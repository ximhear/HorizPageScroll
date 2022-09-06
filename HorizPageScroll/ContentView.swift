//
//  ContentView.swift
//  HorizPageScroll
//
//  Created by gzonelee on 2022/09/06.
//

import SwiftUI

struct ContentView: View {
    @State var full: Bool = false
    let count: Int = 10
    let scale: CGFloat = 0.75
    let scaleMargin: CGFloat = 0.25
    var body: some View {
        VStack {
            if full {
                TabView {
                    ForEach(0..<count, id: \.self) { index in
                        VStack {
                            Text("Page \(index)")
                                .backgroundStyle(.blue)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            else {
                ScrollViewReader { sproxy in
                    GeometryReader { gproxy in
                        VStack {
                                Spacer()
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(alignment: .top, spacing: 20) {
                                        ForEach(0..<count, id: \.self) { index in
                                            VStack {
                                                Text("Page \(index)")
                                                    .backgroundStyle(.blue)
                                            }
                                            .frame(width: gproxy.size.width,
                                                   height: gproxy.size.height
                                            )
                                            .scaleEffect(scale)
                                            .frame(width: gproxy.size.width * scale,
                                                   height: gproxy.size.height * scale
                                            )
                                            .background()
                                            .backgroundStyle(.green)
                                            .padding([.leading], index == 0 ? gproxy.size.width * scaleMargin / 2 : 0)
                                            .padding([.trailing], index == count - 1 ? gproxy.size.width * scaleMargin / 2 : 0)
                                        }
                                    }
                                }
                                .padding([.leading, .trailing], -gproxy.size.width * scaleMargin / 2)
                                .frame(
                                    width: gproxy.size.width * scale,
                                    height: gproxy.size.height * scale
                                )
                                .background()
                                .backgroundStyle(.blue)
                                .padding([.leading, .trailing], gproxy.size.width * scaleMargin / 2)
                                Spacer()
                        }
                        .background()
                        .backgroundStyle(.yellow)
                    }
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
