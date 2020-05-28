require 'rails_helper'

RSpec.describe Position, type: :model do
  it 'can be initialized' do
    expect(Position.respond_to?(:new)).to be true
  end
end
