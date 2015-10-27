//
//  ChartViewController.swift
//  DZD2
//
//  Created by 竹田 on 2015/9/30.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit
import Bolts

class ChartViewController: UIViewController {

    @IBOutlet weak var memberContainerView: UIView!
    @IBOutlet weak var chartScrollView: UIScrollView!

    var lineChartView: LineChartView!
    var lineChartData: ChartData?

    var screenshotImage: UIImage?

    var memberCollectionVC: MemberCollectionViewController?
    
    @IBOutlet weak var chartTypeLabel: UILabel!
    var chartType: DZDChartType = .Weight {
        didSet {
            chartTypeLabel.text = chartType.rawValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        initChartViewIfNil()
        
//        DZDDataCenter.getAllCalories(.Food).continueWithSuccessBlock { (task) -> AnyObject! in
//            if let groupedCalories = task.result as? [DZDUser:[DZDDataObject]] {
//                for (user, calories) in groupedCalories {
//                    print(user)
//                    print(calories)
//                    print("-----")
//                }
//            }
//            return nil
//        }
        
        loadChartView(chartType)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        screenshotImage = view.toUIImage()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier ?? ""
        switch identifier {
        case DZDSegue.ShowMemberCollectionView:
            if let vc = segue.destinationViewController as? MemberCollectionViewController {
                self.memberCollectionVC = vc
            }
        case DZDSegue.ChartToChatSegue:
            let offset = memberCollectionVC?.memberCollectionView.contentOffset.x
            DZDData.memberCollectionViewoffsetX = offset!
        default:
            break
        }
    }
 
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
        
    }
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier {
            if id == DZDSegue.ChatToChartSegue {
                let unwindSegue = ChatToChartSegue(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                })
                return unwindSegue
            }
            if id == DZDSegue.ChooseChartTypeSegueUnwind {
                let unwindSegue = ChooseChartTypeSegueUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)!
    }
    
    // MARK :- chart
    
    func initChartViewIfNil() {
        if lineChartView == nil {
            let lineChartframe = CGRect(origin: CGPoint.zero, size: chartScrollView.frame.size)
            lineChartView = LineChartView(frame: lineChartframe)
            chartScrollView.contentSize.width = lineChartView.frame.size.width
            chartScrollView.addSubview(lineChartView)
        }
    }
    
    func loadChartView(chartType: DZDChartType) -> BFTask {
        return fetchChartData(chartType).continueWithSuccessBlock { (task) -> AnyObject! in
            if let chartData = task.result as? ChartData {
                self.lineChartData = chartData
                self.lineChartView.data = chartData
                self.chartScrollView.contentSize.width = self.lineChartView.frame.size.width
                dispatch_async(dispatch_get_main_queue()) {
                    self.lineChartView.setNeedsDisplay()
                }
            }
            return nil
        }
    }

    private func fetchChartData(chartType: DZDChartType) -> BFTask {
        var fetchChartDataTask: BFTask

        switch (chartType) {
        case .Weight:
            fetchChartDataTask = DZDDataCenter.getAllWeights()
        case .Food:
            fetchChartDataTask = DZDDataCenter.getAllCalories(.Food)
        case .Exercise:
            fetchChartDataTask = DZDDataCenter.getAllCalories(.Exercise)
        }
        
        return fetchChartDataTask.continueWithSuccessBlock { (task) -> AnyObject! in
            if let groupedObjects = task.result as? [DZDUser:[DZDDataObject]] {
                var dataSets: [LineChartDataSet] = []
                for (user, objects) in groupedObjects {
                    let dataEntries = objects.map() { return DZDChartDataEntry(dataObject: $0) }
                    let dataSet = LineChartDataSet(dataEntries: dataEntries)
                    dataSet.color = DZDData.getColor(user)
                    dataSets += [dataSet]
                }
                let data = ChartData(dataSets: dataSets)
                print(data)
                return BFTask(result: data)
            }
            return nil
        }
    }

}
