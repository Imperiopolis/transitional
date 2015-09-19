//
//  ExampleViewController.swift
//  Example
//
//  Created by Nora Trapp on 6/23/15.
//
//

import UIKit
import Transitional

extension UIColor {
    class func randomColor() -> UIColor {
        let hue = CGFloat(arc4random_uniform(256)) / 256
        let saturation = CGFloat(arc4random_uniform(128)) / 128 + 0.5
        let brightness = CGFloat(arc4random_uniform(128)) / 128 + 0.5

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}

private enum SectionType: Int, CustomStringConvertible {
    case Present
    case Dismiss
    case Push
    case Pop
    
    var description: String {
        switch self {
        case .Present:
            return "Present"
        case .Dismiss:
            return "Dismiss"
        case .Push:
            return "Push"
        case .Pop:
            return "Pop"
        }
    }
}

class ExampleViewController: UITableViewController {
    
    private var sections = [SectionType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .randomColor()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if sections.count == 0 {
            if navigationController?.viewControllers.count > 1 {
                sections.append(.Pop)
            }
            
            sections.append(.Push)
            
            if presentingViewController != nil {
                sections.append(.Dismiss)
            }
            
            sections.append(.Present)
            
            tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].description
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = TransitionalAnimationStyle(rawValue: indexPath.row)?.description
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = sections[indexPath.section]
        let style = TransitionalAnimationStyle(rawValue: indexPath.row)!
        let toVC = ExampleViewController()
        
        switch section {
        case .Present:
            transitionalPresentation(UINavigationController(rootViewController: toVC), style: style)
        case .Dismiss:
            transitionalDismissal(style)
        case .Push:
            transitionalPush(toVC, style: style)
        case .Pop:
            transitionalPop(style)
        }
    }
    
}

private func dispatchAfter(time: NSTimeInterval, block: dispatch_block_t) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue(), block)
}
