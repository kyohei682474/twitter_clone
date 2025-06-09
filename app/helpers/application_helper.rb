# frozen_string_literal: true

module ApplicationHelper
  def hidden_field_tag(_name, _value = nil, _options = {})
    raise 'Happiness chainではhidden_field_tagの使用を禁止しています'
  end

  def action_name_jp(action_type)
    case action_type
    when 'like' then 'いいね'
    when 'comment' then 'コメント'
    when 'retweet' then 'リツイート'
    else 'アクション'
    end
  end
end
