class Game < ApplicationRecord
  def neural_network
    @neural_network ||= RubyNN::NeuralNetwork.new([16, 20, 1])
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

  def position_value(fen_notation)
    signature = fen_notation.split.first
    position = Position.find_position(signature)

    if position.present?
      calculate_ratio(position, signature[-1])
    else
      calculate_position_value(signature)
    end
  end

  def calculate_position_value(signature)
    inputs = [
      # general activity movecount of active color / total move count

      # historical wins, losses, draws with ... #=> number of moves for each piece (string for each piece with its move count -- captured pieces will be absent) + turn
      # historical wins, losses, draws with ... #=> pinned pieces (string for each piece that is pinned -- captured pieces will be absent) + turn

      # historical wins, losses, draws with ... #=> all threatened pieces who are undefended

      # historical wins, losses, draws with ... #=> next_forks (diagonals, files, columns) (string for each piece that is pinned -- captured pieces will be absent) + turn

      # can capture without recatpure...

      # all pieces involved in a threat

      # historical wins, losses, draws with ... #=> threatened pieces who are defended?????
      # historical wins, losses, draws with ...
      # historical wins, losses, draws with ...
      # historical wins, losses, draws with ...
    ].map { |abstraction| calculate_ratio(abstraction, signature[-1]) }

    neural_network.calculate_prediction(inputs)
  end

  def calculate_ratio(abstraction, turn)
    draws = abstraction.draws
    wins = turn == 'w' ? abstraction.white_wins : abstraction.black_wins
    losses = turn == 'w' ? abstraction.black_wins : abstraction.white_wins

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
