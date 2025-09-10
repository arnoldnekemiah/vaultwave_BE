class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :wallet_address, presence: true
  validates :referral_code, uniqueness: true, allow_nil: true

  has_many :referrals_made, class_name: "Referral", foreign_key: "referrer_id", dependent: :destroy
  has_many :referrals_received, class_name: "Referral", foreign_key: "referred_id", dependent: :destroy
  belongs_to :referrer, class_name: "User", foreign_key: "referred_by_user_id", optional: true
  has_many :referred_users, class_name: "User", foreign_key: "referred_by_user_id", dependent: :nullify

  before_create :generate_referral_code, :assign_waitlist_position

  scope :by_waitlist_position, -> { order(waitlist_position: :asc) }

  def referral_link
    "#{Rails.application.config.frontend_url}/join?ref=#{referral_code}"
  end

  def total_referrals
    referrals_made.where.not(converted_at: nil).count
  end

  private

  def generate_referral_code
    loop do
      self.referral_code = "VW#{SecureRandom.hex(4).upcase}"
      break unless User.exists?(referral_code: referral_code)
    end
  end

  def assign_waitlist_position
    self.waitlist_position = (User.maximum(:waitlist_position) || 0) + 1
  end
end
