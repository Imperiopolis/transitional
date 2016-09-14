//
//  ExampleViewController.swift
//  Example
//
//  Created by Nora Trapp on 6/23/15.
//
//

import UIKit
import Transitional
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


extension UIColor {
    class func randomColor() -> UIColor {
        let hue = CGFloat(arc4random_uniform(256)) / 256
        let saturation = CGFloat(arc4random_uniform(128)) / 128 + 0.5
        let brightness = CGFloat(arc4random_uniform(128)) / 128 + 0.5

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}

private enum SectionType: Int, CustomStringConvertible {
    case present
    case dismiss
    case push
    case pop
    
    var description: String {
        switch self {
        case .present:
            return "Present"
        case .dismiss:
            return "Dismiss"
        case .push:
            return "Push"
        case .pop:
            return "Pop"
        }
    }
}

class ExampleViewController: UITableViewController {
    
    fileprivate var sections = [SectionType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .randomColor()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if sections.count == 0 {
            if navigationController?.viewControllers.count > 1 {
                sections.append(.pop)
            }
            
            sections.append(.push)
            
            if presentingViewController != nil {
                sections.append(.dismiss)
            }
            
            sections.append(.present)
            
            tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].description
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = TransitionalAnimationStyle(rawValue: (indexPath as NSIndexPath).row)?.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[(indexPath as NSIndexPath).section]
        let style = TransitionalAnimationStyle(rawValue: (indexPath as NSIndexPath).row)!
        let toVC = ExampleViewController()
        
        switch section {
        case .present:
            transitionalPresentation(UINavigationController(rootViewController: toVC), style: style)
        case .dismiss:
            transitionalDismissal(style)
        case .push:
            transitionalPush(toVC, style: style)
        case .pop:
            transitionalPop(style)
        }
    }
    
}

private func dispatchAfter(_ time: TimeInterval, block: @escaping ()->()) {
    let time = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: time, execute: block)
}
