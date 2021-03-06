# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    def page_title(title)
        content_for(:title) {title}
    end

    def generate_html(form_builder, method, options = {})
        options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
        options[:partial] ||= method.to_s.singularize
        options[:form_builder_local] ||= :f

        form_builder.fields_for(method, options[:object], :child_index => 'NEW_RECORD') do |f|
            render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
        end
    end

    def link_to_new_nested_form(name, form_builder, method, options = {})
        options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
        options[:partial] ||= method.to_s.singularize
        options[:form_builder_local] ||= :f
        options[:element_id] ||= method.to_s
        options[:position] ||= :bottom
        options[:max] ||= 2
        options[:input_type] ||= "text"
        link_to_function name, :id => options[:id] do |page|
            html = generate_html(form_builder,
                method,
                :object => options[:object],
                :partial => options[:partial],
                :form_builder_local => options[:form_builder_local]
            )
            page << %{
        $('#{options[:element_id]}').insert({ #{options[:position]}: "#{ escape_javascript html }".replace(/NEW_RECORD/g, new Date().getTime()) });
            }
            page << %{num = $$("##{options[:element_id]} input[type='#{options[:input_type]}']").length;}
            page << %{
                if(num >= #{options[:max]}) {
                    $("#{options[:id]}").hide();
                }
            }
        end
    end
end


