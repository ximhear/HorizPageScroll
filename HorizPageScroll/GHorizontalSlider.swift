//
//  GHorizontalSlider.swift
//  HorizPageScroll
//
//  Created by gzonelee on 2022/09/07.
//

import SwiftUI

struct GHorizontalSlider<Content: View>: View {
    let thumbView: Content
    let thumbSize: CGSize
    
    let maxValue: Int
    let barHeight: CGFloat = 20
    @Binding var offsetX: CGFloat
    @Binding var draggingOffsetX: CGFloat
    @Binding var sliderDragging: Bool
    @Binding var currentIndex: Int
    @Binding var sliderChanged: Int
    
    init(maxValue: Int, offsetX: Binding<CGFloat>, draggingOffsetX: Binding<CGFloat>, sliderDragging: Binding<Bool>, currentIndex: Binding<Int>, sliderChanged: Binding<Int>, thumbSize: CGSize, @ViewBuilder thumb: () -> Content) {
        self.maxValue = maxValue
        _offsetX = offsetX
        _draggingOffsetX = draggingOffsetX
        _sliderDragging = sliderDragging
        _currentIndex = currentIndex
        _sliderChanged = sliderChanged
        self.thumbSize = thumbSize
        self.thumbView = thumb()
        GZLogFunc("value : \($currentIndex)")
        GZLogFunc("draggingOffsetX : \($draggingOffsetX)")
    }
    
    
    var body: some View {
        
        GeometryReader { reader in
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.accentColor)
                    .frame(width: reader.size.width - thumbSize.width, height: barHeight)
                HStack() {
                    thumbView
                        .frame(width: thumbSize.width, height: thumbSize.height)
                        .offset(x: draggingOffsetX, y: 0)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    sliderDragging = true
                                    draggingOffsetX = offsetX + gesture.translation.width

                                    let m = (reader.size.width - thumbSize.width)
                                    let old = currentIndex
                                    if draggingOffsetX < 0 {
                                        draggingOffsetX = 0
                                    }
                                    else if draggingOffsetX > m {
                                        draggingOffsetX = m
                                    }
                                    currentIndex = Int(round(draggingOffsetX * CGFloat(maxValue) / m))
                                    draggingOffsetX = m / CGFloat(maxValue) * CGFloat(currentIndex)
                                    if old != currentIndex {
                                        sliderChanged &+= 1
                                    }
                                }
                            
                                .onEnded { gesture in
                                    let old = currentIndex
                                    draggingOffsetX = offsetX + gesture.translation.width
                                    let m = (reader.size.width - thumbSize.width)
                                    if draggingOffsetX < 0 {
                                        draggingOffsetX = 0
                                    }
                                    else if draggingOffsetX > m {
                                        draggingOffsetX = m
                                    }
                                    currentIndex = Int(round(draggingOffsetX * CGFloat(maxValue) / m))
                                    draggingOffsetX = m / CGFloat(maxValue) * CGFloat(currentIndex)
                                    GZLogFunc(currentIndex)
                                    GZLogFunc(draggingOffsetX)
                                    offsetX = draggingOffsetX
                                    if old != currentIndex {
                                        sliderChanged &+= 1
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        sliderDragging = false
                                    })
                                }
                        )
                    Spacer()
                }
                .frame(width: reader.size.width)
            }
            .onAppear(perform: {
                draggingOffsetX = (reader.size.width - thumbSize.width) / CGFloat(maxValue) * CGFloat(currentIndex)
                offsetX = draggingOffsetX
                GZLogFunc(reader.size.width)
                GZLogFunc(currentIndex)
            })
            .frame(width: reader.size.width, height: max(barHeight, thumbSize.height))
        }
    }
}

struct GHorizontalSlider_Previews: PreviewProvider {
    @State static var offsetX: CGFloat = 0
    @State static var draggingOffsetX: CGFloat = 0
    @State static var sliderDragging: Bool = false
    @State static var currentIndex: Int = 0
    @State static var sliderChanged: Int = 0
    static var previews: some View {
        GHorizontalSlider(
            maxValue: 10,
            offsetX: $offsetX,
            draggingOffsetX: $draggingOffsetX,
            sliderDragging: $sliderDragging,
            currentIndex: $currentIndex,
            sliderChanged: $sliderChanged,
            thumbSize: .init(width: 80, height: 40)) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.red)
                    .opacity(0.5)
            }
            .padding()
    }
}