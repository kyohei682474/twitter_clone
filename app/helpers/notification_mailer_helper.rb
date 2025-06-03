module NotificationMailerHelper
  def action_name_jp(action_type)
    case action_type
    when 'like'
      'いいね'
    when 'comment'
      'コメント'
    when 'retweet'
      'リツイート'
    else
      '通知'
    end
  end
end
