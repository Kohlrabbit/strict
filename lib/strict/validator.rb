module Strict
  class Validator
    def valid?
      @expectations.each do |expectation, expected_value|
        
        # passed expectations should always return Booleans and not
        # raise Exceptions or Errors directly.
        unless send(expectation, expected_value)
          raise @exception, [expectation, expected_value]
        end
      end

      true
    end
  end
end