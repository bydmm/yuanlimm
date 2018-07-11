class Api::GeetestController < ApplicationController
  def new
    gt = GeetestLib.new(GEETEST_ID, GEETEST_KEY)
    render json: gt.pre_process
  end
end
