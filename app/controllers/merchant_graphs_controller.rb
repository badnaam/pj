class MerchantGraphsController < ApplicationController
    layout nil
    def graph
        @graph_type = params[:graph_type]
        @graph = open_flash_chart_object(600, 300, url_for(:action => @graph_type.to_sym, :id => params[:id]) )
    end

    def g_historical_points_1
        # based on this example - http://teethgrinder.co.uk/open-flash-chart-2/data-lines-2.php
        title = Title.new("Multiple Lines")

        data1 = []
        data2 = []
        data3 = []

        10.times do |x|
            data1 << rand(5) + 1
            data2 << rand(6) + 7
            data3 << rand(5) + 14
        end

        line_dot = LineDot.new
        line_dot.text = "Line Dot"
        line_dot.width = 4
        line_dot.colour = '#DFC329'
        line_dot.dot_size = 5
        line_dot.values = data1

        line_hollow = LineHollow.new
        line_hollow.text = "Line Hollow"
        line_hollow.width = 1
        line_hollow.colour = '#6363AC'
        line_hollow.dot_size = 5
        line_hollow.set_data = data2

        line = Line.new
        line.text = "Line"
        line.width = 1
        line.colour = '#5E4725'
        line.dot_size = 5
        line.values = data3

        y = YAxis.new
        y.set_range(0,20,5)

        x_legend = XLegend.new("MY X Legend")
        x_legend.set_style('{font-size: 20px; color: #778877}')

        y_legend = YLegend.new("MY Y Legend")
        y_legend.set_style('{font-size: 20px; color: #770077}')

        chart =OpenFlashChart.new
        chart.set_title(title)
        chart.set_x_legend(x_legend)
        chart.set_y_legend(y_legend)
        chart.y_axis = y

        chart.add_element(line_dot)
        chart.add_element(line_hollow)
        chart.add_element(line)

        render :text => chart.to_s
    end


    def g_historical_points
        @merchant = Merchant.find(params[:id])
        @gcertificates = Gcertificate.ascend_by_updated_at.search(:certs_between => [6.months.ago, Time.now],
            :merchant_id_equals => params[:id]).all

        data = []
        
        @gcertificates.each do |x|
            data << x.total_score
        end
        
        line_dot = Line.new
        line_dot.text = "Eco score"
        line_dot.width = 4
        line_dot.colour = '#38E081'
        line_dot.dot_size = 5
        line_dot.values = data
        

        title = Title.new('Eco points over 6 months')
        title.set_style('{font-size: 25px; color: #38E081}')
        x_axis = XAxis.new
        x_axis.set_colour('#000000')
        x_axis.set_grid_colour('#000000')
        tmp = []
        @gcertificates.each do |ct|
            tmp <<  XAxisLabel.new(ct.updated_at.strftime("%B %d"), '#000000', 18, '0')
        end
        x_axis.labels = tmp

        y_axis = YAxis.new
        y_axis.set_colour('#000000')
        y_axis.set_grid_colour('#000000')
        y_axis.set_range(0, 500, 100)

        x_legend = XLegend.new("Date")
        x_legend.set_style('{font-size: 20px; color: 38E081}')

        y_legend = YLegend.new("Eco Score")
        y_legend.set_style('{font-size: 20px; color: 38E081}')

        graph = OpenFlashChart.new
        graph.set_title(title)
        graph.set_x_legend(x_legend)
        graph.set_y_legend(y_legend)
        graph.y_axis = y_axis
        graph.x_axis = x_axis

        graph.add_element(line_dot)
        
        respond_to do |format|
            format.json {
                render :text => graph.render, :layout => false
            }
        end
    end
    
    def g_category_points
        @merchant = Merchant.find(params[:id])
        certifications = @merchant.gcertifications.find(:all, :conditions => ['response IN (?)',
                Gcertification::RESPONSE.keys.select{|x| x > 0}]).group_by {|gc|gc.gcertstep.category_name}
        colors = ['#38E081', '#30B369']
        bar = BarGlass.new
        certifications.each do |category, items|
            bar.append_value(items.sum(&:score))
        end
        bar.colour = colors[1]
        title = Title.new('Eco points by category')
        title.set_style('{font-size: 25px; color: #38E081;font-family: Molengo}')
        x_axis = XAxis.new
        x_axis.set_colour('#000000')
        x_axis.set_grid_colour('#000000')
        tmp = []
        certifications.keys.each do |cat|
            tmp <<  XAxisLabel.new(cat, '#000000', 18, '0')
        end
        x_axis.labels = tmp

        y_axis = YAxis.new
        y_axis.set_colour('#000000')
        y_axis.set_grid_colour('#000000')
        y_axis.set_range(0, 500, 100)

        x_legend = XLegend.new("Categories")
        x_legend.set_style('{font-size: 20px; color: 38E081}')

        y_legend = YLegend.new("Eco Score")
        y_legend.set_style('{font-size: 20px; color: 38E081}')


        graph = OpenFlashChart.new
        graph.bg_colour = '#ffffff'
        graph.title = title
        graph.x_axis = x_axis
        graph.set_x_legend(x_legend)
        graph.set_y_legend(y_legend)
        graph.y_axis = y_axis
        graph.add_element(bar)
        graph.set_colour("#000000")

        respond_to do |format|
            format.json {
                render :text => graph.render, :layout => false
            }
        end
        # rescue Exception => error
        #     logger.debug "error>>" + error.inspect
    end
    
end
