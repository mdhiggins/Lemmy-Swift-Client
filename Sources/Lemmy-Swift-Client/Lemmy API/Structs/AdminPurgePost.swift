//
//  AdminPurgePost.swift
//
//
//  Created by Charlie Fish on 6/11/23.
//

import Foundation

public struct AdminPurgePost: Codable {
	public let admin_person_id: Int
	public let community_id: Int
	public let id: Int
	public let reason: String?
	public let when_: String
}