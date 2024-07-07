class Greeter
    def initialize(name)
      @name = name
    end
  
    def greet
      p "Hello, #{@name}!"
    end
  
    def farewell
      puts "Goodbye, #{@name}!"
    end
  end
  
  greeter = Greeter.new('Alice')
  greeter.greet
  greeter.farewell
  