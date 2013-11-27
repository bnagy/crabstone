capstone-ruby
===

Crabstone is a Ruby binding for the Capstone disassembly library.

BETA BETA BETA BETA
---
+ This repository name is chosen for clarity. The package name is gapstone
+ __Don't commit here or I will cut you__

  (Commit issues or fork ( it stays private ) and send me a pull request.)

Check out the test/ directory for examples.

To install (until we publish a gem) do this:

```bash
gem build crabstone.gemspec
gem install crabstone-0.0.*.gem
rake test
```

I test with JRuby >= 1.7.5, MRI >= 1.9.3. If it doesn't work with any of those
it's a bug. If it doesn't work with like Rubinius or REE or 1.8 or whatever then
"patches welcome".

	Library Author: Nguyen Anh Quynh
	Binding Authors: Nguyen Anh Quynh, Tan Sheng Di, Ben Nagy
	License: BSD style - details in the LICENSE file

	(c) 2013 COSEINC. All Rights Reserved.
