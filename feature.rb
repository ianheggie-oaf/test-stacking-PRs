class Feature
  def initialize
    @enabled = true
    @optimized = true
    @version = 4
  end

  def process
    puts "Processing v4 with optimization"
  end
end
