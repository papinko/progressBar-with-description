//
//  ProgressBarValue.swift
//  ProgressBarValue
//
//  Created by Nikolai on 04.02.23.
//

import SwiftUI


struct ProgressBarValue: View {
    
    @Binding var plannedValue: CGFloat
    @Binding var progressValue: CGFloat
    
    // Color of progress rectangle
    @State var progressCalor: Color = .green
    
    // Color of background rectangle
    @State var plannedCalor: Color = .gray.opacity(0.7)
    
    // Corner radius of background rectangles
    @State var cornerRadius: CGFloat = 6.0
    
    //vertical Divider
    @State var lineWidth: CGFloat = 2
    
    // MARK: Sizes
    // How match pixel between progress rectangle and background rectangle
    @State var padding              = 4.0
    
    // Height of progressBar
    @State var progressBarHeight    = 20.0
    
    // if progress is over planned value the progressCalor be changed to negative color (.red)
    @State var isChangeColorIfProgressIsOver: Bool = true
    
    // Calcule of the progress value
    private var progress: CGFloat {
        get {
            if (progressValue / plannedValue > 1.0 || progressValue == plannedValue) {
                return 100.0
            }
            return progressValue / plannedValue
        }
    }
    
    // Get only progress in %
    private var progressProcent: CGFloat {
        get {
            if(progressValue == 0.0 && plannedValue == 0.0){
                return 0.0
            }
            return progressValue / plannedValue * 100.0
        }
    }
    
    // The difference between progressValue and plannedValue
    private var restValue: CGFloat {
        get { return plannedValue - progressValue }
    }
    
    // Default text height
    private var textRectHeight: CGFloat {
        get {
            return progressBarHeight + (padding * 4) + padding
        }
    }
    
    // Calculate the corner radius for a progress rectangle
    private var secudaryCornerRadius: CGFloat {
        get {
            return cornerRadius / 33.0
        }
    }
    
    // Dynamic calculated size of planned Text value
    @State private var plannedSize: CGSize = .zero
    
    // Dynamic calculated size of progress Text value
    @State private var progressSize: CGSize = .zero
    
    // Dynamic calculated size of saldo Text value
    @State private var restSize: CGSize = .zero
    
    
    var body: some View {
        GeometryReader { geometry in
            ProgressBar(width: geometry.size.width)
           
            ProgressText(width: geometry.size.width)
            
            PlannedText(width: geometry.size.width)
        }
    }
    
    @ViewBuilder
    func PlannedText(width: CGFloat)->some View {
       
        // Text of planned value
        Text(plannedValue.description)
            .offset(x: width - plannedSize.width - padding - restSize.width, y: textRectHeight + padding)
            .background(ViewGeometry())
            .onPreferenceChange(ViewSizeKey.self) {
                plannedSize = $0
            }
        
        // Custom vertical "divider"
        Rectangle()
            .fill(plannedCalor)
            .frame(width: lineWidth, height: textRectHeight, alignment: .center)
            .offset(x:  width - padding / lineWidth - restSize.width, y: 20 + padding + lineWidth)
    }
    
    @ViewBuilder
    func ProgressText(width: CGFloat)->some View {
        
        // Text of progress value
        Text(progressValue.description)
            .offset(x: GetProgressWidth(width: width) - progressSize.width, y: -padding)
            .background(ViewGeometry())
            .onPreferenceChange(ViewSizeKey.self) {
                progressSize = $0
            }
            .transition(.move(edge: .leading))
        
        // In procent
        Text("\(progressProcent, specifier: "%.2f") %")
            .foregroundColor(.gray)
            .font(Font.custom("Avenir Next", size: CGFloat(10)).weight(.regular))
            .offset(x: GetProgressWidth(width: width) + padding * 2, y: -padding)
        
        // Custom vertical "divider"
        Rectangle()
            .fill(GetProgressColor())
            .frame(width: lineWidth, height: textRectHeight, alignment: .center)
            .offset(x: GetProgressWidth(width: width) + lineWidth, y: -padding)
    }
    
    
    @ViewBuilder
    func ProgressBar(width: CGFloat)->some View {
        
        ZStack(alignment: .leading) {
            
            // progressBar background rectangle
            Rectangle()
                .fill(plannedCalor)
                .frame(width: width - restSize.width, height: progressBarHeight)
                .foregroundColor(Color.gray)
                .cornerRadius(cornerRadius)
                .shadow(color: .gray, radius: 2, x: 2, y: 2)
            
            // Progress bar
            Rectangle()
                // Corner radius only for a left side
                .cornerRadius(secudaryCornerRadius, corners: .bottomLeft)
                .cornerRadius(secudaryCornerRadius, corners: .topLeft)
                .frame(width: GetProgressWidth(width: width) , height: progressBarHeight - padding * 2)
                .foregroundColor(GetProgressColor())
                .padding(.leading, padding)
            
            // Rest text
            Text(restValue.description)
                .foregroundColor(restValue >= 0.0 ? Color.black : Color.red)
                .background(ViewGeometry())
                .onPreferenceChange(ViewSizeKey.self) {
                    restSize = $0
                }
                .offset(x: width - restSize.width + padding)
                .padding(.trailing, padding)
        }
        .padding(.trailing, restSize.width)
        .padding(.top, 20)
    }
    
    private func GetProgressColor()->Color {
        return progressValue > plannedValue ? isChangeColorIfProgressIsOver ? .red : progressCalor : progressCalor
    }
    
    // Calculate the actually progress width
    private func GetProgressWidth(width: CGFloat)->CGFloat {
        return min(CGFloat(self.progress) * width - restSize.width * self.progress, width - restSize.width - padding * 2)
    }
    
    // MARK: serve for dynamic size getting of the any control
    struct ViewSizeKey: PreferenceKey {
        static var defaultValue: CGSize = .zero

        static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
            value = nextValue()
        }
    }
    
    struct ViewGeometry: View {
        var body: some View {
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ViewSizeKey.self, value: geometry.size)
            }
        }
    }
}



#if DEBUG
struct ProgressBarValue_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarValue(plannedValue: .constant(1000), progressValue: .constant(1000))
    }
}
#endif
