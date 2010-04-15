class InvalidTaskError < RuntimeError
end

class Task
  
  attr_reader :name
  attr_reader :rank

  def initialize name, rank
    raise InvalidTaskError.new "No name has been provided" if name.empty?
    @name = name
    @rank = rank
  end
end
