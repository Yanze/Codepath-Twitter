//
//  SideBar.swift
//  SideMenu3
//
//  Created by yanze on 4/20/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit


@objc protocol SideBardelegate {
    func sideBarDidSelecteButtonAtIndex(_ index: Int)
    @objc optional func sideBarWillClose()
    @objc optional func sideBarWillOpen()
    func sideBarModeChanged(_ mode: Bool)
}


class SideBar: NSObject, SideBarTableViewControllerDelegate {
    
    let barWidth: CGFloat = 150.0
    let sideBarTableViewTopInset: CGFloat = 64.0
    let sideBarContainerView: UIView = UIView()
    let sideBarTableViewController: SideBarTableViewController = SideBarTableViewController()
    
    var originView: UIView!
    var animator: UIDynamicAnimator!
    var delegate: SideBardelegate?
    var isSideBarOpen: Bool = false
    
    
    override init() {
        super.init()
    }
    
    init(sourceView:UIView, menuItems:Array<String>){
        super.init()
        originView = sourceView
        sideBarTableViewController.tableData = menuItems
        
        setupSideBar()
        
        animator = UIDynamicAnimator(referenceView: originView)
        
        let showGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SideBar.handleSwipe(_:)))
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        originView.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SideBar.handleSwipe(_:)))
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        originView.addGestureRecognizer(hideGestureRecognizer)
        
    }
    
    
    func sideBarControlDidSelectRow(indexPath: IndexPath) {
        delegate?.sideBarDidSelecteButtonAtIndex(indexPath.row)
    }
    
    func setupSideBar() {
        sideBarContainerView.frame = CGRect(x: -barWidth - 1, y: 50, width: barWidth, height: originView.frame.size.height)
        sideBarContainerView.backgroundColor = UIColor(red: 62/255, green: 174/255, blue: 242/255, alpha: 1)
        sideBarContainerView.clipsToBounds = false
        
        originView.addSubview(sideBarContainerView)
      
        sideBarTableViewController.delegate = self
        sideBarTableViewController.tableView.frame = sideBarContainerView.bounds
        sideBarTableViewController.tableView.clipsToBounds = false
        sideBarTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        sideBarTableViewController.tableView.backgroundColor = UIColor.clear
        sideBarTableViewController.tableView.scrollsToTop  = false
        sideBarTableViewController.tableView.contentInset = UIEdgeInsetsMake(sideBarTableViewTopInset, 0, 0, 0)
        
        sideBarTableViewController.tableView.reloadData()
        
        sideBarContainerView.addSubview(sideBarTableViewController.tableView)
    }
    
    func handleSwipe(_ regonizer: UISwipeGestureRecognizer) {
        if regonizer.direction == UISwipeGestureRecognizerDirection.left{
            showSidebar(false)
            delegate?.sideBarWillClose?()
            
        }else{
            showSidebar(true)
            delegate?.sideBarWillOpen?()
        }
    }
    
    func showSidebar(_ shouldOpen: Bool) {
        animator.removeAllBehaviors()
        isSideBarOpen = shouldOpen
        delegate?.sideBarModeChanged(shouldOpen)
        
        let gravityX:CGFloat = (shouldOpen) ? 0.5 : -0.5
        let magnitude:CGFloat = (shouldOpen) ? 20 : -20
        let boundaryX:CGFloat = (shouldOpen) ? barWidth : -barWidth - 1
        
        let gravityBehavior = UIGravityBehavior(items: [sideBarContainerView])
        gravityBehavior.gravityDirection = CGVector(dx: gravityX, dy: 0)
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: [sideBarContainerView])
        collisionBehavior.addBoundary(withIdentifier: "sideBarBoundary" as NSCopying, from: CGPoint(x: boundaryX, y: 22), to: CGPoint(x: boundaryX, y: originView.frame.size.height))
        animator.addBehavior(collisionBehavior)
        
        let pushBehavior:UIPushBehavior = UIPushBehavior(items: [sideBarContainerView], mode: UIPushBehaviorMode.instantaneous)
        pushBehavior.magnitude = magnitude
        animator.addBehavior(pushBehavior)
        
        let sideBarBehavior:UIDynamicItemBehavior = UIDynamicItemBehavior(items: [sideBarContainerView])
        sideBarBehavior.elasticity = 0.3
        animator.addBehavior(sideBarBehavior)
        
    }
    
    func removeFromView() {
        sideBarContainerView.removeFromSuperview()
    }

}
