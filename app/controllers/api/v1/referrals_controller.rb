class Api::V1::ReferralsController < ApplicationController
  before_action :set_referral, only: [:show]
  
  def create
    @referral = Referral.new(referral_params)
    
    if @referral.save
      render json: {
        referral: referral_response(@referral),
        message: "Referral tracked successfully!"
      }, status: :created
    else
      render json: { errors: @referral.errors }, status: :unprocessable_entity
    end
  end
  
  def show
    render json: referral_response(@referral)
  end
  
  def validate_code
    @user = User.find_by(referral_code: params[:code])
    
    if @user
      # Track the referral click
      if params[:referred_user_id].present?
        referred_user = User.find_by(id: params[:referred_user_id])
        if referred_user
          referral = Referral.find_or_create_by(
            referrer: @user,
            referred: referred_user
          )
          referral.mark_as_clicked!
        end
      end
      
      render json: {
        valid: true,
        referrer: {
          id: @user.id,
          email: @user.email,
          referral_code: @user.referral_code,
          total_referrals: @user.total_referrals
        }
      }
    else
      render json: {
        valid: false,
        error: 'Invalid referral code'
      }, status: :not_found
    end
  end
  
  private
  
  def set_referral
    @referral = Referral.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Referral not found' }, status: :not_found
  end
  
  def referral_params
    params.require(:referral).permit(:referrer_id, :referred_id)
  end
  
  def referral_response(referral)
    {
      id: referral.id,
      referrer: {
        id: referral.referrer.id,
        email: referral.referrer.email,
        referral_code: referral.referrer.referral_code
      },
      referred: {
        id: referral.referred.id,
        email: referral.referred.email
      },
      clicked_at: referral.clicked_at,
      converted_at: referral.converted_at,
      created_at: referral.created_at
    }
  end
end
