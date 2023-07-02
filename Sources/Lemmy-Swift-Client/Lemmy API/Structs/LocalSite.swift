//
//  LocalSite.swift
//
//
//  Created by Charlie Fish on 6/11/23.
//

import Foundation

public struct LocalSite: Codable {
	public let actor_name_max_length: Int
	public let application_email_admins: Bool
	public let application_question: String?
	public let captcha_difficulty: String
	public let captcha_enabled: Bool
	public let community_creation_admin_only: Bool
	public let default_post_listing_type: String
	public let default_theme: String
	public let enable_downvotes: Bool
	public let enable_nsfw: Bool
	public let federation_debug: Bool?
	public let federation_enabled: Bool
	public let federation_worker_count: Int?
	public let hide_modlog_mod_names: Bool
	public let id: Int
	public let legal_information: String?
	public let private_instance: Bool
	public let published: Date
	public let registration_mode: RegistrationMode
	public let reports_email_admins: Bool
	public let require_email_verification: Bool
	public let site_id: Int
	public let site_setup: Bool
	public let slur_filter_regex: String?
	public let updated: Date?

	public init(actor_name_max_length: Int, application_email_admins: Bool, application_question: String? = nil, captcha_difficulty: String, captcha_enabled: Bool, community_creation_admin_only: Bool, default_post_listing_type: String, default_theme: String, enable_downvotes: Bool, enable_nsfw: Bool, federation_debug: Bool, federation_enabled: Bool, federation_worker_count: Int?, hide_modlog_mod_names: Bool, id: Int, legal_information: String? = nil, private_instance: Bool, published: Date, registration_mode: RegistrationMode, reports_email_admins: Bool, require_email_verification: Bool, site_id: Int, site_setup: Bool, slur_filter_regex: String? = nil, updated: Date? = nil) {
		self.actor_name_max_length = actor_name_max_length
		self.application_email_admins = application_email_admins
		self.application_question = application_question
		self.captcha_difficulty = captcha_difficulty
		self.captcha_enabled = captcha_enabled
		self.community_creation_admin_only = community_creation_admin_only
		self.default_post_listing_type = default_post_listing_type
		self.default_theme = default_theme
		self.enable_downvotes = enable_downvotes
		self.enable_nsfw = enable_nsfw
		self.federation_debug = federation_debug
		self.federation_enabled = federation_enabled
		self.federation_worker_count = federation_worker_count
		self.hide_modlog_mod_names = hide_modlog_mod_names
		self.id = id
		self.legal_information = legal_information
		self.private_instance = private_instance
		self.published = published
		self.registration_mode = registration_mode
		self.reports_email_admins = reports_email_admins
		self.require_email_verification = require_email_verification
		self.site_id = site_id
		self.site_setup = site_setup
		self.slur_filter_regex = slur_filter_regex
		self.updated = updated
	}
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.actor_name_max_length = try container.decode(Int.self, forKey: .actor_name_max_length)
        self.application_email_admins = try container.decode(Bool.self, forKey: .application_email_admins)
        self.application_question = try container.decodeIfPresent(String.self, forKey: .application_question)
        self.captcha_difficulty = try container.decode(String.self, forKey: .captcha_difficulty)
        self.captcha_enabled = try container.decode(Bool.self, forKey: .captcha_enabled)
        self.community_creation_admin_only = try container.decode(Bool.self, forKey: .community_creation_admin_only)
        self.default_post_listing_type = try container.decode(String.self, forKey: .default_post_listing_type)
        self.default_theme = try container.decode(String.self, forKey: .default_theme)
        self.enable_downvotes = try container.decode(Bool.self, forKey: .enable_downvotes)
        self.enable_nsfw = try container.decode(Bool.self, forKey: .enable_nsfw)
        self.federation_debug = try container.decodeIfPresent(Bool.self, forKey: .federation_debug)
        self.federation_enabled = try container.decode(Bool.self, forKey: .federation_enabled)
        self.federation_worker_count = try container.decodeIfPresent(Int.self, forKey: .federation_worker_count)
        self.hide_modlog_mod_names = try container.decode(Bool.self, forKey: .hide_modlog_mod_names)
        self.id = try container.decode(Int.self, forKey: .id)
        self.legal_information = try container.decodeIfPresent(String.self, forKey: .legal_information)
        self.private_instance = try container.decode(Bool.self, forKey: .private_instance)
        self.published = try container.decode(Date.self, forKey: .published)
        do {
            self.registration_mode = try container.decode(RegistrationMode.self, forKey: .registration_mode)
        } catch {
            let old = try container.decode(String.self, forKey: .registration_mode)
            switch old {
            case "open":
                self.registration_mode = .open
            case "closed":
                self.registration_mode = .closed
            case "requireApplication":
                self.registration_mode = .requireApplication
            default:
                throw error
            }
        }
        self.reports_email_admins = try container.decode(Bool.self, forKey: .reports_email_admins)
        self.require_email_verification = try container.decode(Bool.self, forKey: .require_email_verification)
        self.site_id = try container.decode(Int.self, forKey: .site_id)
        self.site_setup = try container.decode(Bool.self, forKey: .site_setup)
        self.slur_filter_regex = try container.decodeIfPresent(String.self, forKey: .slur_filter_regex)
        self.updated = try container.decodeIfPresent(Date.self, forKey: .updated)
    }
}
