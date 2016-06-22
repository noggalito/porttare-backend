module RequestLoginMacros
  def login_as(user)
    post(
      api_auth_user_session_path,
      email: user.email,
      password: user.password
    )
  end

  def post_with_headers(path, parameters = {})
    post(
      path,
      parameters,
      response.headers.slice(
        "access-token",
        "token-type",
        "client",
        "expiry",
        "uid"
      )
    )
  end
end
