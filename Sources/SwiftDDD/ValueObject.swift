/// A protocol that defines the requirements for implementing a value object in Domain-Driven Design.
///
/// Value objects are objects that represent descriptive aspects of the domain with no conceptual identity.
/// They are immutable and considered equal based on their attribute values rather than identity.
///
/// Use value objects to encapsulate attributes that are conceptually whole and follow value semantics.
/// For example, a `Money` type combining amount and currency, or an `Address` type combining street, city, and postal code.
///
/// Example:
/// ```swift
/// struct Money: ValueObject {
///     let amount: Decimal
///     let currency: Currency
///
///     func equals(_ other: Money) -> Bool {
///         return amount == other.amount && currency == other.currency
///     }
/// }
///
/// let price1 = Money(amount: 100, currency: .usd)
/// let price2 = Money(amount: 100, currency: .usd)
/// print(price1 == price2) // Prints: true
/// ```
public protocol ValueObject: Equatable {
    /// Determines whether two value objects are equal based on their attributes.
    ///
    /// - Parameter other: Another instance of the same value object type to compare against.
    /// - Returns: `true` if the value objects are considered equal, `false` otherwise.
    func equals(_ other: Self) -> Bool
}

/// Default implementation of the equality operator for `ValueObject`.
///
/// This implementation delegates to the required `equals(_:)` method,
/// providing a convenient way to compare value objects using the `==` operator.
public extension ValueObject {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.equals(rhs)
    }
} 