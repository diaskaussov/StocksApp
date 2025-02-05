//
//  LineChartView.swift
//  StocksApp
//
//  Created by Dias Kaussov on 14.01.2025.
//

import UIKit
import DGCharts

final class StockLineChartView: LineChartView {
    init() {
        super.init(frame: .zero)
        setView()
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        rightAxis.enabled = false
        leftAxis.enabled = false
        xAxis.enabled = false
        chartDescription.enabled = false
        legend.enabled = false
        translatesAutoresizingMaskIntoConstraints = false
    }
}
