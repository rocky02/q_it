
# Note: Deriving QItStandardError Class from Ruby's StandardError Class 
# and further deriving QIt Errors from QItStandardError.

class QItStandardError < StandardError; end


class QItNullSQSUrlError < QItStandardError; end

class QItNullQueueNameError < QItStandardError; end

class QItArgumentError < QItStandardError; end

class QItInvalidSQSUrlError < QItStandardError; end
