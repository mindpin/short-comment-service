module ApplicationHelper
  def get_or_create_user_id
    user_id = current_user_id
    if user_id.blank?
      user_id = randstr
      cookies.permanent.signed["user_id"] = user_id
    end
    return user_id
  end

  def current_user_id
    cookies.signed["user_id"]
  end
end
