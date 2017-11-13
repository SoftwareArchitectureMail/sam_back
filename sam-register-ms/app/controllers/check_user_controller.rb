class CheckUserController < ApplicationController

  #skip_before_action :validate_token

  soap_service namespace: 'urn:WashOut'
  #check case
  soap_action "check",
              :args => {:username => :string},
              :return => :boolean

  def check
    validate = true
    if !(User.exists?(username: params[:username]))
      validate = false
    end
    render :soap => validate
  end

end
