public enum Status: String, Codable {
  case ended = "ended"
  case returning = "returning series"
  case canceled = "canceled"
  case inProduction = "in production"
  case inDevelopment = "planned"
}
