require 'pg'

require 'pg'
require 'uri'

class Bookmark
  def self.all
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test2')
    else
      connection = PG.connect(dbname: 'bookmark_manager2')
    end
    bookmarks = connection.exec('SELECT * FROM bookmarks;')
    bookmarks.map do |bookmark|
      Bookmark.new(
        id: bookmark['id'],
        title: bookmark['title'],
        url: bookmark['url']
      )
    end
  end

  def self.create(url:, title:)
    return false unless is_url?(url)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test2')
    else
      connection = PG.connect(dbname: 'bookmark_manager2')
    end
    result = connection.exec("INSERT INTO bookmarks (url, title) VALUES('#{url}', '#{title}') RETURNING id, title, url;")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end

  attr_reader :id, :title, :url

  def initialize(id:, title:, url:)
    @id = id
    @title = title
    @url = url
  end

  def self.delete(id:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test2')
    else
      connection = PG.connect(dbname: 'bookmark_manager2')
    end
    connection.exec("DELETE FROM bookmarks WHERE id = #{id}")
  end

  def self.update(id:, url:, title:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test2')
    else
      connection = PG.connect(dbname: 'bookmark_manager2')
    end
    result = connection.exec("UPDATE bookmarks SET url = '#{url}', title = '#{title}' WHERE id = #{id} RETURNING id, url, title;")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end

  def self.find(id:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test2')
    else
      connection = PG.connect(dbname: 'bookmark_manager2')
    end
    result = connection.exec("SELECT * FROM bookmarks WHERE id = #{id};")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end

  private

  def self.is_url?(url)
    url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
  end
end
