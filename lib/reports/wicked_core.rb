require 'nokogiri'
require 'wicked_pdf'

class WickedCore
  include ActionView::Helpers::TagHelper   

	C_CLASS_NAME = "WickedCore"
	C_FIRST_PAGE = 5
	C_PER_PAGE = 9

	def initialize
		@html = ""
		@paper_size = ""
	end

	def self.root_path
      String === Rails.root ? Pathname.new(Rails.root) : Rails.root
    end

    def self.add_extension(filename, extension)
      filename.to_s.split('.').include?(extension) ? filename : "#{filename}.#{extension}"
    end

	# Open the document
	#
	# @param doc_type [String] The document type, a title string
	# @param managed_item [Hash] Managed item. Can be empty
	# @param user [Object] The user creating the report
	# @return [Null]
	def open(results, cls,doc_type, title, history, user, custom_body=nil, complete_html=false)
		if complete_html
          @html = custom_body
          return @html
		end
		@paper_size = 5 #user.paper_size
		@html = page_header
		if custom_body.present?
		  @html += WickedCore.custom_body_html(results, custom_body)
		else
		  @html += WickedCore.new.title_page(doc_type, title, user)
		   @html += WickedCore.custom_body_html(results)
		end
		# raise @html.inspect
		@html += WickedCore.new.history_page(history) if !history.empty?
	end

	# Add to the body
	#
	# @return [Null]
	def add_to_body(html)
		@html += html
	end

	# Insert page break
	#
	# @return [Null]
	def add_page_break
		@html += page_break
	end

	# Close up the HTML
	#
	# @return [Null]
	def close
		@html += page_footer
	end

	# Get the PDF
	#
	# @return [Object] The PDF document
	def pdf
		footer =
		{
			:font_size => "8",
			:font_name => "Arial, \"Helvetica Neue\", Helvetica, sans-serif",
			:left => "",
			:center => "",
			:right => "[page] of [topage]"
		}
		pdf = WickedPdf.new.pdf_from_string(@html, :page_size => @paper_size, :footer => footer )
		return pdf
	end

	# Return the current HTML.
	#
	# @return [String] The HTML
	def html
		return @html
	end

	def export(html, options)
	  pdf = WickedPdf.new.pdf_from_string(html, options )
	end

	def body(results, cls)
		# raise cls.inspect
		# @report = WickedCore.new
		@html = ""
		@html += '<div class="sk-circle"> <div class="sk-circle1 sk-child"></div> <div class="sk-circle2 sk-child"></div> <div class="sk-circle3 sk-child"></div> <div class="sk-circle4 sk-child"></div> <div class="sk-circle5 sk-child"></div> <div class="sk-circle6 sk-child"></div> <div class="sk-circle7 sk-child"></div> <div class="sk-circle8 sk-child"></div> <div class="sk-circle9 sk-child"></div> <div class="sk-circle10 sk-child"></div> <div class="sk-circle11 sk-child"></div> <div class="sk-circle12 sk-child"></div> </div>'
		@html += "<h3>Conventions</h3>"
		@html += "<p>In the following table for a code list entry:<ul><li><p>C = Code List was created in the CDISC Terminology</p></li>"
		@html += "<li><p>U = Code List was updated in some way</p></li>"
		@html += "<li><p>'-' = There was no change to the Code List</p></li>"
		@html += "<li><p>X = The Code List was deleted from teh CDISC Terminology</p></li></ul></p>"
		index = 0
		page_count = C_FIRST_PAGE
		@html += '<div class="table-responsive">'   	
		@html += '<table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">'     
		@html += '<thead><tr><th>Email</th><th>Status</th><th>Name</th></tr></thead>'     
		@html +=  '<tbody>'      
		results.each do |user| 	    
			@html +=    '<tr>' 	    
			@html +=      "<td>#{user.email}</td>" 	    
			@html +=      "<td>#{user.first_name}</td>" 	    
			@html +=    '</tr>'
		end
		@html
		# @report.add_to_body(html)
	end

    def self.custom_body_html(results, cust = nil)
      html = ''
      results.each do |result|
		 result.each do |key,value|
		      html = '<table class="table table-striped table-bordered table-condensed">
						<tr> 
						    <td colspan="2">
						      <h4>BC Demonstration</h4>
						    </td>
						    <td class="bg-info text-white"> BC properties</td>
						</tr>
						<tr>
						  <td colspan="3">
						   <h5>Group</h5>
						  </td>
						</tr>
						<tr>
						  <td colspan="3">
						    <h5>Common Group</h5>
						  </td>
						</tr>
						<tr>
						  <td colspan="3">
						    <h5>EQ-5D-3L Mobility</h5>
						  </td>
						</tr>
						<tr>
						  <td>Date & Time</td>
						  <td></td>
						  <td>
						    <table class="crf-input-field">
						      <tr>'
		    if result[key].present?
		      html += result[key]["MOBILITY.DATE"].present? ? result[:bc_demo]["MOBILITY.DATE"] : "<td class='bg-success text-white'> Not submitted</td><td>D</td> <td>D</td> <td>/</td> <td>M</td> <td>M</td> <td>M</td> <td>/</td> <td>Y</td> <td>Y</td> <td>Y</td> <td>Y</td> <td></td> <td>H</td> <td>H</td> <td>:</td> <td>M</td> <td>M</td>"
			end
			html +=			      '</tr>
						    </table>
						  </td>
						</tr>
						<tr>
						  <td>Mobility</td>
						  <td></td>
						  <td>
						    <p><input type="radio" name="EQ5D3L.MOBILITY.NONE" value="EQ5D3L.MOBILITY.NONE"></input>No problems</p>
						    <p><input type="radio" name="EQ5D3L.MOBILITY.SOME" value="EQ5D3L.MOBILITY.SOME"></input>Some problems</p>
						    <p><input type="radio" name="EQ5D3L.MOBILITY.CONFINED" value="EQ5D3L.MOBILITY.CONFINED"></input>Confined to bed</p>
						  </td>
						</tr>
						<tr>
						  <td colspan="3">
						    <h5>EQ-5D-3L Self-Care</h5>
						  </td>
						</tr>
						<tr>
						  <td>Date & Time</td>
						  <td></td>
						  <td>
						    <table class="crf-input-field">
						      <tr>
						        <td>D</td>
						        <td>D</td>
						        <td>/</td>
						        <td>M</td>
						        <td>M</td>
						        <td>M</td>
						        <td>/</td>
						        <td>Y</td>
						        <td>Y</td>
						        <td>Y</td>
						        <td>Y</td>
						        <td></td>
						        <td>H</td>
						        <td>H</td>
						        <td>:</td>
						        <td>M</td>
						        <td>M</td>
						      </tr>
						    </table>
						  </td>
						</tr>
						<tr>
						  <td>Self-Care</td>
						  <td></td>
						  <td>
						    <p><input type="radio" name="EQ5D3L.SELFCARE.NONE" value="EQ5D3L.SELFCARE.NONE"></input>No problems</p>
						    <p><input type="radio" name="EQ5D3L.SELFCARE.SOME" value="EQ5D3L.SELFCARE.SOME"></input>Some problems</p>
						    <p><input type="radio" name="EQ5D3L.SELFCARE.UNABLE" value="EQ5D3L.SELFCARE.UNABLE"></input>Unable to wash/dress</p>
						  </td>
						</tr>
						</table>'
		  end
	   end
	   html += "<div id='foo'></div>"
	   if cust.present?
	   #	 views_dir = WickedCore.root_path.join('.', 'public')
	   #	 views_source = WickedCore.add_extension(cust, 'html')
             html =  cust # "#{File.read(views_dir.join(views_source))}"
	   end
       # html = WickedCore.new.replace_image_assets(html)
	   return html
    end

    def replace_image_assets(html)
      doc = Nokogiri::HTML(html)
       doc.xpath("//img").each do |img|
	     img.attributes["src"].value = WickedCore.report_asset_path(img.attributes["src"].value)
	  end
	  doc.to_html
    end

	def page_header
	    css_dir = WickedCore.root_path.join('app/assets', 'stylesheets')
		html = "<html><head>"
		source = WickedCore.add_extension("bootstrap", 'css')
		html += "<style type='text/css'>#{File.read(css_dir.join(source))}</style>"
		html += "</head><body>"
		return html
	end

	def page_footer
		html = "</body></html>"
		return html
	end

	def title_page(doc_type, title,  user)
		html = ""
		#title = ""
		#name = APP_CONFIG['organization_title']
		#image_file = APP_CONFIG['organization_image_file']
		name = "BCS file" #ENV['organization_title']
		image_file = "favicon.png" # ENV['organization_image_file']
		dir = Rails.root.join("app", "assets", "images")
		file = File.join(dir, image_file)
		time_generated = Time.now
		# Generate HTML
		html = "<div style=\"vertical-align:middle; text-align:center\"><img height=\"75\" src=\"#{file}\"></div>"
		html += "<h3 class=\"text-center col-md-12\">#{name}</h3>"
		html += "<br>" * 10
		html += "<div class=\"text-center col-md-12\"><h1>#{doc_type}<h1><h3>#{title}</h3></div>"
		html += "<br>" * 5
		html += "<div class=\"text-center col-md-12\"><p>Run at: #{time_generated.strftime("%Y-%b-%d, %H:%M:%S")}</p></div>"
		html += "<div class=\"text-center col-md-12\"><p>Run by: #{user.email}</p></div>"
		html += page_break
		return html
	end

	def history_page(history)
		html = ""
		if history.length > 0
			html += "<h3>Item History</h3>"
			html += "<table class=\"table table-striped table-bordered table-condensed\">"
			html += "<thead><tr><th>Date</th><th>Change</th><th>Comment</th><th>References</th></tr></thead><tbody>"
			history.each do |item|
				changed_date = Timestamp.new(item[:last_changed_date]).to_date
				description = MarkdownEngine::render(item[:change_description])
				comment = MarkdownEngine::render(item[:explanatory_comment])
				refs = MarkdownEngine::render(item[:origin])
				html += "<tr><td>#{changed_date}</td><td>#{description}</td><td>#{comment}</td><td>#{refs}</td></tr>"
			end
			html += "</tbody></table>"
			html += page_break
		end
		return html
	end

	def page_break
	  return "<div style='page-break-after:always;'></div>"
	end

    def self.report_asset_path(asset)
      return WickedCore.root_path.join('.', 'public').to_s+asset
    end
end
