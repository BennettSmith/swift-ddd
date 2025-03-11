import Foundation

/// A protocol that defines the requirements for implementing an entity in Domain-Driven Design.
///
/// Entities are objects that have a distinct identity that runs through time and different states.
/// They are primarily distinguished by their identifier rather than their attributes.
///
/// Use entities when object identity matters, such as when you need to track or reference specific
/// instances across state changes. Common examples include users, orders, or accounts.
///
/// Example:
/// ```swift
/// struct User: Entity {
///     typealias ID = Identifier<User>
///     
///     let id: ID
///     var name: String
///     var email: String
///     
///     init(id: ID = ID(), name: String, email: String) {
///         self.id = id
///         self.name = name
///         self.email = email
///     }
/// }
///
/// // Identity is based on id, not on properties
/// let user1 = User(id: .init(), name: "John", email: "john@example.com")
/// var user2 = user1
/// user2.name = "John Doe"
/// 
/// print(user1 == user2) // Prints: true (same identity)
/// print(user1.id)       // Prints: "User.550e8400-e29b-41d4-a716-446655440000"
/// ```
public protocol Entity: Identifiable, Equatable where ID: Hashable {
    /// The unique identifier of the entity.
    ///
    /// This property is used to establish the identity of the entity and
    /// must remain constant throughout the entity's lifecycle.
    var id: ID { get }
}

/// Default implementation of the equality operator for `Entity`.
///
/// This implementation compares entities based on their identifiers,
/// following the DDD principle that two entities are equal if they have the same identity,
/// regardless of their attributes.
public extension Entity {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
} 
