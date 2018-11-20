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

def self.find_by_id(id)
  sql = <<-SQL
  SELECT * FROM dogs
  WHERE id = (?)
  SQL
  info = DB[:conn].execute(sql, id)[0]
  Dog.new(id: info[0], name: info[1], breed:info[2])
end

def self.find_or_create_by(name:, breed:)
  sql = <<-SQL
  SELECT * FROM dogs
  WHERE name = (?)
  AND
  breed = (?)
  SQL
  info = DB[:conn].execute(sql, name, breed)
  if !info.empty? #if a record exists, return an object of it
    info = info[0]
    dog = Dog.new(id: info[0], name: info[1], breed:info[2])
  else #if the record doesn't exist, let's create it
    dog = self.create(name: name, breed: breed)
  end
  dog
end

def self.new_from_db(row)
  Dog.new(id: row[0], name:row[1], breed:row[2])
end

def self.find_by_name(name)
  sql = <<-SQL
  SELECT * FROM dogs
  WHERE name = (?)
  SQL
  info = DB[:conn].execute(sql, name)
  info = info[0]
  dog = Dog.new(id: info[0], name: info[1], breed:info[2])
end

end
