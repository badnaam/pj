class ImagesController < ApplicationController
    layout "users"
    def index
        @imageible = find_imageible
        @imageible_name = find_imageible_name
        @images = @imageible.images
    end

    def show
        @image = Image.find(params[:id])

        respond_to do |format|
            format.js {
                render :update do |page|
                    page.insert_html :bottom, "list_images", :partial => "image", @object => @image, :locals => {:edit => true}
                end
            }
        end
    end
  
    def new
        @image = Image.new

    end
  
    def create
        @imageible = find_imageible
        @image = @imageible.images.build(params[:image])
        @image.image_content_type = MIME::Types.type_for(@image.image_file_name).to_s
        respond_to do |format|
            if @image.save
                flash[:notice] = "Successfully created image."
                format.json { render :json => { :result => 'success', :image => image_path(@image) } }
                format.html {redirect_to @imageible}
            else
                format.html {render :action => 'new'}
                format.json { render :json => { :result => 'error', :error => @asset.errors.full_messages.to_sentence } }
            end
        end
    end
  
    def edit
        @image = Image.find(params[:id])
    end
  
    def update
        @image = Image.find(params[:id])
        @image.image_content_type = MIME::Types.type_for(@image.image_file_name).to_s
        description = params[:value]
        if @image.update_attributes(:image_description => description)
            flash[:notice] = "Successfully updated image."
            respond_to do |format|
             format.js {
                 render :text => description
                 flash.discard
             }
            end
        end
    end
    def destroy
        @image = Image.find(params[:id])
        @image.destroy
        if @image.destroy
            #delete image from disk as well
            call_rake :delete_images, :imageible_name => find_imageible_name, :image_id => params[:id]
            flash[:notice] = "Successfully destroyed image."
            respond_to do |format|
                format.js {
                    render :update do |page|
                        page.remove "img_#{params[:id]}"
                    end
                    flash.discard
                }
            end
        else
            flash[:notice] = "Failed to destroy image."
        end
        #        redirect_to images_url
    end

    def find_imageible_name
        params.each do |name, value|
            if name =~ /(.+)_id$/
                return $1
            end
        end
    end

    def find_imageible
        params.each do |name, value|
            if name =~ /(.+)_id$/
                return $1.classify.constantize.find(value)
            end
        end
    end
end
