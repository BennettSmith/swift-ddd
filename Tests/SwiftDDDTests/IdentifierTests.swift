import Foundation
import Testing
@testable import SwiftDDD

@Suite("Identifier Tests")
struct IdentifierTests {
    @Test("Identifier should be created with a specific value")
    func testIdentifierCreationWithValue() throws {
        let uuid = try #require(UUID(uuidString: "4e1f353b-9b73-443a-9b5c-5e0224445c0f"))
        let id = Identifier<Any>(uuid)
        #expect(id.value == uuid)
    }
    
    @Test("Identifier should be created with a UUID when no value is provided")
    func testIdentifierCreationWithUUID() throws {
        let _ = Identifier<Any>()
    }
    
    @Test("Identifiers should be equatable")
    func testIdentifierEquality() throws {
        let uuid1 = try #require(UUID(uuidString: "1583367a-136a-4618-910c-b2c69e6ff2f8"))
        let uuid2 = try #require(UUID(uuidString: "4e5d98a1-2120-4d6d-a5a9-724003165253"))
        let id1 = Identifier<Any>(uuid1)
        let id2 = Identifier<Any>(uuid1)
        let id3 = Identifier<Any>(uuid2)
        
        #expect(id1 == id2)
        #expect(id1 != id3)
    }
}
