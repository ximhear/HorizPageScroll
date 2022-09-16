//
//  TogglePagingView.swift
//  HorizPageScroll
//
//  Created by gzonelee on 2022/09/06.
//

import SwiftUI


struct TogglePagingView<FullView: View, CompactView: View, ThumbView: View, SlideBarView: View>: View {
    @Binding var compactMode: Bool
    let count: Int
    @State var scale: CGFloat = 0.75
    @State var scaleMargin: CGFloat = 0.25
    let thumbSize: CGSize
    let slideBarHeight: CGFloat
    let spacing: CGFloat
    let slideSidePadding: CGFloat
    @State var draggingOffsetX: CGFloat = 0
    @State var sliderDragging: Bool = false
    @State var currentIndex: Int = 0
    @State var sliderChanged: Int = 0
    @State var pageOffset: CGFloat = 0
    @State var sliderWidth: CGFloat = 0
    @State var horizontalSpacing: CGFloat = 20
    var maxValue: Int {
        return count - 1
    }
    
    typealias FullContentBlock = (Int, @escaping () -> Void) -> FullView
    typealias CompactContentBlock = (Int) -> CompactView
    typealias ThumbBlock = () -> ThumbView
    typealias SlideBarBlock = () -> SlideBarView
    
    @ViewBuilder var fullContent: FullContentBlock
    @ViewBuilder var compactContent: CompactContentBlock
    @ViewBuilder var thumbContent: ThumbBlock
    @ViewBuilder var slideBarContent: SlideBarBlock
    
    init(count: Int,
         thumbSize: CGSize,
         slideBarHeight: CGFloat,
         spacing: CGFloat,
         slideSidePadding: CGFloat,
         compactMode: Binding<Bool>,
         @ViewBuilder fullContent: @escaping FullContentBlock,
         @ViewBuilder compactContent: @escaping CompactContentBlock,
         @ViewBuilder thumbContent: @escaping ThumbBlock,
         @ViewBuilder slideBarContent: @escaping SlideBarBlock
    ) {
        self.count = count
        self.thumbSize = thumbSize
        self.slideBarHeight = slideBarHeight
        self.spacing = spacing
        self.slideSidePadding = slideSidePadding
        self._compactMode = compactMode
        self.fullContent = fullContent
        self.compactContent = compactContent
        self.thumbContent = thumbContent
        self.slideBarContent = slideBarContent
    }
    
    var body: some View {
        VStack {
            if compactMode == false {
                TabView(selection: $currentIndex) {
                    ForEach(0..<count, id: \.self) { index in
                        fullContent(index, toggleMode)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            else {
                ScrollViewReader { sproxy in
                    GeometryReader { gproxy in
                        VStack(spacing: 0) {
                            scrollContainer(sproxy: sproxy, gproxy: gproxy)
//                                .background()
//                                .backgroundStyle(.cyan)
                            horizontalSlider(width: gproxy.size.width - slideSidePadding * 2, sproxy: sproxy)
                            .padding([.leading, .trailing], slideSidePadding)
//                            .background()
//                            .backgroundStyle(.yellow)
                            .padding([.top], spacing)
                        }
                        .frame(width: gproxy.size.width, height: gproxy.size.height)
                    }
                }
            }
        }
    }
    
    func toggleMode() {
        compactMode.toggle()
    }
    
    func horizontalSlider(width: CGFloat, sproxy: ScrollViewProxy) -> some View {
        DispatchQueue.main.async {
            sliderWidth = width
        }
        return GHorizontalSlider(maxValue: count - 1,
                                 draggingOffsetX: $draggingOffsetX,
                                 sliderDragging: $sliderDragging,
                                 currentIndex: $currentIndex,
                                 sliderChanged: $sliderChanged,
                                 thumbSize: thumbSize,
                                 thumb: {
            thumbContent()
                .onChange(of: sliderChanged) { newValue in
                    
                    withAnimation { //(.easeInOut(duration: 0.15)) {
                        sproxy.scrollTo(currentIndex, anchor: .center)
                    }
                }
        },
                                 slideBarHeight: slideBarHeight,
                                 slideBar: {
            slideBarContent()
        })
    }
    
    func scrollContainer(sproxy: ScrollViewProxy, gproxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            let newScale = (gproxy.size.width - max(slideBarHeight, thumbSize.height) - spacing) / gproxy.size.width * 0.8
            if newScale != scale {
                scale = newScale
                scaleMargin = 1.0 - scale
            }
        }
        return ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: horizontalSpacing) {
                ForEach(0..<count, id: \.self) { index in
                    compactContent(index)
                    .allowsHitTesting(false)
                    .frame(width: gproxy.size.width,
                           height: gproxy.size.height
                    )
                    .scaleEffect(scale)
                    .frame(width: gproxy.size.width * scale,
                           height: gproxy.size.height * scale
                    )
                    .background()
                    .backgroundStyle(.green.opacity(0.2))
                    .border(.gray.opacity(0.5))
                    .onTapGesture {
                        GZLogFunc()
                        currentIndex = index
                        toggleMode()
                    }
                    .padding([.leading], index == 0 ? gproxy.size.width * scaleMargin / 2 : 0)
                    .padding([.trailing], index == count - 1 ? gproxy.size.width * scaleMargin / 2 : 0)
                }
            }
            .background(content: {
                GeometryReader { proxy in
                    let offset = proxy.frame(in: .named("scroll")).minX
                    aaaa(offset: offset, readerProxy: gproxy)
                }
            })
        }
        .coordinateSpace(name: "scroll")
        .padding([.leading, .trailing], -gproxy.size.width * scaleMargin / 2)
        .frame(
            width: gproxy.size.width * scale,
            height: gproxy.size.height * scale
        )
        .background()
//        .backgroundStyle(.blue)
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
    }
    
