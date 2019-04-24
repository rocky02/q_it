
# Note: Deriving QItStandardError Class from Ruby's StandardError Class 
# and further deriving QIt Errors from QItStandardError.

class QItStandardError < StandardError; end

class QItArgumentError < QItStandardError; end

class QItInvalidArgumentError < QItArgumentError; end

class QItNoServiceError < QItStandardError; end
