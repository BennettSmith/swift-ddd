import Foundation
import Testing
@testable import SwiftDDD

@Suite("Value Object Tests")
struct ValueObjectTests {
    struct Money: ValueObject {
        let amount: Decimal
        let currency: String
        
        func equals(_ other: Money) -> Bool {
            amount == other.amount && currency == other.currency
        }
    }
    
    @Test("Value objects with same values should be equal")
    func testValueObjectEquality() throws {
        let money1 = Money(amount: 100, currency: "USD")
        let money2 = Money(amount: 100, currency: "USD")
        
        #expect(money1 == money2)
    }
    
    @Test("Value objects with different values should not be equal")
    func testValueObjectInequality() throws {
        let money1 = Money(amount: 100, currency: "USD")
        let money2 = Money(amount: 100, currency: "EUR")
        
        #expect(money1 != money2)
    }
} 
