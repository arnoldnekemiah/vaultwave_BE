class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :waitlist_position]
  
  def create
    @user = User.new(user_params)
    
    # Handle referral code if provided
    if params[:user][:referred_by_code].present?
      referrer = User.find_by(referral_code: params[:user][:referred_by_code])
      if referrer
        @user.referred_by_user_id = referrer.id
      else
        render json: { errors: { referral_code: ['Invalid referral code'] } }, status: :unprocessable_entity
        return
      end
    end
    
    if @user.save
      # Create referral record if user was referred
      if @user.referrer.present?
        Referral.create!(
          referrer: @user.referrer,
          referred: @user,
          converted_at: Time.current
        )
      end
      
      render json: {
        user: user_response(@user),
        message: "Successfully joined waitlist!"
      }, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end
  
  def show
    render json: user_response(@user)
  end
  
  def waitlist_position
    render json: {
      waitlist_position: @user.waitlist_position,
      total_users: User.count,
      referral_count: @user.total_referrals
    }
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end
  
  def user_params
    params.require(:user).permit(:email, :wallet_address)
  end
  
  def user_response(user)
    {
      id: user.id,
      email: user.email,
      wallet_address: user.wallet_address,
      waitlist_position: user.waitlist_position,
      referral_code: user.referral_code,
      referral_link: user.referral_link,
      total_referrals: user.total_referrals,
      created_at: user.created_at
    }
  end
end
