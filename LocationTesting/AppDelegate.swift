//
//  AppDelegate.swift
//  LocationTesting
//
//  Created by Kenneth Bambridge on 9/1/15.
//  Copyright © 2015 zoku. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

  var window: UIWindow?
  let locationManager = CLLocationManager();


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    
    application .registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert, categories: nil))
    
    if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
      startMonitoringLocation()
    }
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func startMonitoringLocation() {
    locationManager.startMonitoringSignificantLocationChanges()
    locationManager.startMonitoringVisits()
  }
  
  // MARK: CLLocationManagerDelegate functions
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if (status != CLAuthorizationStatus.AuthorizedAlways) {
      UIApplication.sharedApplication().presentLocalNotificationNow(NotificationFactory.localNotif("Need to allow location always", body: "Go to Settings -> Privacy -> Location and update LocationTesting to \"Always\""))
    } else {
      self.startMonitoringLocation()
    }
  }
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    UIApplication.sharedApplication().presentLocalNotificationNow( NotificationFactory.localNotifForSignificantChange(locations.last as! CLLocation))
  }
  
  func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
    UIApplication.sharedApplication().presentLocalNotificationNow(NotificationFactory.localNotifForRegionUpdate(region as! CLCircularRegion, state: CLRegionState.Inside))
  }
  
  func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
    manager.stopMonitoringForRegion(region)
    UIApplication.sharedApplication().presentLocalNotificationNow(NotificationFactory.localNotifForRegionUpdate(region as! CLCircularRegion, state: CLRegionState.Outside))
  }
  
  func locationManager(manager: CLLocationManager, didVisit visit: CLVisit) {
    UIApplication.sharedApplication().presentLocalNotificationNow(NotificationFactory.localNotifForVisit(visit))
    if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
      UIApplication.sharedApplication().presentLocalNotificationNow( NotificationFactory.localNotif("Region Monitoring not available", body: "Region monitoring is not available on this device"))
      return;
    }
    let region = CLCircularRegion(center: visit.coordinate, radius: 30, identifier: "Visit Exit Region")
    manager.startMonitoringForRegion(region)
  }

}

