class Attack
  def self.create_abstraction(pieces)
    signature = ''
    pieces.each do |piece|
      piece.targets.each do |target|
        signature += "#{target.piece_type}-#{target.defenders.map(&:piece_type).sort.join}"
      end
    end
    AbstractionHelper.retrieve_abstraction('attack', signature.downcase)
  end
end
