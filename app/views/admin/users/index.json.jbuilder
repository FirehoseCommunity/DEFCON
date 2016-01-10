json.array!(@users) do |user|
  json.email        user.email
  json.name         user.name
  json.image_url    user.gravatar_url(default: "retro")
  json.edit_url     edit_admin_user_path(user)
  json.created_at   "Joined: #{user.created_at.strftime("%B %d, %Y")}"
  if user.admin?
    json.admin        "Yes"
  else
    json.admin        "No"
  end
  json.post_notify  user.post_notification
end
