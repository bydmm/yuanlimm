class OpenSearch
  def key
    ENV['ALIYUN_ACCESSKEYID']
  end

  def secret
    ENV['ALIYUN_ACCESSKEYSECRET']
  end

  def endpoint_url
    ENV['ALIYUN_OPENSEARCH_URL']
  end

  def app
    ENV['ALIYUN_OPENSEARCH_APP_NAME']
  end

  def path
    raise '需要实现'
  end

  def url
    "#{endpoint_url}#{path}"
  end

  def content_md5
    ''
  end

  def content_type
    'application/json'
  end

  def method
    'POST'
  end

  def date
    Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
  end

  def sign_helper(data)
    digest = OpenSSL::Digest.new('sha1')
    Base64.strict_encode64(OpenSSL::HMAC.digest(digest, secret, data))
  end
end
