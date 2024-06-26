//
//  CoinChartView.swift
//  SecondRecap
//
//  Created by Greed on 2/27/24.
//

import UIKit
import SnapKit
import DGCharts
import Kingfisher

final class CoinChartView: BaseView {
    
    let icon = UIImageView()
    let coinName = UILabel()
    let price = UILabel()
    let changePercentage = UILabel()
    let dateText = UILabel()
    private let todayHighLabel = UILabel()
    let todayHighPrice = UILabel()
    private let allTimeHighLabel = UILabel()
    let allTimeHighPrice = UILabel()
    private let todayLowLabel = UILabel()
    let todayLowPrice = UILabel()
    private let allTimeLowLabel = UILabel()
    let allTimeLowPrice = UILabel()
    let chart = LineChartView()
    let updateLabel = UILabel()
    
    var entries: [ChartDataEntry] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubviews([icon, coinName, price, changePercentage, dateText, todayHighLabel, todayHighPrice, allTimeHighLabel, allTimeHighPrice, todayLowLabel, todayLowPrice, allTimeLowLabel, allTimeLowPrice, chart, updateLabel])
    }
    
    override func configureLayout() {
        icon.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(8)
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.size.equalTo(40)
        }
        
        coinName.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.top)
            make.leading.equalTo(icon.snp.trailing).offset(4)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(8)
        }
        
        price.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(20)
            make.leading.equalTo(icon)
        }
        
        changePercentage.snp.makeConstraints { make in
            make.leading.equalTo(icon)
            make.top.equalTo(price.snp.bottom).offset(4)
        }
        
        dateText.snp.makeConstraints { make in
            make.leading.equalTo(changePercentage.snp.trailing).offset(8)
            make.top.equalTo(changePercentage)
        }
        
        todayHighLabel.snp.makeConstraints { make in
            make.leading.equalTo(icon).offset(4)
            make.top.equalTo(changePercentage.snp.bottom).offset(20)
        }
        
        todayHighPrice.snp.makeConstraints { make in
            make.leading.equalTo(icon).offset(4)
            make.top.equalTo(todayHighLabel.snp.bottom).offset(8)
        }
        
        todayLowLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide.snp.centerX).offset(4)
            make.top.equalTo(todayHighLabel)
        }
        
        todayLowPrice.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(todayHighPrice)
        }
        
        allTimeHighLabel.snp.makeConstraints { make in
            make.leading.equalTo(todayHighLabel)
            make.top.equalTo(todayHighPrice.snp.bottom).offset(16)
        }
        
        allTimeHighPrice.snp.makeConstraints { make in
            make.leading.equalTo(todayHighPrice)
            make.top.equalTo(allTimeHighLabel.snp.bottom).offset(8)
        }
        
        allTimeLowLabel.snp.makeConstraints { make in
            make.leading.equalTo(todayLowLabel.snp.leading)
            make.top.equalTo(allTimeHighLabel)
        }
        
        allTimeLowPrice.snp.makeConstraints { make in
            make.leading.equalTo(todayLowPrice.snp.leading)
            make.top.equalTo(allTimeHighPrice)
        }
        
        
        chart.snp.makeConstraints { make in
            make.top.equalTo(allTimeLowPrice.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(-10)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
        }
    
        updateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(4)
            make.top.equalTo(chart.snp.bottom).offset(4)
        }
    }
    
    func inputData(_ item: CoinMarket) {
        var xValue: Double = 0
        for y in item.sparkline.price {
            xValue += 1
            entries.append(ChartDataEntry(x: xValue, y: y))
        }
        configureChart()
        coinName.text = item.name
        let url = URL(string: item.image)
        icon.kf.setImage(with: url)
        price.text = "₩\(changeNumberFormat(number: item.current_price))"
        let sign = item.change_percentage >= 0 ? "+" : ""
        changePercentage.text = sign + String(format: "%.2f", item.change_percentage) + "%"
        changePercentage.textColor = item.change_percentage >= 0 ? .redForHigh : .blueForLow
        todayHighPrice.text = "₩\(changeNumberFormat(number: item.high))"
        todayLowPrice.text = "₩\(changeNumberFormat(number: item.low))"
        allTimeHighPrice.text = "₩\(changeNumberFormat(number: item.ath))"
        allTimeLowPrice.text = "₩\(changeNumberFormat(number: item.atl))"
        updateLabel.text = changeDateFormat(date: item.last_updated) + " 업데이트"
    }
    
    override func configureView() {
        icon.image = UIImage(systemName: "person")
        coinName.font = .boldSystemFont(ofSize: 32)
        price.font = .boldSystemFont(ofSize: 32)
        changePercentage.font = .systemFont(ofSize: 18)
        dateText.font = .systemFont(ofSize: 18)
        dateText.text = "Today"
        dateText.textColor = .customGray
        todayHighLabel.text = "고가"
        todayHighLabel.textColor = .redForHigh
        todayHighLabel.font = .boldSystemFont(ofSize: 20)
        todayHighPrice.textColor = .customLightBlack
        todayHighPrice.font = .systemFont(ofSize: 20)
        todayLowLabel.font = .boldSystemFont(ofSize: 20)
        todayLowLabel.text = "저가"
        todayLowLabel.textColor = .blueForLow
        todayLowPrice.textColor = .customLightBlack
        todayLowPrice.font = .systemFont(ofSize: 20)
        allTimeHighLabel.text = "신고점"
        allTimeHighLabel.textColor = .redForHigh
        allTimeHighLabel.font = .boldSystemFont(ofSize: 20)
        allTimeHighPrice.textColor = .customLightBlack
        allTimeHighPrice.font = .systemFont(ofSize: 20)
        allTimeLowLabel.text = "신저점"
        allTimeLowLabel.textColor = .blueForLow
        allTimeLowLabel.font = .boldSystemFont(ofSize: 20)
        allTimeLowPrice.textColor = .customLightBlack
        allTimeLowPrice.font = .systemFont(ofSize: 20)
        updateLabel.textColor = .customGray
        updateLabel.font = .boldSystemFont(ofSize: 14)
    }
    
    private func configureChart() {
        let dataSet = LineChartDataSet(entries: entries)
        //chart의 곡선
        dataSet.mode = LineChartDataSet.Mode.cubicBezier
        dataSet.mode = LineChartDataSet.Mode.horizontalBezier
        dataSet.cubicIntensity = 1.0
        //chart의 그라디언트 컬러 설정
        dataSet.gradientPositions = [0, 40, 100]
        dataSet.fillAlpha = 1
        dataSet.drawFilledEnabled = true
        let gradientColor = [UIColor.customWhite.cgColor, UIColor.primary.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColor as CFArray, locations: nil)!
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        //chart의 원 설정
        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        //chart의 line 설정
        dataSet.setColor(.primary)
        dataSet.lineWidth = 2
        //chart의 각 점의 값 표시 끄기
        dataSet.drawValuesEnabled = false
        dataSet.highlightEnabled = true
        //highlight 가로 세로선 색
        dataSet.highlightColor = .clear
        
        //dataSet 집어 넣기
        let data = LineChartData(dataSet: dataSet)
        chart.data = data
        chart.dragEnabled = true
        //zoom 허용 x
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false
        //chart line 제거
        chart.xAxis.drawGridLinesEnabled = false // 세로 줄 없애기
        chart.leftAxis.drawGridLinesEnabled = false // 가로 줄 없애기
        chart.rightAxis.drawGridLinesEnabled = false
        chart.xAxis.drawAxisLineEnabled = false // x축 제거
        chart.leftAxis.drawAxisLineEnabled = false // y축 제거
        chart.rightAxis.drawAxisLineEnabled = false
        chart.xAxis.drawLabelsEnabled = false // x축 데이터 레이블 값 제거
        chart.leftAxis.drawLabelsEnabled = false // y축 데이터 레이블 값 제거
        chart.rightAxis.drawLabelsEnabled = false
        //chart 범례 제거
        chart.legend.enabled = false
        //drag시 해당하는 좌표 하이라이트 기능
        chart.highlightPerTapEnabled = true
        chart.highlightPerDragEnabled = true
        chart.drawMarkers = true
        chart.gridBackgroundColor = .clear
        let circleMarker = CircleMarker(color: .primary)
        circleMarker.chartView = chart
        chart.marker = circleMarker
        //chart 실행시 에니메이션
        chart.animate(xAxisDuration: 1, easingOption: .easeInCubic)
    }
    
}

extension CoinChartView {
    private func changeNumberFormat(number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 7
        return formatter.string(from: number as NSNumber)!
    }
    
    private func changeDateFormat(date: String) -> String {
        let originFormat = DateFormatter()
        originFormat.dateFormat = "yyyy-MM-ddhh:mm:ss"
        let origin = originFormat.date(from: date) ?? Date()
        
        let targetFormat = DateFormatter()
        targetFormat.dateFormat = "MM/dd hh:mm:ss"
        let result = targetFormat.string(from: origin)
        return result
    }
}
