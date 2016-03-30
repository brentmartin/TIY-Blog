class APIPostController < ApplicationController
  def index #GET
    if request[:format] == "json"
      render App.posts.to_json, status: "200 OK"
    else
    end
  end



end
