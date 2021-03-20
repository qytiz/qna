# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to :question }
  it { should have_one(:award_owning).dependent(:destroy) }
  it { should validate_presence_of :title }
end
