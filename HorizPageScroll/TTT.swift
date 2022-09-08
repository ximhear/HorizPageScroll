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
            GeometryReader { gproxy in
                VStack(alignment: .center) {
                    Spacer()
                    Text("Hello")
                    Spacer()
                    Text("Hello")
                    Spacer()
                    Text("Hello")
                    Spacer()
                }
                .frame(width: gproxy.size.width, height: gproxy.size.height)
                .background()
                .backgroundStyle(.red)
            }
            Text("1")
        }
    }
}

struct TTT_Previews: PreviewProvider {
    static var previews: some View {
        TTT()
    }
}
