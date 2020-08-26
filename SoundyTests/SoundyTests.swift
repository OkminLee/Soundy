//
//  SoundyTests.swift
//  SoundyTests
//
//  Created by okmin lee on 2020/08/26.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import XCTest
import MediaPlayer
@testable import Soundy

class SoundyTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testGetMusics() throws {
        let expectation = XCTestExpectation()
        MPMediaLibrary.requestAuthorization { status in
            guard let medias = MPMediaQuery.songs().items else { return }
            for media in medias {
                print(media.albumArtist!.description, media.albumTitle!, media.artwork ?? "")
            }
            expectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(result, .completed)
    }
}
