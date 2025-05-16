# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Retweets', type: :request do
  describe 'GET /create' do
    it 'returns http success' do
      get '/retweets/create'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /destroy' do
    it 'returns http success' do
      get '/retweets/destroy'
      expect(response).to have_http_status(:success)
    end
  end
end
