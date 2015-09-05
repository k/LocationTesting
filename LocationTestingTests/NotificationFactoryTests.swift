//
//  NotificationFactoryTests.swift
//  LocationTesting
//
//  Created by Kenneth Bambridge on 9/2/15.
//  Copyright (c) 2015 zoku. All rights reserved.
//

import UIKit
import XCTest
import CoreLocation

class NotificationFactoryTests: XCTestCase {
  
  
    override func setUp() {
        super.setUp()
  }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
  
  static func coordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(12.345, 67.8910)
  }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
  
  func testStringFromCoord() {
    let str = NotificationFactory.stringFromCoord(NotificationFactoryTests.coordinate())
    XCTAssert(str == "(12.345000, 67.891000)", "Coordinates string should be created properly")
  }
  
  func testStringFromRegion() {
    let region = CLCircularRegion(center: NotificationFactoryTests.coordinate(), radius: 50, identifier: "test")
    let str = NotificationFactory.stringFromRegion(region)
    XCTAssert(str == "Center: (12.345000, 67.891000), Radius: 50", "Region string should be created properly, but is: " + str)
  }
  
  func testStringFromVisit() {
    class MockVisit: CLVisit {
      override var coordinate:CLLocationCoordinate2D { get {
        return NotificationFactoryTests.coordinate()
        }
      }
      override var arrivalDate: NSDate { get {
        return NSDate()
        }
      }
      override var departureDate: NSDate { get {
        return NSDate.distantFuture() as! NSDate
        }
      }
    }
    class MockVisitDepSet: MockVisit {
      override var departureDate: NSDate { get {
        return NSDate().dateByAddingTimeInterval(60) as NSDate
        }
      }
    }
    let visit = MockVisit()
    let str1 = NotificationFactory.stringFromVisit(visit)
    let visit2 = MockVisitDepSet()
    let str2 = NotificationFactory.stringFromVisit(visit2)
    // TODO: Need a general way of testing date strings
  }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
