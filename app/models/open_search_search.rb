class OpenSearchSearch < OpenSearch
  def initialize(other_keyword)
    @keyword = other_keyword
  end

  def method
    'GET'
  end

  def encode(query)
    URI.escape(query, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  def search_query
    "query=default:'#{@keyword}'&&config=format:fulljson"
  end

  def encode_query
    "query=#{encode search_query}"
  end

  def path
    "/v3/openapi/apps/#{app}/search?"
  end

  def url
    "#{endpoint_url}#{path}#{encode_query}"
  end

  def uri
    URI(url)
  end

  def sign(headers)
    s = [
      method,
      '',
      headers[:content_type],
      headers[:date],
      "x-opensearch-nonce:#{headers[:x_opensearch_nonce]}",
      path + uri.query
    ].join("\n")
    sign_helper(s)
  end

  def headers
    headers = {}
    headers[:content_md5] = ''
    headers[:content_type] = content_type
    headers[:date] = date
    headers[:x_opensearch_nonce] = "#{Time.now.to_i}#{rand(10_000..99_999)}"
    hash = sign(headers)
    headers[:Authorization] = "OPENSEARCH #{key}:#{hash}"
    headers
  end

  def search
    data = JSON.parse(RestClient.get(url, headers), symbolize_names: true)
    if data[:status] == 'OK'
      result = data[:result]
      result[:items].map do |item|
        item[:fields][:code]
      end
    else
      []
    end
  end
end
