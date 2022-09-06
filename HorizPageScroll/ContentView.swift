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
    let thumbSize: CGSize = .init(width: 80, height: 40)
    @State var offsetX: CGFloat = 0
    @State var draggingOffsetX: CGFloat = 0
    @State var sliderDragging: Bool = false
    @State var currentIndex: Int = 0
    @State var sliderChanged: Int = 0
    @State var pageOffset: CGFloat = 0
    @State var sliderWidth: CGFloat = 0
    var maxValue: Int {
        return count - 1
    }
    
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
                                ZStack {
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
                                    GeometryReader { proxy in
                                        let offset = proxy.frame(in: .named("scroll")).minX
                                        aaaa(offset: offset, readerProxy: gproxy)
                                    }
                                }
                            }
                            .coordinateSpace(name: "scroll")
                            .padding([.leading, .trailing], -gproxy.size.width * scaleMargin / 2)
                            .frame(
                                width: gproxy.size.width * scale,
                                height: gproxy.size.height * scale
                            )
                            .background()
                            .backgroundStyle(.blue)
                            .padding([.leading, .trailing], gproxy.size.width * scaleMargin / 2)
                            Spacer()
                            
                            GeometryReader { proxy in
                                horizontalSlider(proxy: proxy, sproxy: sproxy)
                            }
                        }
                        .background()
                        .backgroundStyle(.yellow)
                    }
                }
            }
        }
    }
    
    func horizontalSlider(proxy: GeometryProxy, sproxy: ScrollViewProxy) -> some View {
        DispatchQueue.main.async {
            sliderWidth = proxy.size.width
        }
        return GHorizontalSlider(maxValue: count - 1,
                          offsetX: $offsetX,
                          draggingOffsetX: $draggingOffsetX,
                          sliderDragging: $sliderDragging,
                          currentIndex: $currentIndex,
                          sliderChanged: $sliderChanged,
                          thumbSize: thumbSize) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red)
                .opacity(0.5)
                .onChange(of: sliderChanged) { newValue in
                    
                    withAnimation { //(.easeInOut(duration: 0.15)) {
                        sproxy.scrollTo(currentIndex, anchor: .center)
                    }
                }
        }
    }
    
    func aaaa(offset: CGFloat, readerProxy: GeometryProxy) -> some View {
        GZLogFunc(offset)
        
        if sliderDragging == false {
            
            DispatchQueue.main.async {
                
                if offset == pageOffset {
                    GZLogFunc("return")
                    return
                }
                pageOffset = offset
                
                let v = offset
                let pageWidth = readerProxy.size.width * 0.75
                let value = v - readerProxy.size.width * 0.75 / 2.0
                var start = readerProxy.size.width * 0.25 / 2.0 + 20
                var minIndex: Int = 0
                var minDistance: CGFloat = 100000
                start = readerProxy.size.width * 0.25 / 2.0 + 20
                for x in 0..<count {
                    start -= 20
                    let end = start - pageWidth
                    if x == 0 && start < v {
                        currentIndex = 0
                        draggingOffsetX = (sliderWidth - thumbSize.width) / CGFloat(maxValue) * CGFloat(currentIndex)
                        offsetX = draggingOffsetX
                        GZLogFunc(currentIndex)
                        return
                    }
                    if x == count - 1 {
                        if end > v {
                            currentIndex = x
                            draggingOffsetX = (sliderWidth - thumbSize.width) / CGFloat(maxValue) * CGFloat(currentIndex)
                            offsetX = draggingOffsetX
                            GZLogFunc(currentIndex)
                            return
                        }
                    }
                    if minDistance > abs((start + end) / 2.0 - value) {
                        minDistance = abs((start + end) / 2.0 - value)
                        minIndex = x
                    }
                    start -= pageWidth
                }
                currentIndex = minIndex
                draggingOffsetX = (sliderWidth - thumbSize.width) / CGFloat(maxValue) * CGFloat(currentIndex)
                offsetX = draggingOffsetX
                GZLogFunc(draggingOffsetX)
                GZLogFunc(currentIndex)
            }
        }
        return Text("")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}