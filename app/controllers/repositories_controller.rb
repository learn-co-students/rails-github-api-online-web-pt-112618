class RepositoriesController < ApplicationController

  def index
    user = Faraday.get("https://api.github.com/user/repos") do |req|
      req.headers = {
        'Authorization': "token #{session[:token]}",
        'Accept': 'application/json'
      }
    end
    @user_data = JSON.parse(user.body)
  end

end
