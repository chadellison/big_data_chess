desc "load_chess_games"
task load_chess_games: :environment do
  first_file_num = 1
  last_file_num = 72

  range_args = ENV['RANGE']

  if range_args.blank? || !range_args.include?('-')
    puts 'Please specify the range of files you would like to load in the following format: RANGE=1-7'
  else
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
  all_games = []
  positions = []
  games.each do |game|
    positions += create_positions(game.positions, game.result)
    all_games << Game.new({moves: game.moves.map(&:notation).join(' '), result: game.result})
  end
  Position.import(positions)
  Game.import(all_games)
  end_time = Time.now
  puts "loaded #{games.size} GAMES IN #{end_time - start_time} SECONDS"
end

def create_positions(game_positions, result)
  game_positions.map do |position|
    current_position = Position.create_position(fen_notation)
    current_position.update_results(result)
    CacheService.set(current_position.signature, current_position)
    current_position
  end
end
