import Foundation

/// A generic identifier type that provides type-safe IDs for domain objects.
///
/// `Identifier` wraps a UUID value and associates it with a specific type `T`,
/// ensuring that identifiers for different types cannot be accidentally mixed up
/// at compile time.
///
/// The type conforms to `Hashable`, `Equatable`, `Codable`, and `Sendable`,
/// making it suitable for use in collections, persistence, and concurrent contexts.
///
/// Example:
/// ```swift
/// struct User {
///     typealias ID = Identifier<User>
///     let id: ID
///     let name: String
/// }
///
/// let userId = User.ID()  // Creates a new unique identifier
/// let user = User(id: userId, name: "John")
///
/// // Type safety prevents mixing different types of IDs
/// struct Order {
///     typealias ID = Identifier<Order>
///     let id: ID  // Cannot accidentally use a User.ID here
/// }
/// ```
public struct Identifier<T>: Hashable, Equatable, Codable, Sendable {
    /// The underlying UUID value that serves as the actual identifier.
    public let value: UUID
    
    /// Creates an identifier with a specific UUID value.
    ///
    /// - Parameter value: The UUID to use as the identifier value.
    public init(_ value: UUID) {
        self.value = value
    }
    
    /// Creates a new identifier with a randomly generated UUID.
    public init() {
        self.value = UUID()
    }
}

/// Provides a string representation of the identifier that includes both
/// the type name and the UUID string.
extension Identifier: CustomStringConvertible {
    /// A string representation of the identifier in the format "TypeName.UUID".
    ///
    /// Example: "User.550e8400-e29b-41d4-a716-446655440000"
    public var description: String {
        "\(String(describing: T.self)).\(value.uuidString)"
    }
}
