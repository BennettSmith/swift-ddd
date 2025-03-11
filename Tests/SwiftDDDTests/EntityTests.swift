import Testing
@testable import SwiftDDD

@Suite("Entity Tests")
struct EntityTests {
    struct TestEntity: Entity {
        let id: Identifier<Self>
        let name: String
    }
    
    @Test("Entities with same ID should be equal")
    func testEntityEquality() throws {
        let id = Identifier<TestEntity>()
        let entity1 = TestEntity(id: id, name: "Test 1")
        let entity2 = TestEntity(id: id, name: "Test 2")
        
        #expect(entity1 == entity2)
    }
    
    @Test("Entities with different IDs should not be equal")
    func testEntityInequality() throws {
        let entity1 = TestEntity(id: Identifier(), name: "Test")
        let entity2 = TestEntity(id: Identifier(), name: "Test")
        
        #expect(entity1 != entity2)
    }
} 
