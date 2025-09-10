class Referral < ApplicationRecord
  belongs_to :referrer, class_name: "User"
  belongs_to :referred, class_name: "User"

  validates :referrer_id, presence: true
  validates :referred_id, presence: true
  validates :referrer_id, uniqueness: { scope: :referred_id }

  scope :converted, -> { where.not(converted_at: nil) }
  scope :clicked, -> { where.not(clicked_at: nil) }

  def converted?
    converted_at.present?
  end

  def clicked?
    clicked_at.present?
  end

  def mark_as_clicked!
    update!(clicked_at: Time.current) unless clicked?
  end

  def mark_as_converted!
    update!(converted_at: Time.current) unless converted?
  end
end
