import Foundation

/// A protocol that defines the requirements for domain events in Domain-Driven Design.
///
/// Domain events represent something significant that has occurred within the domain.
/// They are typically used to notify other parts of the system about changes in an aggregate
/// and to maintain an audit trail of business-significant operations.
///
/// Example:
/// ```swift
/// // First, define an Order aggregate root
/// struct Order: AggregateRoot {
///     typealias ID = Identifier<Order>
///     
///     let id: ID
///     private(set) var items: [OrderItem]
///     private(set) var status: OrderStatus
///     private(set) var domainEvents: [OrderEvent] = []
///     
///     init(id: ID = ID(), items: [OrderItem] = []) {
///         self.id = id
///         self.items = items
///         self.status = .pending
///     }
///     
///     mutating func addItem(_ item: OrderItem) {
///         items.append(item)
///         domainEvents.append(OrderItemAddedEvent(orderId: id, item: item))
///     }
///     
///     mutating func clearDomainEvents() {
///         domainEvents.removeAll()
///     }
/// }
///
/// // Then define the domain event for adding items
/// struct OrderItemAddedEvent: DomainEvent {
///     typealias AggregateID = Order.ID
///     
///     let aggregateId: AggregateID
///     let occurredOn: Date
///     let item: OrderItem
///     
///     init(orderId: AggregateID, item: OrderItem) {
///         self.aggregateId = orderId
///         self.occurredOn = Date()
///         self.item = item
///     }
/// }
///
/// // Usage example
/// var order = Order()
/// let item = OrderItem(productId: "123", quantity: 2)
/// order.addItem(item)
///
/// // The event can be processed elsewhere in the system
/// let event = order.domainEvents.first as! OrderItemAddedEvent
/// print(event.aggregateId) // Prints: "Order.550e8400-e29b-41d4-a716-446655440000"
/// ```
public protocol DomainEvent {
    /// The type of identifier used by the aggregate that generated this event.
    associatedtype AggregateID

    /// The identifier of the aggregate that generated this event.
    ///
    /// This allows tracking which specific aggregate instance was responsible
    /// for generating the event.
    var aggregateId: AggregateID { get }

    /// The timestamp when this event occurred.
    ///
    /// This is typically used for event ordering, auditing, and debugging purposes.
    var occurredOn: Date { get }
}

/// A structure that contains metadata about a domain event.
///
/// This type provides additional context and tracking information for domain events,
/// which can be useful for event sourcing, audit trails, and debugging.
///
/// Example:
/// ```swift
/// let event = OrderItemAddedEvent(orderId: order.id, item: item)
/// let metadata = EventMetadata(eventType: String(describing: type(of: event)))
/// // Store or process both event and its metadata
/// ```
public struct EventMetadata {
    /// A unique identifier for this event instance.
    public let eventId: String

    /// The timestamp when this event occurred.
    public let occurredOn: Date

    /// The type name of the event.
    ///
    /// This is typically used for event deserialization and logging purposes.
    public let eventType: String
    
    /// Creates a new instance of event metadata.
    ///
    /// - Parameters:
    ///   - eventId: A unique identifier for the event. Defaults to a new UUID string.
    ///   - occurredOn: The timestamp when the event occurred. Defaults to the current date and time.
    ///   - eventType: The type name of the event.
    public init(eventId: String = UUID().uuidString,
                occurredOn: Date = Date(),
                eventType: String) {
        self.eventId = eventId
        self.occurredOn = occurredOn
        self.eventType = eventType
    }
} 
