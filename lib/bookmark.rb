require 'pg'

class Bookmark
  def self.all
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test2')
    else
      connection = PG.connect(dbname: 'bookmark_manager2')
    end
    result = connection.exec("SELECT * FROM bookmarks;")
    result.map{|bookmark| bookmark['url']}
  end
end
