# reports

##Description

This gem provides a simple and extremely flexible way to generate pdf files from cdisc changes results in Ruby applications. It works well with Rack based web applications, such as Ruby on Rails.

## Getting Started

You can use CdiscChangesReport class to create template as like this:

```ruby
Reports::CdiscChangesReport.new.create(results, cls, current_user) render pdf: "cdisc_changes.pdf", page_size: current_user.paper_size, orientation:
'Landscape' end
end
```
Call body method from CdiscChangesReport to WickedCore and globle variable.
