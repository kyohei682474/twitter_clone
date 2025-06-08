# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @notifications = current_user.received_notifications.includes(:actor, :recipient,
                                                                  :notifiable).order(created_at: :desc)
  end
end
