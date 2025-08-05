# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tweets', type: :system do
  before do
    driven_by(:rack_test)
    log_in_as(user)
  end

  let(:user) { FactoryBot.create(:user) }

  describe 'tweet post' do
    # ツイート機能の正常系
    context 'when form is valid' do
      it 'is post successfuly and redirect to root' do
        fill_in 'tweet_body', with: 'テスト'
        click_button 'つぶやく'
        expect(page).to have_current_path(root_path)
      end

      it 'is post successfuly and shows message' do
        fill_in 'tweet_body', with: 'テスト'
        click_button 'つぶやく'
        expect(page).to have_content('ツイートが作成されました')
      end

      it 'create a tweet' do # rubocop:disable RSpec/MultipleExpectations
        expect do
          fill_in 'tweet_body', with: 'テスト'
          click_button 'つぶやく'
          expect(page).to have_content('ツイートが作成されました')
        end.to change(Tweet, :count).by(1)
      end
    end

    # ツイートの異常系
    context 'when form is invalid' do
      it 'renders root when tweet is empty' do
        fill_in 'tweet_body', with: ''
        click_button 'つぶやく'
        expect(page).to have_current_path('/tweets')
      end

      it 'fails to tweet and shows error message' do
        fill_in 'tweet_body', with: ''
        click_button 'つぶやく'
        expect(page).to have_content('ツイートに失敗しました')
      end

      it 'fail to create tweet when tweet is empty' do
        expect do
          fill_in 'tweet_body', with: ''
          click_button 'つぶやく'
        end.not_to change(Tweet, :count)
      end

      # ツイートが長すぎてツイートできない
      it 'renders /tweets when tweet is too long' do
        fill_in 'tweet_body', with: 'a' * 141
        click_button 'つぶやく'
        expect(page).to have_current_path('/tweets')
      end

      it 'fails to tweet and shows error message when tweet is too long' do
        fill_in 'tweet_body', with: 'a' * 141
        click_button 'つぶやく'
        expect(page).to have_content('ツイートに失敗しました')
      end

      it 'fail to create tweet when tweet is too long' do
        expect do
          fill_in 'tweet_body', with: 'a' * 141
          click_button 'つぶやく'
        end.not_to change(Tweet, :count)
      end
    end
  end
end
