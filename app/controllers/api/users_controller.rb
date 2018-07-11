class Api::UsersController < ApplicationController
  before_action :check_log_in, only: [:show, :logout]
  before_action :check_geetest, only: [:login, :create]

  # 获取用户
  # header "x-token": "435345435345",
  def show
    render json: current_user.to_json
  end

  # 注册
  # {
  #   "user": "bydmm",
  #   "password": "123456",
  #   "password_confirmation": "123456"
  # }
  def create
    user = User.new(name: params['name'], nick_name: params['nick_name'], password: params['password'], password_confirmation: params['password_confirmation'])
    if user.save
      render json: {
        id: user.id,
        token: user.token
      }
    else
      render json: {
        error: true,
        msg: user.errors.full_messages.join(', ')
      }
    end
  end

  # 登录
  # {
  #   "user": "bydmm",
  #   "password": "123456",
  # }
  def login
    user = User.find_by(name: params['name']).try(:authenticate, params['password'])
    if user
      render json: {
        id: user.id,
        token: user.token
      }
    else
      render json: {
        error: true,
        msg: '账户或者密码错误'
      }
    end
  end

  def logout
    current_user.token = ''
    current_user.save
  end
end
