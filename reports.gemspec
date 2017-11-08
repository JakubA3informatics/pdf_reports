Gem::Specification.new do |s|
  s.name              = "reports"
  s.version           = "0.0.1"
  s.platform          = Gem::Platform::RUBY

  # s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.date              = %q{2017-10-12}
  
  s.authors           = ["Jakub Lemiszewski"]
  s.email             = "jl@a3informatics.com"
  s.summary           = "PDF generator"
  s.description       = "Focus more on generating pdf reports files from CDISC."
  
  s.require_paths     = ["lib"]
  s.files             = `git ls-files`.split("\n")
  
  s.rubygems_version  = %q{0.0.1}
  
  s.has_rdoc = 'yard'
  s.metadata["yard.run"] = "yri" # use "yard" to build full HTML docs
  s.add_dependency('wicked_pdf')
end

