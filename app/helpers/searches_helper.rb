module SearchesHelper
    def show_search_facet_options (result_options)
        res = "<ul>"
        result_options.each do |option, count|
            res.concat("<li class='inline_list'> #{option}(#{count})</li>")
        end
        res.concat("</ul>")
        return res
    end

    def generate_content
        res = ""
        res.concat"<p> dummy </p>"
        return res
    end
end
