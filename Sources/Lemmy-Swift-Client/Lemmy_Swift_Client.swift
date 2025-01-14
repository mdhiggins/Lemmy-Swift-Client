import Foundation

struct LemmyError: Codable {
	let error: String
}

public enum LemmyAPIError: Error, CustomStringConvertible, LocalizedError {
	case badResponse(response: URLResponse, request: URLRequest, data: Data)
	case invalidResponse(response: HTTPURLResponse, request: URLRequest, data: Data)
	case decodeError(_ error: Error, data: Data, request: URLRequest)

	public var description: String {
		switch self {
		case .badResponse(response: _, request: _, data: let data):
			guard let error = try? JSONDecoder().decode(LemmyError.self, from: data) else {
				return "Bad response from server"
			}
			return "Server error: \(error.error)"
		case .invalidResponse(response: let response, request: _, data: _):
			return "Invalid response from server, status code \(response.statusCode)"
		case .decodeError(let error, data: _, request: _):
			return "Decode error, \(error.localizedDescription) (\(error))"
		}
	}

	public var errorDescription: String? { return description }
}

/// An instance of the Lemmy API.
public class LemmyAPI {
	public let baseUrl: URL
	private let headers: [String: String]?
	private let urlSession: URLSession

	public init(baseUrl: URL, headers: [String: String]? = nil, urlSession: URLSession = .shared) {
		self.baseUrl = baseUrl
		self.headers = headers
		self.urlSession = urlSession
	}

	static var isoDateFormatter: ISO8601DateFormatter {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [
			.withFullDate,
			.withTime,
			.withColonSeparatorInTime,
			.withDashSeparatorInDate,
			.withFractionalSeconds
		]
		return formatter
	}

	static let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .custom { decoder in
		let container = try decoder.singleValueContainer()
		let dateString = try container.decode(String.self)
		let formatter = isoDateFormatter
		if let date = formatter.date(from: dateString) { return date }
		formatter.formatOptions.remove(.withFractionalSeconds)
		if let date = formatter.date(from: dateString) { return date }
		throw DecodingError.dataCorruptedError(
			in: container,
			debugDescription: "Unable to decode date string \(dateString)"
		)
	}

	/// Do request to lemmy server and return URLSession result
	public func urlRequest<T: APIRequest>(_ apiRequest: T) throws -> URLRequest {
		var request = URLRequest(url: baseUrl.appending(path: T.path))
		request.httpMethod = T.httpMethod.rawValue
		let encoder = JSONEncoder()
		if T.httpMethod == .get {
			let mirror = Mirror(reflecting: apiRequest)
			request.url = request.url?.appending(queryItems: mirror.children.compactMap { label, value in
				guard let label else { return nil }

				if let date = value as? Date {
					let formatter = LemmyAPI.isoDateFormatter
					return URLQueryItem(name: label, value: formatter.string(from: date))
				}

				if let valueString = value as? CustomStringConvertible {
					return URLQueryItem(name: label, value: String(describing: valueString))
				}

				return nil
			})
		} else {
			request.httpBody = try encoder.encode(apiRequest)
		}
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		return request
	}

	/// Do request to lemmy server and return URLSession result
	public func baseRequest<T: APIRequest>(_ apiRequest: T) async throws
		-> (T.Response, URLResponse, Data)
	{
		let request = try urlRequest(apiRequest)
		let (data, response) = try await URLSession.shared.data(for: request)
		if let urlResponse = response as? HTTPURLResponse,
		   urlResponse.statusCode != 200
		{ throw LemmyAPIError.badResponse(
			response: urlResponse,
			request: request,
			data: data
		) }

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = LemmyAPI.dateDecodingStrategy
		do {
			let decodedResult = try decoder.decode(T.Response.self, from: data)
			return (decodedResult, response, data)
		} catch {
			throw LemmyAPIError.decodeError(error, data: data, request: request)
		}
	}

	public func request<T: APIRequest>(_ apiRequest: T) async throws -> T.Response {
		let (result, _, _) = try await baseRequest(apiRequest)
		return result
	}
}

public enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
}
