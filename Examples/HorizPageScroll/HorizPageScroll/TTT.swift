//
//  TTT.swift
//  HorizPageScroll
//
//  Created by gzonelee on 2022/09/06.
//

import SwiftUI

class PageData: Identifiable {
    var id: Int
    var color: Color
    
    init(id: Int, color: Color) {
        self.id = id
        self.color = color
    }
}

struct TTT: View {
    let data: [PageData] = [
        .init(id: 0, color: .red),
        .init(id: 1, color: .orange),
        .init(id: 2, color: .yellow),
        .init(id: 3, color: .green),
        .init(id: 4, color: .mint),
        .init(id: 5, color: .teal),
        .init(id: 6, color: .cyan),
        .init(id: 7, color: .blue),
        .init(id: 8, color: .indigo),
        .init(id: 9, color: .purple),
        .init(id: 10, color: .pink),
    ]
    
    @State var lower: Int = 0
    @State var upper: Int = 2
    @State var current: Int = 1

    @State var rotation: Double = 0

    var body: some View {
        GeometryReader { proxy in
            VStack {
                Button {
                    rotation += 10
                } label: {
                    Text("Rotation +")
                }
                Button {
                    rotation -= 10
                } label: {
                    Text("Rotation -")
                }
                Button {
                    withAnimation {
                        if current < 9 {
                            current += 1
                        }
                        lower = current - 1
                        upper = current + 1
                    }
                } label: {
                    Text("Page +")
                }
                Button {
                    withAnimation {
                        if current > 1 {
                            current -= 1
                        }
                        lower = current - 1
                        upper = current + 1
                    }
                } label: {
                    Text("Page -")
                }
                Text("\(offsetX)")

                GeometryReader { proxy in
                    content(proxy: proxy)
                }
            }
        }
//        .padding()
    }
    
    func content(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            pageWidth = proxy.size.width
        }
        return HStack(spacing: 0) {
            ForEach(lower...upper, id: \.self) { index in
                Rectangle()
                    .fill(data[index].color)
                    .frame(width: proxy.size.width)
                    .rotation3DEffect(Angle(degrees: 0), axis: (0, 0, 1))
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
    
    var minimumDistance: CGFloat = 15
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
    func onDragChanged(with value: DragGesture.Value) {
       
        offsetX = value.translation.width
    }
    
    @State var pageWidth: CGFloat = 100
    func onDragGestureEnded() {
        withAnimation {
            if abs(offsetX) >= pageWidth / 2 {
                if offsetX < 0 {
                    if current < 9 {
                        current += 1
                    }
                }
                else {
                    if current > 1 {
                        current -= 1
                    }
                }
                lower = current - 1
                upper = current + 1
            }
            offsetX = 0
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
