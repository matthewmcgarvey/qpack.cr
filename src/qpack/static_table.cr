module QPack
  class StaticTable
    # https://quicwg.org/base-drafts/draft-ietf-quic-qpack.html#name-static-table-2
    STATICS = [
      {":authority", ""},
      {":path", "/"},
      {"age", "0"},
      {"content-disposition", ""},
      {"content-length", "0"},
      {"cookie", ""},
      {"date", ""},
      {"etag", ""},
      {"if-modified-since", ""},
      {"if-none-match", ""},
      {"last-modified", ""},
      {"link", ""},
      {"location", ""},
      {"referer", ""},
      {"set-cookie", ""},
      {":method", "CONNECT"},
      {":method", "DELETE"},
      {":method", "GET"},
      {":method", "HEAD"},
      {":method", "OPTIONS"},
      {":method", "POST"},
      {":method", "PUT"},
      {":scheme", "http"},
      {":scheme", "https"},
      {":status", "103"},
      {":status", "200"},
      {":status", "304"},
      {":status", "404"},
      {":status", "503"},
      {"accept", "*/*"},
      {"accept", "application/dns-message"},
      {"accept-encoding", "gzip, deflate, br"},
      {"accept-ranges", "bytes"},
      {"access-control-allow-headers", "cache-control"},
      {"access-control-allow-headers", "content-type"},
      {"access-control-allow-origin", "*"},
      {"cache-control", "max-age=0"},
      {"cache-control", "max-age=2592000"},
      {"cache-control", "max-age=604800"},
      {"cache-control", "no-cache"},
      {"cache-control", "no-store"},
      {"cache-control", "public, max-age=31536000"},
      {"content-encoding", "br"},
      {"content-encoding", "gzip"},
      {"content-type", "application/dns-message"},
      {"content-type", "application/javascript"},
      {"content-type", "application/json"},
      {"content-type", "application/x-www-form-urlencoded"},
      {"content-type", "image/gif"},
      {"content-type", "image/jpeg"},
      {"content-type", "image/png"},
      {"content-type", "text/css"},
      {"content-type", "text/html; charset=utf-8"},
      {"content-type", "text/plain"},
      {"content-type", "text/plain;charset=utf-8"},
      {"range", "bytes=0-"},
      {"strict-transport-security", "max-age=31536000"},
      {"strict-transport-security", "max-age=31536000; includesubdomains"},
      {"strict-transport-security", "max-age=31536000; includesubdomains; preload"},
      {"vary", "accept-encoding"},
      {"vary", "origin"},
      {"x-content-type-options", "nosniff"},
      {"x-xss-protection", "1; mode=block"},
      {":status", "100"},
      {":status", "204"},
      {":status", "206"},
      {":status", "302"},
      {":status", "400"},
      {":status", "403"},
      {":status", "421"},
      {":status", "425"},
      {":status", "500"},
      {"accept-language", ""},
      {"access-control-allow-credentials", "FALSE"},
      {"access-control-allow-credentials", "TRUE"},
      {"access-control-allow-headers", "*"},
      {"access-control-allow-methods", "get"},
      {"access-control-allow-methods", "get, post, options"},
      {"access-control-allow-methods", "options"},
      {"access-control-expose-headers", "content-length"},
      {"access-control-request-headers", "content-type"},
      {"access-control-request-method", "get"},
      {"access-control-request-method", "post"},
      {"alt-svc", "clear"},
      {"authorization", ""},
      {"content-security-policy", "script-src 'none'; object-src 'none'; base-uri 'none'"},
      {"early-data", "1"},
      {"expect-ct", ""},
      {"forwarded", ""},
      {"if-range", ""},
      {"origin", ""},
      {"purpose", "prefetch"},
      {"server", ""},
      {"timing-allow-origin", "*"},
      {"upgrade-insecure-requests", "1"},
      {"user-agent", ""},
      {"x-forwarded-for", ""},
      {"x-frame-options", "deny"},
      {"x-frame-options", "sameorigin"},
    ]

    def value_at(idx : Int32) : String
      STATICS[idx][1]
    end

    def find_index(name : String, value : String) : Int32?
      first_idx : Int32? = nil
      STATICS.each_with_index do |entry, idx|
        if entry[0] == name
          if entry[1] == value
            return idx
          end
          first_idx = idx unless first_idx
        end
      end
      return first_idx
    end
  end
end
