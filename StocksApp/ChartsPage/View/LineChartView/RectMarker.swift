//
//  RectMarker.swift
//  StocksApp
//
//  Created by Dias Kaussov on 14.01.2025.
//
import Foundation
import UIKit
import DGCharts

open class RectMarker: MarkerImage {
    open var color: NSUIColor?
    
    open var font: NSUIFont?
    
    open var insets = UIEdgeInsets()
    
    open var flag: Bool
    
    open var miniTime : Double = 100000
    
    open var minimumSize = CGSize()
    
    var interval = 3600.0 * 24.0*7
    
    var dateFormatter = DateFormatter()
    
    fileprivate var label: NSMutableAttributedString?
    
    fileprivate var _labelSize: CGSize = CGSize()
    
    private var markerLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()

    public init(
        color: UIColor,
        font: UIFont,
        insets: UIEdgeInsets,
        flag: Bool,
        miniTime: Double=10000000,
        interval: Double = 3600.0 * 24.0*30
    ) {
        self.flag = flag
        super.init()
        self.markerLabel.textColor = .cyan
        self.color = color
        self.font = font
        self.insets = insets
        self.miniTime = miniTime
        self.interval = interval
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yy HH:mm"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00")! as TimeZone
    }

    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        var offset = CGPoint()
        let chart = self.chartView
        var size = self.size
        
        if size.width == 0.0 && image != nil
        {
            size.width = image?.size.width ?? 0.0
        }
        if size.height == 0.0 && image != nil
        {
            size.height = image?.size.height ?? 0.0
        }
        
        let width = size.width
        let height = size.height
        let origin = point

        if origin.x + offset.x < 0.0
        {
            offset.x = -origin.x
        }
        else if chart != nil && origin.x + width + offset.x > chart!.viewPortHandler.contentRect.maxX
        {
            offset.x =  -width
        }

        if origin.y + offset.y < 0
        {
            offset.y = height
        }
        else if chart != nil && origin.y + height + offset.y > chart!.viewPortHandler.contentRect.maxY
        {
            offset.y =  -height
        }
        return offset
    }
    
    open override func draw(context: CGContext, point: CGPoint) {
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        let rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        
        let sizeCircle = CGSize(width: 10, height: 10)
        
        let circle = CGRect(
            origin: CGPoint(
                x: point.x-5,
                y: point.y-5),
            size: sizeCircle)
        
        context.saveGState()
        if let color = color {
            context.beginPath()
            
            drawRoundedRect(
                rect: rect,
                inContext: context,
                radius: 16,
                borderColor: CGColor(gray: 0, alpha: 0),
                fillColor: color.cgColor,
                borderWidth: 0
            )
            
            drawRoundedRect(
                rect: circle,
                inContext: context,
                radius: 5,
                borderColor: CGColor(red: 1, green: 1, blue: 1, alpha: 1),
                fillColor: color.cgColor,
                borderWidth: 2
            )

            context.fillPath()
        }
        
        markerLabel.drawText(in: rect)
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        guard let chartView = self.chartView else { return }
        let mutableString = NSMutableAttributedString()
        var displayedDate = ""
        let flag = getState()
        for dataSet in chartView.data?.dataSets ?? [] {
            if let matchedEntry = dataSet.entriesForXValue(entry.x).first {
                let value = dataSet.valueFormatter.stringForValue(
                    matchedEntry.y,
                    entry: matchedEntry,
                    dataSetIndex: 0,
                    viewPortHandler: nil
                )
                let valueAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 16),
                    .foregroundColor: UIColor.white
                ]
                mutableString.append(NSAttributedString(string: "$\(value)\n", attributes: valueAttributes))
                
                if flag {
                    displayedDate = stringForValueIntraday(matchedEntry.x, xValue: matchedEntry.x)
                } else {
                    displayedDate = stringForValue(matchedEntry.x, xValue: matchedEntry.x)
                }
            }
            
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor(red: 1, green: 0.6, blue: 0.9, alpha: 1)
            ]
            mutableString.append(NSAttributedString(string: displayedDate, attributes: dateAttributes))
            
            markerLabel.attributedText = mutableString
            setLabel(mutableString)
        }
    }
    
    private func drawRoundedRect(
        rect: CGRect,
        inContext context: CGContext?,
        radius: CGFloat,
        borderColor: CGColor,
        fillColor: CGColor,
        borderWidth: CGFloat
    ) {
        let path = CGMutablePath()
        
        path.move( to: CGPoint(x:  rect.midX, y:rect.minY ))
        path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.minY ),
                     tangent2End: CGPoint(x: rect.maxX, y: rect.maxY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.maxY ),
                     tangent2End: CGPoint(x: rect.minX, y: rect.maxY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.maxY ),
                     tangent2End: CGPoint(x: rect.minX, y: rect.minY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.minY ),
                     tangent2End: CGPoint(x: rect.maxX, y: rect.minY), radius: radius)
        path.closeSubpath()
        
        context?.setLineWidth(borderWidth)
        context?.setFillColor(fillColor)
        context?.setStrokeColor(borderColor)
        
        context?.addPath(path)
        context?.drawPath(using: .fillStroke)
    }
    
    private func setLabel(_ newlabel: NSMutableAttributedString) {
        label = newlabel
        var size = CGSize()
        size.width = 100
        size.height = 60
        self.size = size
    }
    
    private func getState() -> Bool {
        return flag
    }
    
    private func stringForValue(_ value: Double, xValue: Double) -> String {
        self.dateFormatter.dateFormat = "dd MMM yy"
        let date = Date(timeIntervalSince1970: xValue)
        return dateFormatter.string(from: date)
    }
    
    private func stringForValueIntraday(_ value: Double, xValue: Double) -> String {
        self.dateFormatter.dateFormat = "dd MMM yy \n HH:mm"
        let date = Date(timeIntervalSince1970: xValue)
        return dateFormatter.string(from: date)
    }
}
