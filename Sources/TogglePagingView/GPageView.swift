//
//  GPageView.swift
//  HorizPageScroll
//
//  Created by gzonelee on 2022/09/18.
//

import SwiftUI

public struct GPageView<ContentView: View>: View {
    
    @State var lower: Int
    @State var upper: Int
    @Binding var current: Int

    @State var rotation: Double = 0
    
    public typealias ContentBlock = (Int) -> ContentView
    let contentBlock: ContentBlock
    let dataCount: Int
    
    public init(page: Binding<Int>, dataCount: Int, content: @escaping ContentBlock) {
        _current = page
        contentBlock = content
        self.dataCount = dataCount
        
        if dataCount > 0 {
            if _current.wrappedValue < 0 {
                _current.wrappedValue = 0
            }
            else if _current.wrappedValue >= dataCount {
                _current.wrappedValue = dataCount - 1
            }
            GZLogFunc(_current.wrappedValue)

            _lower = State<Int>.init(wrappedValue: _current.wrappedValue - 1)
            if _lower.wrappedValue < 0 {
                _lower.wrappedValue = 0
            }
            _upper = State<Int>.init(wrappedValue: _current.wrappedValue + 1)
            if _upper.wrappedValue >= dataCount {
                _upper.wrappedValue = dataCount - 1
            }
        }
        else {
            _lower = State<Int>.init(wrappedValue: 0)
            _upper = State<Int>.init(wrappedValue: 0)
        }
    }
    
    func calcPageBounds() {
        if dataCount == 0 { return }
        
        if current < 0 {
            current = 0
        }
        else if current >= dataCount {
            current = dataCount - 1
        }
        GZLogFunc(current)
        
        lower = current - 1
        if lower < 0 {
            lower = 0
        }
        upper = current + 1
        if upper >= dataCount {
            upper = dataCount - 1
        }
        GZLogFunc(lower)
        GZLogFunc(upper)
    }

    public var body: some View {
        GeometryReader { proxy in
            VStack {
                GeometryReader { proxy in
                    if dataCount == 0 {
                        Rectangle()
                            .fill(.clear)
                            .frame(width: proxy.size.width)
                    }
                    else {
                        content(proxy: proxy)
                    }
                }
            }
        }
    }
    
    func content(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            pageWidth = proxy.size.width
        }
        return HStack(spacing: 0) {
            ForEach(lower...upper, id: \.self) { index in
                
                contentBlock(index)
                    .frame(width: proxy.size.width)
                    .rotation3DEffect(Angle(degrees: (Double(index - current) + Double(offsetX / proxy.size.width)) * -30 + rotation), axis: (0, 1,  0))
            }
            .offset(.init(width: CGFloat(lower - current) * proxy.size.width + offsetX, height: 0))
        }
        .gesture(swipeGesture)
        .onChange(of: isGestureFinished) { value in
            if value {
                onDragGestureEnded()
            }
        }
        
    }
    
    var minimumDistance: CGFloat = 5
    @GestureState var isGestureFinished = true
    var swipeGesture: some Gesture {
        DragGesture(minimumDistance: minimumDistance, coordinateSpace: .global)
            .updating($isGestureFinished) { _, state, _ in
                state = false
            }
            .onChanged({ value in
                self.onDragChanged(with: value)
            })
    }
    @State var offsetX: CGFloat = 0
    @State var lastDraggingValue: DragGesture.Value?
    @State var draggingVelocity: Double = 0
    func onDragChanged(with value: DragGesture.Value) {
        GZLogFunc()
        
        let currentX = value.location.x
        let lastX = self.lastDraggingValue?.location.x ?? currentX
        let offsetIncrement = currentX - lastX
        GZLogFunc("offsetIncrement : \(offsetIncrement)")
        
        let timeIncrement = value.time.timeIntervalSince(self.lastDraggingValue?.time ?? value.time)
        GZLogFunc("timeIncrement : \(timeIncrement)")
        if timeIncrement != 0 {
            self.draggingVelocity = Double(offsetIncrement) / timeIncrement
        }
        offsetX = value.translation.width
        self.lastDraggingValue = value
    }
    
    @State var pageWidth: CGFloat = 100
    func onDragGestureEnded() {
        
        var animation: Animation
        if abs(draggingVelocity) > 500 {
            animation = Animation.timingCurve(0.2, 1, 0.9, 1, duration: 0.2)
        }
        else {
            animation = Animation.easeOut(duration: 0.35)
            
        }
        withAnimation(animation) {
            GZLogFunc(draggingVelocity)
            if abs(offsetX) >= pageWidth / 2 || abs(draggingVelocity) > 500 {
                if offsetX < 0 || draggingVelocity < 0 {
                    if current < dataCount - 1 {
                        current += 1
                    }
                }
                else {
                    if current > 0 {
                        current -= 1
                    }
                }
                calcPageBounds()
            }
            offsetX = 0
            lastDraggingValue = nil
            draggingVelocity = 0
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

struct GPageView_Previews: PreviewProvider {
    
    class PageData: Identifiable {
        var color: Color
        
        init(color: Color) {
            self.color = color
        }
    }
    
    static let data: [PageData] = [
        .init(color: .red),
        .init(color: .orange),
        .init(color: .yellow),
        .init(color: .green),
        .init(color: .mint),
        .init(color: .teal),
        .init(color: .cyan),
        .init(color: .blue),
        .init(color: .indigo),
        .init(color: .purple),
        .init(color: .pink),
    ]
    @State static var page: Int = 0
    static var previews: some View {
        GPageView(page: $page, dataCount: data.count) { index in
                Rectangle()
                    .fill(data[index].color)
        }
    }
}
