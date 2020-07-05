# frozen_string_literal: true

class WebClient
  LOGGED_OUT_TRIGGER_TEXT = "CLICK HERE TO REGISTER YOUR ACCOUNT"
  BASE_URL = "https://forums.somethingawful.com"

  def initialize(thread_id: nil, cookies_file_path: nil)
    @thread_id = thread_id
    @cookies_file = Pathname.new(cookies_file_path)

    if File.exist?(cookies_file)
      @cookies = HTTP::CookieJar.new
      @cookies.load(cookies_file.to_s)
    end
  end

  def fetch_json_url(url:)
    response = authenticated_request do |http|
      http.get(url)
    end

    JSON.parse(response)
  end

  def fetch_page(page_number: 1)
    raise "Cannot fetch pages without a thread_id" unless thread_id

    url = thread_url(page_number: page_number)

    authenticated_request do |http|
      http.get(url)
    end
  end

  def reply(text)
    raise "Cannot reply without a thread_id" unless thread_id

    reply_form = authenticated_request do |http|
      http.get(BASE_URL + "/newreply.php?action=newreply&threadid=#{thread_id}")
    end

    form_key = extract_value(reply_form, name: "formkey")
    form_cookie = extract_value(reply_form, name: "form_cookie")

    authenticated_request do |http|
      http.post(BASE_URL + "/newreply.php", form: {
        action: "postreply",
        threadid: thread_id,
        formkey: form_key,
        form_cookie: form_cookie,
        message: text,
        submit: "Submit Reply",
      })
    end
  end

private

  attr_reader :thread_id, :cookies

  def authenticated_request
    log_in unless logged_in?

    http = yield(HTTP.cookies(cookies))
    body = http.to_s

    if body.include?(LOGGED_OUT_TRIGGER_TEXT)
      expire_cookies
      log_in
    end

    return body
  end

  def log_in
    raise "Cannot log in without a username and password set" if username_or_password_missing?

    puts "Logging in as #{username}"

    response = HTTP
      .post(BASE_URL + "/account.php", form: {
        action: "login",
        username: username,
        password: password,
      })
      .flush

    case response.code
    when 302
      if (location = response["location"]).include?("loginerror")
        raise "Error authenticating, redirected to #{location}"
      else
        @cookies = response.cookies
        @cookies.save(cookies_file)
      end
    else
      raise "Unhandled response code: #{response.code}"
    end
  end

  def thread_url(page_number:)
    url = BASE_URL + "/showthread.php?threadid=#{thread_id}"

    if page_number > 1
      url + "&perpage=40&pagenumber=#{page_number}"
    else
      url
    end
  end

  def username
    ENV["USERNAME"]
  end

  def password
    ENV["PASSWORD"]
  end

  def logged_in?
    !@cookies.nil?
  end

  def username_or_password_missing?
    username.nil? || username.empty? || password.nil? || password.empty?
  end

  def cookies_file
    @cookies_file || $application.root + ".cookies"
  end

  def expire_cookies
    @cookies = nil
    cookies_file.truncate(0)
  end

  def extract_value(html, name:)
    if html =~ /name="#{name}" value="([^"]+)"/
      return $1
    end
  end
end
