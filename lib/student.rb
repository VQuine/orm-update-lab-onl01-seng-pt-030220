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

  # #SAVEmethod written to avoid duplicates
  #check if ID exists, if it does- UPDATE existing records with "new" object data
  #if ID does not exist in database, INSERT the data into table
  #difficult for me to understand and write from scratch, keep practicing, homegurl!
  def save
    if self.id #<--returns true if the object has an id persisted
      sql = <<-SQL
      UPDATE students
       SET name = ?, grade = ? 
       WHERE id = ?
       SQL
       DB[:conn].execute(sql, self.name, self.grade, self.id) 
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade) #<----repay to SQL what belongs to SQL and to Ruby what belongs to Ruby..or Caesar: Caesar, God: God! Mark12:17 Jesus is cool!
      @id = DB[:conn].last_insert_row_id #<---way nicer than that SQL query: last_insert_rowid() stuff..repaying to RUBY!      
    end    
  end

  def self.create(a_name, a_grade)
    new_student = Student.new(a_name, a_grade)

    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, new_student.name, new_student.grade) 
    
    @id = DB[:conn].last_insert_row_id
  end

  def self.new_from_db(id_name_grade_array)
    i = id_name_grade_array[0]
    na = id_name_grade_array[1]
    gr = id_name_grade_array[2]

    new_student = Student.new(na, gr, i)   
  end


end #!classEND
