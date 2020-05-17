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
    all_games << Game.new({moves: games.first.moves.map(&:notation).join(' '), result: game.result})
  end
  Position.import(positions)
  Game.import(all_games)
  end_time = Time.now
  puts "loaded #{games.size} GAMES IN #{end_time - start_time} SECONDS"
end

def create_positions(game_positions, result)
  new_positions = []
  game_positions.each do |position|
    signature = position.to_fen.to_s
    piece_size = find_piece_size(signature)

    current_position = Position.find_by(signature: signature, piece_size: piece_size)

    if current_position.present?
      current_position = handle_result(current_position, result)
      current_position.save
    else
      current_position = Position.new({signature: signature, piece_size: piece_size})
      current_position = handle_result(current_position, result)
      new_positions.push(current_position)
    end
  end
  new_positions
end

def find_piece_size(signature)
  signature.split(' ').first.chars.count do |char|
    'pnbrqk'.include?(char.downcase)
  end
end

def handle_result(position, result)
  case result
  when '1/2-1/2'
    position.draws += 1
  when '1-0'
    position.white_wins += 1
  when '0-1'
    position.black_wins += 1
  end
  position
end
