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

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var memberContainerView: UIView!
    @IBOutlet weak var chartScrollView: UIScrollView!

    var lineChartView: LineChartView!
    var lineChartData: ChartData?

    var isChartLoading: Bool = false
    
    @IBOutlet weak var tempTextView: UITextView!

    var memberCollectionVC: MemberCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = DZDUser.currentUser()?.username!
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isChartLoading == false {
            loadChartView()
        }
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
        }
        
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)!
    }
    
    // MARK :- chart

    private func fetchChartData() -> BFTask {
        
        return DZDDataCenter.getAllWeights().continueWithSuccessBlock { (task) -> AnyObject! in
            if let groupedWeights = task.result as? [DZDUser:[DZDWeight]] {
                var dataSets: [LineChartDataSet] = []
                for (user, weights) in groupedWeights {
                    let dataEntries = weights.map() { return DZDWeightChartDataEntry(weightData: $0) }
                    let dataSet = LineChartDataSet(dataEntries: dataEntries)
                    dataSet.color = DZDData.getColor(user)
                    dataSets += [dataSet]
                }
                let data = ChartData(dataSets: dataSets)
                return BFTask(result: data)
            }
            return nil
        }
        
//        return DZDDataCenter.getWeights().continueWithSuccessBlock { (task) -> AnyObject! in
//            if let weights = task.result as? [DZDWeight] {
//                let weightsChartDataEntries = weights.map() { return DZDWeightChartDataEntry(weightData: $0) }
//                let dataSet = LineChartDataSet(dataEntries: weightsChartDataEntries)
//                let data = ChartData(dataSet: dataSet)
//                return BFTask(result: data)
//            }
//            return nil
//        }
    }
    
    func loadChartView() {
        isChartLoading = true
        if lineChartView == nil {
            let lineChartframe = CGRect(origin: CGPoint.zero, size: chartScrollView.frame.size)
            lineChartView = LineChartView(frame: lineChartframe)
            chartScrollView.contentSize.width = lineChartView.frame.size.width
            chartScrollView.addSubview(lineChartView)
        }
        
//        if lineChartData != nil {
//            lineChartView.data = lineChartData!
//        }
        
        fetchChartData().continueWithSuccessBlock { (task) -> AnyObject! in
            if let chartData = task.result as? ChartData {
                self.lineChartData = chartData
                self.lineChartView.data = chartData
                self.chartScrollView.contentSize.width = self.lineChartView.frame.size.width
                dispatch_async(dispatch_get_main_queue()) {
                    self.lineChartView.setNeedsDisplay()
                    self.isChartLoading = false
                }
            }
            return nil
        }
    }

}
