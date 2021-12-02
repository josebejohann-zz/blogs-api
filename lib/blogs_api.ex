defmodule BlogsAPI do
  @moduledoc false

  alias BlogsAPI.Users.Create, as: CreateUser
  alias BlogsAPI.Users.Delete, as: DeleteUser
  alias BlogsAPI.Users.Get, as: ListUsers
  alias BlogsAPI.Users.Get, as: ShowUser

  alias BlogsAPI.Posts.Create, as: CreatePost
  alias BlogsAPI.Posts.Delete, as: DeletePost
  alias BlogsAPI.Posts.Get, as: ListPosts
  alias BlogsAPI.Posts.Get, as: ShowPost
  # alias BlogsAPI.Posts.Search, as: SearchPosts
  alias BlogsAPI.Posts.Update, as: UpdatePost

  defdelegate create_user(params), to: CreateUser, as: :call
  defdelegate get_all_users(), to: ListUsers, as: :call
  defdelegate get_user_by_id(id), to: ShowUser, as: :by_id
  defdelegate delete_user(id), to: DeleteUser, as: :call

  defdelegate create_post(params), to: CreatePost, as: :call
  defdelegate get_all_posts(), to: ListPosts, as: :call
  defdelegate get_post_by_id(id), to: ShowPost, as: :by_id
  defdelegate update_post(id), to: UpdatePost, as: :call
  # defdelegate search_posts(query), to: SearchPosts, as: :call
  defdelegate delete_post(id), to: DeletePost, as: :call
end
