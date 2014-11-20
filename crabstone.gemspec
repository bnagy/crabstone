require 'rubygems'

Gem::Specification.new do |spec|
  spec.name       = 'crabstone'
  spec.version    = '3.0'
  spec.author     = 'Ben Nagy'
  spec.license    = 'BSD'
  spec.email      = 'crabstone@ben.iagu.net'
  spec.homepage   = 'https://github.com/bnagy/crabstone'
  spec.summary    = 'Ruby FFI bindings for the capstone disassembly engine'
  spec.test_files = Dir['test/*.rb']
  spec.files      = Dir['**/*'].delete_if{ |item| item.include?('git') }

  spec.extra_rdoc_files = ['CHANGES.md', 'README.md', 'MANIFEST']

  spec.add_runtime_dependency 'ffi' unless RUBY_PLATFORM =~/java/
  spec.add_development_dependency 'test-unit'

  spec.description = <<-EOF

  Capstone is a disassembly engine written by Nguyen Anh Quynh, available here
  https://github.com/aquynh/capstone. This is the Ruby FFI binding. We test
  against MRI 2.0.0,  2.1.0 and JRuby 1.7.8. AFAIK it works with rubinius
  2.2.1.

    EOF
end
