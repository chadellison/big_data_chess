desc "train"
task train: :environment do
  neural_network = RubyNN::NeuralNetwork.new([16, 20, 1])
  game = Game.new
  Position.order('RANDOM()').find_each do |position|
    signature = position.signature
    input = game.extract_inputs(signature)
    target_output = calculate_ratio(signature, signature[-1])
    neural_network.train(input, target_output)
  end
  neural_network.save_weights("#{Rails.root}/weights.json")
end
