class OpenSearchPush < OpenSearch
  def initialize(fields)
    @payload = [{
      cmd: 'ADD',
      fields: fields
    }]
  end

  def method
    'POST'
  end

  def path
    "/v3/openapi/apps/#{app}/stock/actions/bulk"
  end

  def content_md5
    Digest::MD5.hexdigest(@payload.to_json)
  end

  def sign(headers)
    sign_helper([
      method,
      headers[:content_md5],
      headers[:content_type],
      headers[:date],
      "x-opensearch-nonce:#{headers[:x_opensearch_nonce]}",
      path
    ].join("\n"))
  end

  def headers
    headers = {}
    headers[:content_md5] = content_md5
    headers[:content_type] = content_type
    headers[:date] = date
    headers[:x_opensearch_nonce] = "#{Time.now.to_i}#{rand(10_000..99_999)}"
    hash = sign(headers)
    headers[:Authorization] = "OPENSEARCH #{key}:#{hash}"
    headers
  end

  def push
    JSON.parse RestClient.post(url, @payload.to_json, headers)
  rescue RestClient::ExceptionWithResponse => e
    JSON.parse e.response
  end
end
