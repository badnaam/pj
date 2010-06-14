class VoteTopicsController < ApplicationController
    # GET /vote_topics
    # GET /vote_topics.xml
    layout "users"
    def index
        @vote_topics = VoteTopic.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @vote_topics }
        end
    end

    # GET /vote_topics/1
    # GET /vote_topics/1.xml
    def show
        @vote_topic = VoteTopic.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @vote_topic }
        end
    end

    # GET /vote_topics/new
    # GET /vote_topics/new.xml
    def new
        if current_role == "business"
            @m = Merchant.find(params[:merchant_id].to_i)
            @vote_topic = @m.vote_topics.build
            @vote_items = @vote_topic.vote_items.build
        end

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @vote_topic }
        end
    end

    # GET /vote_topics/1/edit
    def edit
        @edit = true
        if current_role == "business"
            @m = Merchant.find(params[:merchant_id].to_i)
            @vote_topic = VoteTopic.find(params[:id].to_i)
        end

        respond_to do |format|
            format.html
        end
    end

    # POST /vote_topics
    # POST /vote_topics.xml
    def create
        #    @vote_topic = VoteTopic.new(params[:vote_topic])
        if current_role == "business"
            @m = Merchant.find(params[:vote_topic][:merchant_id].to_i)
#            VoteTopic.deactivate_current_vote(@m.id)
            @vote_topic = @m.vote_topics.create(params[:vote_topic])
        end

        respond_to do |format|
            if @vote_topic.save
                flash[:notice] = 'VoteTopic was successfully created.'
                format.html { redirect_to(@vote_topic) }
                format.xml  { render :xml => @vote_topic, :status => :created, :location => @vote_topic }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @vote_topic.errors, :status => :unprocessable_entity }
            end
        end
    end

    # PUT /vote_topics/1
    # PUT /vote_topics/1.xml
    def update
        @vote_topic = VoteTopic.find(params[:id])

        respond_to do |format|
            if @vote_topic.update_attributes(params[:vote_topic])
                flash[:notice] = 'VoteTopic was successfully updated.'
                format.html { redirect_to(@vote_topic) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @vote_topic.errors, :status => :unprocessable_entity }
            end
        end
    end

    # DELETE /vote_topics/1
    # DELETE /vote_topics/1.xml
    def destroy
        @vote_topic = VoteTopic.find(params[:id])
        @vote_topic.destroy

        respond_to do |format|
            format.html { redirect_to(vote_topics_url) }
            format.xml  { head :ok }
        end
    end
end
