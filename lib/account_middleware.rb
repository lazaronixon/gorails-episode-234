class AccountMiddleware
  def initialize(app)
    @app = app
  end

  # http://example.com/12345/projects
  def call(env)
    _, account_id, request_path = env["REQUEST_PATH"].split('/', 3)

    if account_id =~ /\d+/
      if account = Account.find_by(id: account_id)
        Current.account = account
      else
        return [302, { "Location" => "/" }, []]
      end

      env["SCRIPT_NAME"]  = "/#{account_id}"
      env["PATH_INFO"]    = "/#{request_path}"
      env["REQUEST_PATH"] = "/#{request_path}"
      env["REQUEST_URI"]  = "/#{request_path}"
    end

    @app.call(env)
  end
end
