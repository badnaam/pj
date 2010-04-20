class ArticlesController < ApplicationController
    filter_resource_access
    layout "users"
    
    def index
        @articles = Article.all(:order => "created_at DESC")
    end

    def show
        @article = Article.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @article }
        end
    end

    def edit
        @article = Article.find(params[:id])
        respond_to do |format|
            format.html # edit.html.erb
            #format.xml  { render :xml => @article }
        end
    end

    def new
        @article = Article.new
        respond_to do |format|
            format.html # new.html.erb
            #format.xml  { render :xml => @article }
        end
    end

    def create
        @article = Article.new(params[:article])

        respond_to do |format|
            if @article.save
                flash[:message] = "Article created"
                format.html {redirect_to @article}
            else
                format.html {render :action => :new}
            end
        end
    end

    def update
        @article = Article.find(params[:id])

        respond_to do |format|
            if  @article.update_attributes(params[:article])
                flash[:message] = "Article updated"
                format.html {redirect_to(@article)}
            else
                format.html {render :action =>:edit} #should this be in quotes?
            end
        end
    end

    def destroy
        @article = Article.find(params[:id])
        @article.destroy

        respond_to do |format|
            format.html {redirect_to comments_url}
        end
    end
end
