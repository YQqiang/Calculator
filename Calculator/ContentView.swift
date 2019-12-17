//
//  ContentView.swift
//  Calculator
//
//  Created by sungrow on 2019/12/13.
//  Copyright © 2019 sungrow. All rights reserved.
//

import SwiftUI

struct CalculatorButton: View {
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let backgroundColorName: String
    let titleColorName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
            .font(.system(size: fontSize))
            .foregroundColor(Color(titleColorName))
            .frame(width: size.width, height: size.height, alignment: .center)
            .background(Color(backgroundColorName))
            .cornerRadius(size.width / 2)
        }
    }
}

struct CalculatorButtonRow: View {
    @EnvironmentObject var model: CalculatorModel
    let row: [CalculatorButtonItem]

    var body: some View {
        HStack {
            ForEach(row, id: \.self) { (item) in
                CalculatorButton(title: item.title, size: item.size, backgroundColorName: item.backgroundColorName, titleColorName: item.titleColorName) {
                    self.model.apply(item)
                }
            }
        }
    }
}

struct CalculatorButtonPad: View {
    let pad: [[CalculatorButtonItem]] = [
        [.command(.clear), .command(.flip), .command(.percent), .op(.divide),],
        [.digit(7), .digit(8), .digit(9), .op(.multiply)],
        [.digit(4), .digit(5), .digit(6), .op(.minus)],
        [.digit(1), .digit(2), .digit(3), .op(.plus)],
        [.digit(0), .dot, .op(.equal)]
    ]

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ForEach(pad, id: \.self) { (row) -> CalculatorButtonRow in
                CalculatorButtonRow(row: row)
            }
        }
    }
}

struct HistoryView: View {
    @ObservedObject var model: CalculatorModel
    @Binding var editingHistory: Bool

    var body: some View {
        VStack {
            Button("关闭页面") {
                self.editingHistory = false
            }.padding()
            if model.totalCount == 0 {
                Text("没有履历")
            } else {
                HStack {
                    Text("履历").font(.headline)
                    Text("\(model.historyDetail)").lineLimit(nil)
                }
                HStack {
                    Text("显示").font(.headline)
                    Text("\(model.brain.output)")
                }
                Slider(value: $model.slidingIndex, in: 0...Float(model.totalCount), step: 1) { (result) in
                }
            }
        }.padding()
    }
}

struct ContentView: View {
    let scale: CGFloat = UIScreen.main.bounds.width / 414
    @EnvironmentObject var model: CalculatorModel
    @State private var editingHistory = false
    @State private var showingResult = false

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Button("操作履历:(\(model.history.count))") {
                self.editingHistory = true
            }
            if self.editingHistory {
                HistoryView(model: self.model, editingHistory: self.$editingHistory)
            }
            Text(model.brain.output)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24)
                .lineLimit(1)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .trailing)
                .onTapGesture {
                    self.showingResult = true
                }
                .alert(isPresented: self.$showingResult) { () -> Alert in
                    Alert(title: Text("\(self.model.historyDetail)"), message: Text("\(self.model.brain.output)"), primaryButton: Alert.Button.default(Text("复制"), action: {
                        UIPasteboard.general.string = self.model.brain.output
                    }), secondaryButton: Alert.Button.cancel(Text("取消"), action: {
                    }))
                }
            CalculatorButtonPad()
                .padding(.bottom)
        }
        .scaleEffect(scale)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView().previewDevice("iPhone SE")
        }
    }
}
