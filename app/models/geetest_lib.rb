require 'net/http'
require 'digest'

class GeetestLib
  VERSION = '3.0.0'.freeze
  FN_CHALLENGE = 'geetest_challenge'.freeze
  FN_VALIDATE = 'geetest_validate'.freeze
  FN_SECCODE = 'geetest_seccode'.freeze

  API_URL = 'http://api.geetest.com'.freeze
  REGISTER_HANDLER = '/register.php'.freeze
  VALIDATE_HANDLER = '/validate.php'.freeze
  JSON_FORMAT = false

  def initialize(captcha_id, private_key)
    @private_key = private_key
    @captcha_id = captcha_id
  end

  # 验证初始化预处理.
  def pre_process
    status, challenge = _register
    _make_response_format(status, challenge)
  end

  # 正常模式的二次验证方式.向geetest server 请求验证结果.
  def success_validate(challenge, validate, seccode)
    return false unless _check_para(challenge, validate, seccode)
    return false unless _check_result(challenge, validate)
    validate_url = "#{API_URL}#{VALIDATE_HANDLER}"
    query = {
      'seccode' => seccode,
      'sdk' => ['ruby_', VERSION].join(''),
      'timestamp' => Time.now.to_i,
      'challenge' => challenge,
      'captchaid' => @captcha_id,
      'json_format' => 1
    }
    backinfo = _post_values(validate_url, query)
    backinfo = JSON.parse(backinfo)
    backinfo = backinfo['seccode']
    backinfo == _md5_encode(seccode)
  end

  private

  def _register
    pri_responce = _register_challenge
    if pri_responce
      response_dic = JSON.parse(pri_responce)
      challenge = response_dic['challenge']
    else
      challenge = false
    end
    if challenge && challenge.length == 32
      challenge = _md5_encode([challenge, @private_key].join(''))
      return 1, challenge
    else
      return 0, _make_fail_challenge
    end
  end

  def _make_fail_challenge
    rnd1 = rand(0..99)
    rnd2 = rand(0..99)
    md5_str1 = _md5_encode(rnd1.to_s)
    md5_str2 = _md5_encode(rnd2.to_s)
    md5_str1 + md5_str2[0..2]
  end

  def _make_response_format(success = 1, challenge = nil)
    challenge ||= _make_fail_challenge
    {
      'success' => success,
      'gt' => @captcha_id,
      'challenge' => challenge,
      'new_captcha' => true
    }
  end

  def _register_challenge
    uri = URI.parse("#{API_URL}#{REGISTER_HANDLER}")
    uri.query = URI.encode_www_form(gt: @captcha_id, json_format: 1, client_type: 'web', ip_address: '127.0.0.1')
    response = Net::HTTP.get_response(uri)
    if response.code == '200'
      response.body
    else
      ''
    end
  end

  def _post_values(apiserver, data)
    uri = URI(apiserver)
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(data)
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      res.body
    else
      ''
    end
  end

  def _check_result(origin, validate)
    validate == _md5_encode(@private_key + 'geetest' + origin)
  end

  # failback模式的二次验证方式.在本地对轨迹进行简单的判断返回验证结果.
  def failback_validate(challenge, validate, seccode)
    return false unless _check_para(challenge, validate, seccode)
    _failback_check_result(challenge, validate)
  end

  def _failback_check_result(challenge, validate)
    validate == _md5_encode(challenge)
  end

  def _check_para(challenge, validate, seccode)
    challenge.present? && validate.present? && seccode.present?
  end

  def _md5_encode(values)
    Digest::MD5.hexdigest values
  end
end
