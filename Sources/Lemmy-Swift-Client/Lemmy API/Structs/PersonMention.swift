import Foundation

public struct PersonMention: Codable {
	public let comment_id: Int
	public let id: Int
	public let published: Date
	public let read: Bool
	public let recipient_id: Int
}
