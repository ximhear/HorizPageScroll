//
//  TogglePagingView.swift
//  HorizPageScroll
//
//  Created by gzonelee on 2022/09/06.
//

import SwiftUI

struct TogglePagingView: View {
    @State var full: Bool = true
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
                TabView(selection: $currentIndex) {
                    ForEach(0..<count, id: \.self) { index in
                        VStack {
                            Text("Page \(index)")
                                .backgroundStyle(.blue)
                                .onTapGesture {
                                    full = false
                                }
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
                                    GeometryReader { proxy in
                                        let offset = proxy.frame(in: .named("scroll")).minX
                                        aaaa(offset: offset, readerProxy: gproxy)
                                    }
                                    LazyHStack(alignment: .top, spacing: 20) {
                                        ForEach(0..<count, id: \.self) { index in
                                            Group {
                                                VStack {
                                                    Text("Page \(index)")
                                                        .backgroundStyle(.blue)
                                                }
                                                .allowsHitTesting(false)
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
                                            .onTapGesture {
                                                GZLogFunc()
                                                full = true
                                            }
                                        }
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
                            .onAppear {
                                sliderDragging = true
                                if currentIndex == 0 {
                                    sproxy.scrollTo(currentIndex, anchor: .leading)
                                }
                                else if currentIndex == count - 1 {
                                    sproxy.scrollTo(currentIndex, anchor: .trailing)
                                }
                                else {
                                    sproxy.scrollTo(currentIndex, anchor: .center)
                                }
                                DispatchQueue.main.async {
                                    sliderDragging = false
                                }
                            }
                            
                            Spacer()
                            
                            GeometryReader { proxy in
                                horizontalSlider(proxy: proxy, sproxy: sproxy)
                            }
                            .padding()
                        }
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
                let pageWidth = readerProxy.size.width * scale
                let value = v - readerProxy.size.width * scale / 2.0
                var start: CGFloat = 20
                var minIndex: Int = 0
                var minDistance: CGFloat = 100000
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

struct TogglePagingView_Previews: PreviewProvider {
    static var previews: some View {
        TogglePagingView()
    }
}
