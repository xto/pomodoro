class InvalidTaskError < RuntimeError
end

class Task
  @name
  attr_reader :name

  def initialize name
    @name = name
  end
end
