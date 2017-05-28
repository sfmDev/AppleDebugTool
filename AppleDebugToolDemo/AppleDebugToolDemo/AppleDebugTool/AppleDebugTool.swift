//
//  PrivateDebugTools.swift
//  rabbit
//
//  Created by PixelShi on 2017/5/27.
//  Copyright © 2017年 lychinahouse. All rights reserved.
//

import UIKit

enum debugToolsPosition {
    case topLeft
    case topRight
}

class AppleDebugTool: NSObject {

    var debugOpenBtn: UIButton?

    let screenWidth = UIScreen.main.bounds.size.width
    let debugAreaWidth: CGFloat = 60
    let debugToolsPadding: CGFloat = 57

    var debugToolsPos: debugToolsPosition = .topLeft {
        didSet {
            switch debugToolsPos {
            case .topLeft:
                self.debugOpenBtn?.frame = CGRect(x: (screenWidth - debugAreaWidth) / 2 - debugToolsPadding, y: 2.5, width: debugAreaWidth, height: 15)
            case .topRight:
                self.debugOpenBtn?.frame = CGRect(x: (screenWidth + debugAreaWidth) / 2 + debugToolsPadding, y: 2.5, width: debugAreaWidth, height: 15)
            }
        }
    }

    static let shared = AppleDebugTool()
    fileprivate override init() {
        super.init()
    }

    private func configDebugBtn() {
        self.debugOpenBtn = UIButton()
        self.debugOpenBtn?.tag = 1999
        self.debugOpenBtn?.addTarget(self.debugOpenBtn, action: #selector(AppleDebugTool.debugBtnTapped), for: .touchUpInside)
        self.debugOpenBtn?.setTitle("DEBUG", for: .normal)
        self.debugOpenBtn?.setTitleColor(UIColor.white, for: .normal)
        self.debugOpenBtn?.backgroundColor = UIColor.black
        self.debugOpenBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }

    func show() {
        self.configDebugBtn()
        let keyWindow = UIApplication.shared.keyWindow
        for btn in keyWindow!.subviews {
            if btn is UIButton && btn.tag == 1999 {
                return
            }
        }
        keyWindow?.addSubview(debugOpenBtn!)
    }

    func debugBtnTapped() {
        let overlayClass = NSClassFromString("UIDebuggingInformationOverlay") as? UIWindow.Type
        _ = overlayClass?.perform(NSSelectorFromString("prepareDebuggingOverlay"))
        let overlay = overlayClass?.perform(NSSelectorFromString("overlay")).takeUnretainedValue() as? UIWindow
        _ = overlay?.perform(NSSelectorFromString("toggleVisibility"))
    }
}

extension UIWindow {
    override open func layoutSubviews() {
        super.layoutSubviews()
        for btn in self.subviews {
            if btn is UIButton && btn.tag == 1999 {
                self.bringSubview(toFront: btn)
                return
            }
        }
    }
}
