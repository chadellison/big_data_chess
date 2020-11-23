class Material
  def self.create_abstraction(pieces)
    signature = ''
    pieces.each { |piece| signature += piece.piece_type }

    AbstractionHelper.retrieve_abstraction('material', signature)
  end
end
