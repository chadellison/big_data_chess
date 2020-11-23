class Game
  def neural_network
    if @neural_network.present?
      @neural_network
    else
      @neural_network = RubyNN::NeuralNetwork.new([16, 20, 1])
      file_path = Rails.root + 'weights.json'
      begin
        json_weights = File.read(file_path)
        @neural_network.set_weights(JSON.parse(json_weights))
      rescue
        puts "FILE '#{file_path}' DOES NOT EXIST: #{e}"
      end
    end
  end

  def play_self(fen_notation)
    game_result = ChessValidator::Engine.result(fen_notation)

    if game_result
      puts 'the game is over...' + game_result
    else
      pieces_with_moves = ChessValidator::Engine.find_next_moves(fen_notation)
      new_fen_notation = ChessValidator::Engine.make_random_move(fen_notation, pieces_with_moves)
      puts new_fen_notation
      play_self(new_fen_notation)
    end
  end

  def weight_moves(fen_notation)
    pieces_with_moves = ChessValidator::Engine.find_next_moves(fen_notation)
    weighted_moves = {}

    pieces_with_moves.each do |piece|
      piece.valid_moves.each do |move|
        # weighted_moves[move] = ...
      end
    end
  end

  def position_value(fen_notation)
    signature = fen_notation.split.first
    position = Position.find_position(signature)

    if position.present?
      calculate_ratio(position, signature[-1])
    else
      inputs = extract_inputs(signature)
      neural_network.calculate_prediction(inputs)
    end
  end

  def extract_inputs(signature)
    inputs = CacheService.hget('inputs', signature)

    if inputs.present?
      inputs
    else
      fen_notation = signature + ' 0 1'
      pieces_with_moves = ChessValidator::Engine.find_next_moves(fen_notation).sort_by(&:piece_type)

      turn = signature.split[1]
      inputs = create_abstractions(pieces_with_moves, fen_notation).map do |abstraction|
        calculate_ratio(abstraction, turn)
      end

      CacheService.hset('inputs', signature, inputs)
      inputs
    end
  end

  def create_abstractions(pieces, fen_notation)
    abstractions = CacheService.hget('abstractions', fen_notation)

    if abstractions.present?
      abstractions.map do |abstraction|
        CacheService.hget(abstraction['type'], abstraction['signature'])
      end
    else
      all_pieces = ChessValidator::Engine.pieces(fen_notation).sort_by(&:piece_type)

      pieces.each do |piece|
        piece.targets.each do |target|
          fen_string = ChessValidator::Engine.move(piece, target.position, fen_notation)
          new_pieces = ChessValidator::Engine.find_next_moves(fen_notation).sort_by(&:piece_type)
          target.defenders = new_pieces.select { |defender| defender.valid_moves.include?(target.position) }
        end
      end

      abstractions = [
        Activity.create_abstraction(pieces),
        Pin.create_abstraction(pieces),
        Center.create_abstraction(pieces),
        CenterCount.create_abstraction(pieces),
        Material.create_abstraction(all_pieces),
        Attack.create_abstraction(pieces),
        # pawn structure
        # king threat
      ]
      CacheService.hset('abstractions', fen_notation, abstractions)
      abstractions
    end
  end

  def calculate_ratio(abstraction, turn)
    draws = abstraction['draws']
    wins = turn == 'w' ? abstraction['white_wins'] : abstraction['black_wins']
    losses = turn == 'w' ? abstraction['black_wins'] : abstraction['white_wins']

    draw_points = draws.present? ? draws / 2.0 : 0
    total = wins + losses + draws
    numerator = wins + draw_points
    if numerator.present?
      numerator / total
    else
      0
    end
  end
end
