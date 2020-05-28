require 'rails_helper'

RSpec.describe MaterialAbstraction, type: :model do
  Piece = Struct.new(:piece_type, :color)

  describe 'find_abstraction' do
    it 'returns the material ratio of the pieces' do
      pieces = [
        Piece.new('n', 'b'),
        Piece.new('Q', 'w'),
        Piece.new('r', 'b')
      ]
      expected = 1.125

      actual = MaterialAbstraction.find_abstraction(pieces, 'w')

      expect(actual).to eq expected
    end

    context 'when the turn is black' do
      it 'returns the material ratio of the pieces' do
        pieces = [
          Piece.new('n', 'b'),
          Piece.new('Q', 'w'),
          Piece.new('r', 'b')
        ]
        expected = 0.889

        actual = MaterialAbstraction.find_abstraction(pieces, 'b')

        expect(actual).to eq expected
      end
    end
  end
end
