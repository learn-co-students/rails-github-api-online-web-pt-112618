class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def create
    response = Faraday.post("https://github.com/login/oauth/access_token") do |req|
      req.body = { 'client_id': ENV['GITHUB_CLIENT'], 'client_secret': ENV['GITHUB_SECRET'], 'code': params[:code] }
      req.headers = {'Accept': 'application/json'}
    end
    body = JSON.parse(response.body)
    session[:token] = body['access_token']

    user = Faraday.get("https://api.github.com/user") do |req|
      req.headers = {
        'Authorization': "token #{session[:token]}",
        'Accept': 'application/json'
      }
    end
    session[:username] = JSON.parse(user.body)["login"]
    redirect_to root_path
  end


end
