class CdiscChangesReport

	C_CLASS_NAME = "CdiscChangesReport"
	C_FIRST_PAGE = 5
	C_PER_PAGE = 9

	# Create the CDISC changes report
	#
	# @param results [Hash] the results hash
	# @param cls [Hash] the code lists
	# @param user [User] the user
	# @return [String] the HTML
	def create(results, cls, user, custom_body=nil, complete_html= false)
		@report = WickedCore.new
		@report.open(results, cls,"CDISC Terminology Change Report", "", [], user, custom_body, complete_html)
		@report.close unless complete_html
		return @report.html
	end

	def self.export(html, options={})
       WickedCore.new.export(html, options)
	end

	if Rails.env == "test"
		# Return the current HTML. Only available for testing.
		#
		# @return [String] The HTML
		def html
			return @report.html
		end
	end

	# private

	def body(results, cls)
		@report = WickedCore.new
		html = ""
		html += '<div class="sk-cube-grid"> <div class="sk-cube sk-cube1"></div> <div class="sk-cube sk-cube2"></div> <div class="sk-cube sk-cube3"></div> <div class="sk-cube sk-cube4"></div> <div class="sk-cube sk-cube5"></div> <div class="sk-cube sk-cube6"></div> <div class="sk-cube sk-cube7"></div> <div class="sk-cube sk-cube8"></div> <div class="sk-cube sk-cube9"></div> </div>'
		html += "<h3>Conventions</h3>"
		html += "<p>In the following table for a code list entry:<ul><li><p>C = Code List was created in the CDISC Terminology</p></li>"
		html += "<li><p>U = Code List was updated in some way</p></li>"
		html += "<li><p>'-' = There was no change to the Code List</p></li>"
		html += "<li><p>X = The Code List was deleted from teh CDISC Terminology</p></li></ul></p>"
		index = 0
		page_count = C_FIRST_PAGE
		cls.each do |cl, key|
			if index % page_count == 0
				if index == 0
					html += "<h3>Changes</h3>"
				else
					html += "</tbody></table>"
					@report.add_to_body(html)
					@report.add_page_break
					page_count = C_PER_PAGE
					html = ""
					index = 1
				end
				html += "<table class=\"table table-striped table-bordered table-condensed\"><thead>"
				html += "<th>Identifier</th>"
				html += "<th>Label</th>"
				html += "<th>Submission Value</th>"
				results.each do |result|
					# r = result[:results]

					html += "<th>" + result[:date] + "</th>"
				end
				html += "</tr></thead><tbody>"
			end
			s = cl[:status]
			html += "<tr>"
			html += "<td>#{key}</td>"
			html += "<td>#{cl[:preferred_term]}</td>"
			html += "<td>#{cl[:notation]}</td>"
			s.each do |status|
				if status == :created
					html += "<td>C</td>"
				elsif status == :no_change
					html += "<td>-</td>"
				elsif status == :updated
					html += "<td>U</td>"
				elsif status == :deleted
					html += "<td>X</td>"
				elsif status == :not_present
					html += "<td>&nbsp;</td>"
				else
					html += "<td>[#{status}]></td>"
				end
			end
			html += "</tr>"
			index += 1
		end
		@report.add_to_body(html)
	end

end
