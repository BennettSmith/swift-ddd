import Foundation
import Testing
@testable import SwiftDDD

@Suite("Domain Event Tests")
struct DomainEventTests {
    struct TestEvent: DomainEvent {
        typealias AggregateID = Identifier<String>
        let aggregateId: AggregateID
        let occurredOn: Date
        let data: String
    }
    
    @Test("Domain event should contain required metadata")
    func testDomainEventMetadata() throws {
        let now = Date()
        let aggregateId = Identifier<String>()
        let event = TestEvent(aggregateId: aggregateId, occurredOn: now, data: "test")
        
        #expect(event.aggregateId == aggregateId)
        #expect(event.occurredOn == now)
    }
    
    @Test("Event metadata should generate unique IDs")
    func testEventMetadataUniqueness() throws {
        let metadata1 = EventMetadata(eventType: "TestEvent")
        let metadata2 = EventMetadata(eventType: "TestEvent")
        
        #expect(metadata1.eventId != metadata2.eventId)
    }
} 
