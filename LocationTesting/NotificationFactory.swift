//
//  NotificationFactory.swift
//  LocationTesting
//
//  Created by Kenneth Bambridge on 9/2/15.
//  Copyright © 2015 zoku. All rights reserved.
//

import UIKit
import CoreLocation

class NotificationFactory {
  static func localNotifForSignificantChange(location: CLLocation) -> UILocalNotification {
    return localNotif("Significant Change", body: stringFromCoord(location.coordinate))
  }
  
  static func localNotifForVisit(visit: CLVisit) -> UILocalNotification {
    let title = (visit.departureDate.isEqualToDate(NSDate.distantFuture() as! NSDate)) ? "Visit Began": "Visit Ended"
    return localNotif(title ,body: stringFromVisit(visit) )
  }
  
  static func localNotifForRegionUpdate(region: CLCircularRegion, state: CLRegionState) -> UILocalNotification {
    return localNotif(stringFromRegionState(state) , body: stringFromRegion(region))
  }
  
  static func localNotif(title: String, body: String) -> UILocalNotification {
    let notif = UILocalNotification()
    notif.alertBody = body
    notif.alertTitle = title
    return notif
  }
  
  static func stringFromCoord(coordinate: CLLocationCoordinate2D) -> String {
    return String(format: "(%f, %f)", arguments: [coordinate.latitude, coordinate.longitude])
  }
  
  static func stringFromRegion(region: CLCircularRegion) -> String {
    return "Center: " + stringFromCoord(region.center) + ", " + String(format: "Radius: %.0f", arguments: [region.radius])
  }
  
  static func stringFromRegionState(state: CLRegionState) -> String {
    switch state {
    case .Inside:
      return "Entered Region"
    case .Outside:
      return "Exited Region"
    case .Unknown:
      return "Region State Unknown"
    }
  }
  
  static func dateFormater() -> NSDateFormatter {
    let df = NSDateFormatter()
    df.timeStyle = NSDateFormatterStyle.ShortStyle
    df.dateStyle = NSDateFormatterStyle.ShortStyle
    return df
  }
  
  static func stringFromVisit(visit: CLVisit) -> String {
    let f = dateFormater()
    return stringFromCoord(visit.coordinate) + " Arrival:" + f.stringFromDate(visit.arrivalDate) + " Departure: " + f.stringFromDate(visit.departureDate)
  }
}
