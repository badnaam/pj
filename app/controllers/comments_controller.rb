class CommentsController < ApplicationController
  
    def index
        @commentable = find_commentable
        @comments = @commentable.comments
    end

    def show
        @comment = Comment.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @comment }
        end
    end

    def edit
        @comment = Comment.find(params[:id])
        respond_to do |format|
            format.html # edit.html.erb
            #format.xml  { render :xml => @comment }
        end
    end

    def new
        @comment = Comment.new
        respond_to do |format|
            format.html # new.html.erb
            #format.xml  { render :xml => @comment }
        end
    end
  
    def create
        @commentable = find_commentable
        @comment = @commentable.comments.build(params[:comment])
    
        respond_to do |format|
            if @comment.save
                flash[:message] = "Comment created"
                format.html {redirect_to @commentable}
            else
                format.html {render :action => :new}
            end
        end
    end

    def update
        @comment = Comment.find(params[:id])

        respond_to do |format|
            if  @comment.update_attributes(params[:comment])
                flash[:message] = "Comment updated"
                format.html {redirect_to(@comment)}
            else
                format.html {render :action =>:edit} #should this be in quotes?
            end
        end
    end

    def destroy
        @comment = Comment.find(params[:id])
        @comment.destroy
    
        respond_to do |format|
            format.html {redirect_to comments_url}
        end
    end

    def find_commentable
        params.each do |name, value|
            if name =~ /(.+)_id$/
                return $1.classify.constantize.find(value)
            end
        end
    end
end
