class PostController < ApplicationController
  def index #GET
    if request[:format] == "json"
      render App.posts.to_json, status: "200 OK"
    else
      @posts = App.posts
      render_template 'posts/index.html.erb'
    end
  end

  def show #GET
    post = find_post_by_id

    if post
      if request[:format] == "json"
        render post.to_json
      else
        @post = post
        render_template 'posts/show.html.erb'
      end
    else
      render_not_found
    end
  end

  def new
    render_template 'posts/new.html.erb'
  end

  def create #POST
    last_post = App.posts.max_by { |post| post.id }
    new_id = last_post.id + 1

    App.posts.push(
      Post.new(new_id, params["body"], params["age"])
    )
    puts App.posts.to_json

    render({ message: "Successfully created!", id: new_id }.to_json)
  end

  # edit

  def update #PUT
    post = find_post_by_id

    if post
      unless params["body"].nil? || params["body"].empty?
        post.name = params["body"]
      end

      unless params["age"].nil? || params["age"].empty?
        post.age = params["age"]
      end

      # In rails you will need to call save here
      render post.to_json, status: "200 OK"
    else
      render_not_found
    end
  end

  def destroy #DELETE
    post = find_post_by_id

    if post
      App.posts.delete(post) # destroy it 🔥
      render({ message: "Successfully Deleted Post" }.to_json)
    else
      render_not_found
    end
  end

  private

  def find_post_by_id
    App.posts.find { |p| p.id == params[:id].to_i }
  end

  def render_not_found
    return_message = {
      message: "Post not found!",
      status: '404'
    }.to_json

    render return_message, status: "404 NOT FOUND"
  end

end
