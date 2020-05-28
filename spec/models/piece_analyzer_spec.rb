require 'rails_helper'

RSpec.describe PieceAnalyzer, type: :model do
  describe 'find_piece_value' do
    context 'when the piece is a pawn' do
      it 'returns 1' do
        expect(PieceAnalyzer.find_piece_value('p')).to eq 1
      end
    end

    context 'when the piece is a white pawn' do
      it 'returns 1' do
        expect(PieceAnalyzer.find_piece_value('P')).to eq 1
      end
    end

    context 'when the piece is a knight' do
      it 'returns 3' do
        expect(PieceAnalyzer.find_piece_value('N')).to eq 3
      end
    end

    context 'when the piece is a bishop' do
      it 'returns 3' do
        expect(PieceAnalyzer.find_piece_value('b')).to eq 3
      end
    end

    context 'when the piece is a rook' do
      it 'returns 5' do
        expect(PieceAnalyzer.find_piece_value('R')).to eq 5
      end
    end

    context 'when the piece is a queen' do
      it 'returns 9' do
        expect(PieceAnalyzer.find_piece_value('q')).to eq 9
      end
    end

    context 'when the piece is a king' do
      it 'returns 1' do
        expect(PieceAnalyzer.find_piece_value('K')).to eq 1
      end
    end

    context 'when the piece does not match' do
      it 'returns nil' do
        expect(PieceAnalyzer.find_piece_value('x')).to be nil
      end
    end
  end
end
