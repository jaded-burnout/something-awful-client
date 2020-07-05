# frozen_string_literal: true

require_relative "./record"

class Post < Record
  ADBOT = "Adbot"

  attributes %I[
    author
    id
    text
    timestamp
  ]

  def bot?
    [ADBOT, bot_name].reject(&:blank?).include?(author)
  end

  def user?
    !bot?
  end

private

  def bot_name
    ENV["username"]
  end
end
