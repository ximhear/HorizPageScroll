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
            Text("1")
            ZStack {
                Rectangle()
                    .fill(Color.cyan)
                    .padding()
                    .background()
                    .backgroundStyle(.blue)
//                GeometryReader { gproxy in
                    VStack(alignment: .center) {
                        Text("Hello")
                        Text("Hello")
                        Text("Hello")
                    }
//                    .frame(width: gproxy.size.width, height: gproxy.size.height)
                    .background()
                    .backgroundStyle(.red)
//                }
            }
            .padding()
            .background()
            .backgroundStyle(.yellow)
            Text("1")
        }
    }
}

struct TTT_Previews: PreviewProvider {
    static var previews: some View {
        TTT()
    }
}
