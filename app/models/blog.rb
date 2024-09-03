# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true
  validate :random_eyecatch_cannot_be_used_if_user_is_not_premium

  scope :published, -> { where('secret = FALSE') }

  scope :search, lambda { |term|
    where('title LIKE :item OR content LIKE :item', item: "%#{term}%")
  }

  scope :default_order, -> { order(id: :desc) }

  def owned_by?(target_user)
    user == target_user
  end

  private

  def random_eyecatch_cannot_be_used_if_user_is_not_premium
    errors.add(:random_eyecatch, 'ランダムアイキャッチ画像はPremiumユーザーの特典です。') if random_eyecatch && !user.premium?
  end
end
