# This class contains methods and constants to be used throughout 
# the application among all classes and modules.
class QIt

  @@root ||= Dir.pwd

  class << self
    def root
      @@root
    end

    def log
      @@logger ||= Logger.new(File.join(@@root, 'log', 'q_it.log'))
    end

    def generate_log_file
      Dir.mkdir(File.join(QIt.root, 'log')) unless File.exists?(File.join(QIt.root, 'log'))
    end
  end
end

QIt.generate_log_file
