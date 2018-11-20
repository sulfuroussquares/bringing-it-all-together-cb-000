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

def self.create_table
  sql = <<-SQL
  CREATE TABLE dogs(
    id INTEGER PRIMARY KEY,
    name TEXT,
    breed TEXT
  )
  SQL
  DB[:conn].execute(sql)
end

def self.drop_table
  sql = <<-SQL
  DROP TABLE dogs
  SQL
  DB[:conn].execute(sql)
end

def save
  sql = <<-SQL
  INSERT INTO dogs (name, breed)
  VALUES (?, ?)
  SQL
  #We just created a variable (SQL) and passed parameters into it
  DB[:conn].execute(sql, @name, @breed)
  #id is automatically generated by the database
  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
  self
end

def self.create(name:, breed:, id: nil)
  dog = Dog.new(name: name, breed: breed, id: id)
  dog.save
  dog
end


end
