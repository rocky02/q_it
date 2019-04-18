class QItArgumentError < StandardError
  
  def initialize obj
    puts "Error in #{obj}"
    super
  end

end