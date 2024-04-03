//
//  RecordYearView.swift
//  Moment
//
//  Created by phang on 12/13/23.
//

import SwiftUI

struct RecordYearView: View {
    let year: Int
    
    var body: some View {
        Text(String(year))
            .foregroundColor(Color.mainBrown)
            .multilineTextAlignment(.leading)
            .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
            .background(Color.offBrown)
            .cornerRadius(10)
            .fixedSize(horizontal: false, vertical: false)
    }
}

#Preview {
    RecordYearView(year: 2023)
}
