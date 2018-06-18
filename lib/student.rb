class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql =<<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
    SQL
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)

    grab_id = <<-SQL
      SELECT last_insert_rowid() FROM students
    SQL
    @id = DB[:conn].execute(grab_id)[0][0]
  end

  def self.create(name:, grade:)
    student = Student.new(name,grade)
    student.save
    return student
  end
end
