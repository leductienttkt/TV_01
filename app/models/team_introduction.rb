class TeamIntroduction < ApplicationRecord
  has_many :images, as: :imageable, dependent: :destroy
  belongs_to :team_target, polymorphic: true

  accepts_nested_attributes_for :images, allow_destroy: true

  validates :title, presence: true
  validates :content, presence: true

  ATTRIBUTES = [:team_target_id, :team_target_type, :title, :content,
    images_attributes: [:id, :imageable_id, :imageable_type,
      :picture, :caption]]
end
