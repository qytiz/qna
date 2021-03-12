require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){create(:user)}
  
  it { should have_many(:answers).dependent(true) }
  it { should have_many(:questions).dependent(true) }
  it {should validate_presence_of :email}
  it {should validate_presence_of :password}

  it 'user is author' do
    question=create(:question,user:user)
    expect(user.author?(question))
  end

  it 'user is not author' do
    question=create(:question)
    expect(!user.author?(question))
  end

end