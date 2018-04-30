//
//  AppDelegate.swift
//  Brght
//
//  Created by Calvin on 4/16/18.
//  Copyright © 2018 Calvin Huang. All rights reserved.
//  With help from: Koen. @ StackOverflow
//                  Magesh @ StackOverflow

import Cocoa

struct KeepTrack {
    static var brightnessWhenPluggedIn = 0.6
    static var brightnessWhenNotPluggedIn = 0.45
}

func PowerSourceChanged(context: UnsafeMutableRawPointer?) {

    print("checking power source...")
    
    func setBrightness(level: Float) {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"))
        
        IODisplaySetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, level)
        IOObjectRelease(service)
    }
    
    if (!(IOPSCopyExternalPowerAdapterDetails() != nil)) {
        print("not plugged in")
        
        setBrightness(level: Float(KeepTrack.brightnessWhenNotPluggedIn))
    }
    else {
        print("plugged in")
        
        setBrightness(level: Float(KeepTrack.brightnessWhenPluggedIn))
    }

}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var switchedPower = false
    let popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.action = #selector(togglePopover(_:))
        }
        popover.contentViewController = PrefViewController.freshController()
        
        let opaque = Unmanaged.passRetained(self).toOpaque()
        let context = UnsafeMutableRawPointer(opaque)
        let loop: CFRunLoopSource = IOPSNotificationCreateRunLoopSource(
            PowerSourceChanged,
            context
            ).takeRetainedValue() as CFRunLoopSource
        CFRunLoopAddSource(CFRunLoopGetCurrent(), loop, CFRunLoopMode.defaultMode)


    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func powerSourceChanged() {
        print("brightness set")
    }

    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
    
}


