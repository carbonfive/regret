#regret

Provides a simple workflow for specifying and maintaining screenshot-based test assertions.

## Installation and Usage

```
> bundle
```

```ruby
# Before your specs run

require 'regret/configuration'

Regret::Configuration.configure do |config|
  #specify a tmp_path for temporary screenshot files
  config.tmp_path = YOUR_PROJECT_TMP_FOLDER
end
```

And in any spec of your choosing...

```ruby
require 'regret/test_helper'

Regret::TestHelper.compare(page, name: 'My Test 1')
```

## Dependencies

Here are some dependencies not (yet) specified in the gemspec:

- Capybara
- A driver of your choosing (poltergeist, capybara-webkit, etc), depending on how screenshots are taken

## Goals

The goals of this gem are to remain agnostic, slim, and provide a simplified workflow. Some specifics:

- Stay free of test framework dependencies
- Stay free of app framework dependencies
- Use one-size-fits-all rake tasks to manage the workflow
- Ability to use test helper methods within the test framework of your choosing.

## How it works

1. `Regret::TestHelper` methods are used within your test suite
2. regret compares the state of the current page to a named screenshot
3. Return `false` for mismatched screenshots, `true` for matched
4. If no screenshot exists, create a new one and return `true`

It is up to you to wrap the method calls in assertions, should you want test failures.

## Other features

```ruby
# Take a screenshot of a section of the page (driver must support)

Regret::TestHelper.compare(page, name: 'Test', selector: '.my-element')
```

## Running Tests

```
> brew install phantomjs
> rake
```