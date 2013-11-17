require 'rubygems'

Gem::Specification.new do |spec|
  spec.name       = 'crabstone'
  spec.version    = '0.0.2'
  spec.author     = 'Ben Nagy'
  spec.license    = 'BSD'
  spec.email      = 'ben@iagu.net'
  spec.homepage   = 'https://github.com/bnagy/crabstone'
  spec.summary    = 'Ruby FFI bindings for the capstone disassembly engine'
  spec.test_files = Dir['test/*.rb']
  spec.files      = Dir['**/*'].delete_if{ |item| item.include?('git') }

  spec.extra_rdoc_files = ['CHANGES', 'README', 'MANIFEST']

  spec.add_dependency('ffi')
  spec.add_development_dependency('test-unit')

  spec.description = <<-EOF 

  Capstone is a disassembly engine written by Ngyuen Anh Quynh, available here
  (...). This is the Ruby FFI binding. We test against MRI 1.9.3, 2.0.0 and
  JRuby 1.7.5.

  EOF
end
