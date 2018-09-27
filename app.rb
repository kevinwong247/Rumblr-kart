require 'sinatra'
require_relative 'models'
require 'sinatra/flash'

set :sessions, true
use Rack::MethodOverride
@@login_users = []
def current_user
  if session[:user_id]
    return User.find(session[:user_id])
  end
end

def something
  'sdfsdfsd'
end

get '/' do
  if session[:user_id]
    erb :user_profile, locals: { current_user: current_user, allusers: User.all }
  else
    erb :index
  end
end

post '/signup' do
  user = User.find_by(username: params[:username])
  if (user)
    flash[:usernameexist]= 'This username already exists please try again'
    redirect '/'
  else  
    # creates new user
    user = User.create(
      username: params[:username],
      password: params[:password],
      email: params[:email],
      birthday: params[:birthday]
    )

    # logs user in
    session[:user_id] = user.id

    # redirects to content page
    redirect '/'
  end
end

post '/login' do
  user = User.find_by(username: params[:username])

  if user && user.password == params[:password]
    session[:user_id] = user.id
    @@login_users.push(user.id)
    redirect '/myblog'
  else
    redirect '/'
  end
end

get '/comment/:id' do
  postforc=Post.find_by(id: params[:id])


  erb :comment, locals: {postforc: postforc}
end

post '/comment/:id' do 
  Comment.create(
    commentary: params[:content],
    post_id: params[:postId],
    user_id: current_user.id
    )
    newpost = Post.find_by(id: params[:postId])
    
  redirect "/comment/#{params[:postId]}"
end

get '/content' do
  erb :content, locals: { users: User.all }
end

get '/account' do
  
  erb :account
end

post '/account' do
    current_user.destroy

    redirect '/logout'
end

get '/logout' do
  @@login_users.each do |user|
    if session[:user_id] == user
      @@login_users.delete(user)
    end
  end
  session[:user_id] = nil
    # flash[:deleteduser] = "Your account has been deleted"
    
  redirect '/'
end

get '/myblog' do
  @thisuser = current_user
  @printhash = params[:hashtags]
  output = ''
  
  output += erb :myblog, locals: { blogposts: Post.order(created_at: :desc).first(20) }
  output
end

post '/myblog' do
  newpost = Post.create(
    title: params[:title],
    content: params[:content],
    user_id: current_user.id
      )
  @hashstring = params[:hashtags]
  hashtag = params[:hashtags].tr("'","").split('#').join('').split(' ')
  
  hashtag.each do |tag|
    Hashtag.create(
    tag: tag,
    post_id: newpost.id
  )
  end
  
  redirect '/myblog'
end

get '/posts' do 
  @thisuser = current_user
  output = ''
  output += erb :posts, locals: { posts: Post.order(created_at: :desc).first(20) }
  output
end

# delete '/post/delete' do 
#   postid = Post.find_by(id: params[:id])
#   postid.destroy
  
#   redirect '/posts'
# end
get '/posts/:id' do
  deletepost= Post.find_by(id: params[:id])
  deletepost.destroy

  redirect "/posts"
end

get '/allpost' do 

  erb :allpost
end 

post '/allpost' do 
  hashtags = Hashtag.all
  query = params[:q] 
  erb :allpost, locals: { hashtags: hashtags, query: query }
end




