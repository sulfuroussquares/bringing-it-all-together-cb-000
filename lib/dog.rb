class Dog
attr_accessor :name, :breed

def initialize(name:, breed:, id: nil)
  @name = name
  @breed = breed
  @id = id
end

def id
  @id
end

def create_table
end


end
