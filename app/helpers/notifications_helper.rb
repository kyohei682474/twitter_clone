# frozen_string_literal: true

module NotificationsHelper
  def action_type_jp(type)
    case type
    when 'like' then 'いいね'
    when 'comment' then 'コメント'
    when 'retweet' then 'リツイート'
    else 'type'
    end
  end
end
