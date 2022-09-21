//
//  GPageTestView.swift
//  HorizPageScroll
//
//  Created by gzonelee on 2022/09/19.
//

import SwiftUI
import TogglePagingView

struct GPageTestView: View {
    
    class PageData: Identifiable {
        var color: Color
        
        init(color: Color) {
            self.color = color
        }
    }
    
    let data: [PageData] = [
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
    @State var page: Int = 9
    var body: some View {
        VStack {
            Text("page : \(page)")
            GPageView(page: $page, dataCount: data.count) { index in
                    Rectangle()
                        .fill(data[index].color)
            }
        }
    }
}

struct GPageTestView_Previews: PreviewProvider {
    static var previews: some View {
        GPageTestView()
    }
}
