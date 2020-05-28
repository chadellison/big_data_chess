require 'rails_helper'

RSpec.describe Game, type: :model do
  it 'can be initialized' do
    expect(Game.respond_to?(:new)).to be true
  end
end
