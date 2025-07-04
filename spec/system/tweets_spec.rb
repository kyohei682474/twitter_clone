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
    end
  end
end
