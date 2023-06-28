//
//  LocalUserSettings.swift
//
//
//  Created by Charlie Fish on 6/11/23.
//

import Foundation

public struct LocalUserSettings: Codable {
	public let accepted_application: Bool
	public let default_listing_type: ListingType
	public let default_sort_type: SortType
	public let email: String?
	public let email_verified: Bool
	public let id: Int
	public let interface_language: String
	public let person_id: Int
	public let send_notifications_to_email: Bool
	public let show_avatars: Bool
	public let show_bot_accounts: Bool
	public let show_new_post_notifs: Bool
	public let show_nsfw: Bool
	public let show_read_posts: Bool
	public let show_scores: Bool
	public let theme: String
	public let validator_time: String

	public init(accepted_application: Bool, default_listing_type: ListingType, default_sort_type: SortType, email: String? = nil, email_verified: Bool, id: Int, interface_language: String, person_id: Int, send_notifications_to_email: Bool, show_avatars: Bool, show_bot_accounts: Bool, show_new_post_notifs: Bool, show_nsfw: Bool, show_read_posts: Bool, show_scores: Bool, theme: String, validator_time: String) {
		self.accepted_application = accepted_application
		self.default_listing_type = default_listing_type
		self.default_sort_type = default_sort_type
		self.email = email
		self.email_verified = email_verified
		self.id = id
		self.interface_language = interface_language
		self.person_id = person_id
		self.send_notifications_to_email = send_notifications_to_email
		self.show_avatars = show_avatars
		self.show_bot_accounts = show_bot_accounts
		self.show_new_post_notifs = show_new_post_notifs
		self.show_nsfw = show_nsfw
		self.show_read_posts = show_read_posts
		self.show_scores = show_scores
		self.theme = theme
		self.validator_time = validator_time
	}
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accepted_application = try container.decode(Bool.self, forKey: .accepted_application)
        
        do {
            self.default_listing_type = try container.decode(ListingType.self, forKey: .default_listing_type)
        } catch {
            let old = try container.decode(Int.self, forKey: .default_listing_type)
            switch old {
            case 1:
                self.default_listing_type = .local
            case 2:
                self.default_listing_type = .subscribed
            case 3:
                self.default_listing_type = .community
            default:
                self.default_listing_type = .all
            }
        }
        
        do {
            self.default_sort_type = try container.decode(SortType.self, forKey: .default_sort_type)
        } catch {
            let old = try container.decodeIfPresent(Int.self, forKey: .default_sort_type)
            switch old {
            case 1:
                self.default_sort_type = .hot
            case 9:
                self.default_sort_type = .mostComments
            case 2:
                self.default_sort_type = .new
            case 10:
                self.default_sort_type = .newComments
            case 3:
                self.default_sort_type = .old
            case 8:
                self.default_sort_type = .topAll
            case 4:
                self.default_sort_type = .topDay
            case 6:
                self.default_sort_type = .topMonth
            case 5:
                self.default_sort_type = .topWeek
            case 7:
                self.default_sort_type = .topYear
            case 0:
                self.default_sort_type = .active
            default:
                throw error
            }
        }
        
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.email_verified = try container.decode(Bool.self, forKey: .email_verified)
        self.id = try container.decode(Int.self, forKey: .id)
        self.interface_language = try container.decode(String.self, forKey: .interface_language)
        self.person_id = try container.decode(Int.self, forKey: .person_id)
        self.send_notifications_to_email = try container.decode(Bool.self, forKey: .send_notifications_to_email)
        self.show_avatars = try container.decode(Bool.self, forKey: .show_avatars)
        self.show_bot_accounts = try container.decode(Bool.self, forKey: .show_bot_accounts)
        self.show_new_post_notifs = try container.decode(Bool.self, forKey: .show_new_post_notifs)
        self.show_nsfw = try container.decode(Bool.self, forKey: .show_nsfw)
        self.show_read_posts = try container.decode(Bool.self, forKey: .show_read_posts)
        self.show_scores = try container.decode(Bool.self, forKey: .show_scores)
        self.theme = try container.decode(String.self, forKey: .theme)
        self.validator_time = try container.decode(String.self, forKey: .validator_time)
    }
}
