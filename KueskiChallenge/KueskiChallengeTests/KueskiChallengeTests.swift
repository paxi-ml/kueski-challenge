//
//  KueskiChallengeTests.swift
//  KueskiChallengeTests
//
//  Created by Alexander Coto on 7/3/24.
//

import XCTest
@testable import KueskiChallenge

final class KueskiChallengeTests: XCTestCase {

    override func setUpWithError() throws {
        _ = MovieService.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //The following are only to test our parsing, if there are breaking changes on the API those should be covered by the API tests. It is not recommended to
    func testConfigurationParsing() throws {
        MovieServiceMock.shared.fetchConfiguration {
            assert(MovieService.shared.configurationBaseUrl?.absoluteString == "https://image.tmdb.org/t/p/", "Extracting secure base url for images from configuration file failed.")
        }
    }
    
    func testMovieParsing() throws {
        MovieServiceMock.shared.fetchMostPopular { page in
            assert(page?.currentPage == 1, "Page number from movie page mock response is incorrect.")
            assert(page?.totalPages == 42882, "Total number of pages from movie page mock response is incorrect.")
            assert(page?.movies.count == 2, "Failed parsing all movie objects in the mock response.")
            
            // We will only evaluate the first one, might be a good idea to do first and last one too, but...time.
            let firstMovie = page?.movies.first
            assert(firstMovie?.id == 1096197, "ID not parsed correctly")
            assert(firstMovie?.title == "No Way Up" , "Title not parsed correctly.")
            assert(firstMovie?.overview == "Characters from different backgrounds are thrown together when the plane they're travelling on crashes into the Pacific Ocean. A nightmare fight for survival ensues with the air supply running out and dangers creeping in from all sides.", "Overview not parsed correctly.")
            assert(firstMovie?.popularity == 1480.125, "Popularity not parsed correctly.")
            assert(firstMovie?.voteAverage == 5.733, "Vote average not parsed correctly.")
            assert(firstMovie?.genreIds?.contains(27) ?? false &&
                   firstMovie?.genreIds?.contains(28) ?? false &&
                   firstMovie?.genreIds?.contains(53) ?? false, "Genre ids not parsed correctly.")
            assert(firstMovie?.releaseDateString == "2024-01-18", "Release date not parsed correctly.")
            assert(firstMovie?.posterPath == "/hu40Uxp9WtpL34jv3zyWLb5zEVY.jpg", "Poster path not parsed correctly")
        }
    }
}
