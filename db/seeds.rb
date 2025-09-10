# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample users for testing
puts "Creating sample users..."

# First user (no referral)
user1 = User.find_or_create_by!(email: "john.doe@example.com") do |user|
  user.wallet_address = "0x1234567890123456789012345678901234567890"
end

# Second user (referred by first user)
user2 = User.find_or_create_by!(email: "jane.smith@example.com") do |user|
  user.wallet_address = "0x9876543210987654321098765432109876543210"
  user.referred_by_user_id = user1.id
end

# Third user (referred by first user)
user3 = User.find_or_create_by!(email: "alice.johnson@example.com") do |user|
  user.wallet_address = "0xabcdef1234567890abcdef1234567890abcdef12"
  user.referred_by_user_id = user1.id
end

puts "Created #{User.count} users"
puts "User 1 referral code: #{user1.referral_code}"
puts "User 1 total referrals: #{user1.total_referrals}"
