require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User
  attr_accessor :id, :fname, :lname

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def create
    raise "#{self} already in database" if self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless self.id 
    QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname) 
      UPDATE
        users 
      SET
        fname = ?, lname = ? 
      WHERE
        id = ? 
    SQL

  end

  def self.find_by_id(id)
    User.all.select{|x| x.id == id}.first 
  end
end


class Question
  attr_accessor :id, :title, :body, :author, :author_id 

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author = options['author']
    @author_id = options['author_id']
  end

  def self.all 
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.each {|datum| Question.new(datum)}
  end

  def create
    raise "#{self} already exists" if self.id  
    QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.author, self.author_id)
        INSERT INTO 
          questions (title, body, author, author_id) 
        VALUES 
          (?, ?, ?, ?)
    SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update 
    raise "#{self} does not exist" unless self.id 
    QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.author, self.author_id)
      UPDATE
        questions 
      SET 
        self.title = ?, self.body = ?, self.author = ?, self.author_id = ? 
      WHERE
        id = ?
    SQL
  end  

end