    func aaaa(offset: CGFloat, readerProxy: GeometryProxy) -> some View {
//        GZLogFunc("offset :\(-offset)")
        
        if sliderDragging == false {
            
            DispatchQueue.main.async {
                
                if offset == pageOffset {
                    GZLogFunc("return")
                    return
                }
                pageOffset = offset
                
                let v = -offset
                let pageWidth = readerProxy.size.width * scale
                let value = v + pageWidth / 2.0
                var start: CGFloat = 0
                var minIndex: Int = 0
                var minDistance: CGFloat = 100000
                for x in 0..<count {
                    let end = start + pageWidth
                    let center = (start + end) / 2.0
                    if minDistance > abs(center - value) {
                        minDistance = abs(center - value)
                        minIndex = x
                    }
                    start = end
                    start += horizontalSpacing
                }
                currentIndex = minIndex
                draggingOffsetX = (sliderWidth - thumbSize.width) / CGFloat(maxValue) * CGFloat(currentIndex)
//                offsetX = draggingOffsetX
//                GZLogFunc("currentIndex :\(currentIndex)")
            }
        }
        return Text("")
    }
}

struct TogglePagingView_Previews: PreviewProvider {
    @State static var compactMode: Bool = false
    static var previews: some View {
        TogglePagingView(count: 5,
                         thumbSize: .init(width: 40, height: 40),
                         slideBarHeight: 10,
                         spacing: 10,
                         slideSidePadding: 16,
                         compactMode: $compactMode
        ) { index, toggleMode in
            content(index: index)
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
        } thumbContent: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red)
                .opacity(0.5)
        } slideBarContent: {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.accentColor)
        }
    }
    
    @ViewBuilder static func content(index: Int) -> some View {
        GeometryReader { proxy in
            VStack {
                Text("\(index) page")
                Grid {
                    GridRow {
                        VStack {
                            AsyncImage(url: URL(string: "https://img.etnews.com/photonews/2003/1283500_20200318150357_900_0001.jpg")!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Color.purple.opacity(0.1)
                            }
                        }
                    }
                    GridRow {
                        Text("Hello")
                        Image(systemName: "globe")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    GridRow {
                        Image(systemName: "hand.wave")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("World")
                    }
                    GridRow {
                        Text("Hello")
                        Image(systemName: "globe")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    GridRow {
                        Image(systemName: "hand.wave")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("World")
                    }
                }
            }
            .frame(width: proxy.size.width)
            .background()
            .backgroundStyle(.yellow)
        }
    }
}
