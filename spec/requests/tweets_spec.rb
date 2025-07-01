# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe 'Tweets', type: :request do
  describe 'POST / tweets' do
    # 正常系
    context 'when the valid value post' do
      let(:user) { FactoryBot.create(:user) }
      let(:tweet_params) { { tweet: { body: 'おはよう' } } }

      before do
        sign_in user
      end

      # ツイートが１つ作成される
      it 'creates a tweet' do
        expect do
          post tweets_path, params: tweet_params
        end.to change(Tweet, :count).by(1)
        puts response
      end

      # ステータスコード302を返す。
      it 'returns 200 response' do
        post tweets_path, params: tweet_params
        expect(response).to have_http_status(302)
      end

      # ルートページにリダイレクトする
      it 'rediect to root_path' do
        post tweets_path, params: tweet_params
        expect(response).to redirect_to(root_path)
      end

      # ツイート作成されましたと返す
      it 'returns a message' do
        post tweets_path, params: tweet_params
        expect(flash[:notice]).to eq('ツイートが作成されました')
      end
    end

    # 異常系
    context 'when invalid value post' do
      let(:user) { FactoryBot.create(:user) }
      let(:tweet_params) { { tweet: { body: '' } } }

      before do
        sign_in user
      end

      it 'does not create a tweet' do
        expect do
          post tweets_path, params: tweet_params
        end.not_to change(Tweet, :count)
      end

      it 'render to home/index' do
        post tweets_path, params: tweet_params
        expect(response).to render_template('home/index')
      end

      it 'returns 402 response' do
        post tweets_path, params: tweet_params
        expect(response).to have_http_status(422)
      end

      it 'returns a message' do
        post tweets_path, params: tweet_params
        expect(response.body).to include('ツイートに失敗しました')
      end
    end
  end
end
