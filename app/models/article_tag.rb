class ArticleTag < ActiveRecord::Base
    has_many :articles
end
