//
//  ContentView.swift
//  ProgressBarValue
//
//  Created by Nikolai on 04.02.23.
//

import SwiftUI

struct ContentView: View {
    
    @State var plannedValue: CGFloat = 1120.0
    @State var progressValue: CGFloat = 400.0
    
    var body: some View {
        VStack {
            Text("Progress")
                .font(.title)
            
            ProgressBarValue(plannedValue: $plannedValue, progressValue: $progressValue)
                .onAppear(){
                    ChangeProgressValue()
                }
        }
        .padding(.horizontal, 15)
    }
    
    private func ChangeProgressValue() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                progressValue += 125
                if progressValue < plannedValue {
                    ChangeProgressValue()
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
