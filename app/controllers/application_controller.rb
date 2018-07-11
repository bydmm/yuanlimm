class ApplicationController < ActionController::API
  before_action :set_raven_context

  def real_ip
    # 183.208.20.47, 140.205.9.32, 172.20.158.2, 172.20.158.7
    request.env['HTTP_X_FORWARDED_FOR'].split(', ').first
  end

  def current_user
    token = request.env['HTTP_X_TOKEN']
    @current_user ||= User.find_by(token: token)
  end

  def check_log_in
    unless current_user
      render json: {
        error: true,
        error_code: 401,
        msg: '未登录'
      }
    end
  end

  def check_geetest
    gt = GeetestLib.new(GEETEST_ID, GEETEST_KEY)
    challenge = params[GeetestLib::FN_CHALLENGE]
    validate = params[GeetestLib::FN_VALIDATE]
    seccode = params[GeetestLib::FN_SECCODE]
    result = gt.success_validate(challenge, validate, seccode)
    unless result
      render json: {
        success: false,
        error: true,
        error_code: 403,
        msg: '验证失败'
      }
    end
  end

  private

  def set_raven_context
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
