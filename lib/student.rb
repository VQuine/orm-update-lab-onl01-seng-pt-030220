require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  #written to avoid duplicate 
  def save
    if self.id #<--returns true if the object has an id persisted
      UPDATE students SET columnName = new value WHERE id = value;
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade) #<----repay to SQL what belongs to SQL and to Ruby what belongs to Ruby..or Caesar: Caesar, God: God! Mark12:17 Jesus is cool!
      @id = DB[:conn].last_insert_row_id #<---way nicer than that SQL query: last_insert_rowid() stuff..repaying to RUBY!
      
    end
    
  end


end #!classEND
