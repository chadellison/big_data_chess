desc "load_chess_games"
task load_chess_games: :environment do
  first_file_num = 1
  last_file_num = 72

  range_args = ARGV[1]

  if range_args.blank? || !range_args.include?('-')
    puts 'Please specify the range of files you would like to load in the following format: 1-7'
  else

  # if range_args != nil && range_args != '' && range_args.include?('-')
    range = range_args.split('-')

    first_file_num = range[0].to_i
    last_file_num = range[1].to_i
    puts "---------------LOADING #{first_file_num}-#{last_file_num} GAME FILES---------------"
    (first_file_num..last_file_num).each do |file_number|
      parse_file(file_number)
    end

    puts '---------------GAMES LOADED---------------'
  end
end

def parse_file(file_number)
  start_time = Time.now
  games = PGN.parse(File.read("#{Rails.root}/training_data/game_set#{file_number}.pgn"))
  end_time = Time.now

  puts "PARSED #{games.size} GAMES IN #{end_time - start_time} SECONDS"

  start_time = Time.now
  games.each { |game| load_game(game) }
  # bulk save everything at the end with activerecord-import gem
  end_time = Time.now
  puts "loaded #{games.size} GAMES IN #{end_time - start_time} SECONDS"
end

def load_game(game)
  binding.pry
  # iterate over positions
  # lookup and validate uniqueness of position
  # increment the result
end

# def make_substitutions(moves)
#   moves
#     .gsub(/[\r\n+]/, '')
#     .gsub(/\{.*?\}/, '')
#     .gsub('.', '. ')
#     .split(' ')
#     .reject { |move| move.include?('.') }
#     .join('.')
# end

# def create_training_game(moves)
#   if unique_game?(moves)
#     result = moves[-3..-1]
#     condensed_moves = moves[0..-4]
#
#     puts "\ngame *****************************************************"
#     puts moves[0..-4]
#
#     move_notation = moves[-7..-1] == '1/2-1/2' ? moves[0..-8] : moves[0..-4]
#
#     outcome = find_outcome(result)
#
#     game = Game.create(outcome: outcome, analyzed: true)
#     notation_logic = Notation.new
#
#     move_notation.split('.').each_with_index do |each_move, index|
#       turn = index.even? ? 'white' : 'black'
#
#       begin
#         piece = notation_logic.find_piece(each_move.sub('#', ''), turn, game.pieces)
#         game.notation = game.notation.to_s + each_move + '.'
#         game.update_game(piece.position_index, notation_logic.find_move_position(each_move, turn, game.pieces), notation_logic.upgrade_value(each_move))
#         game.reload_pieces
#         puts 'MOVE: ' + each_move
#       rescue
#         puts 'INVALID FORMAT'
#       end
#     end
#
#     game.save
#     game.update_outcomes
#
#     puts(outcome)
#   end
# end
#
# def find_outcome(result)
#   case result
#   when '0-1' then BLACK_WINS
#   when '1-0' then WHITE_WINS
#   else DRAW
#   end
# end
#
# def unique_game?(moves)
#   Game.find_by(notation: moves[0..-4]).blank?
# end
