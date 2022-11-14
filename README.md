
# tdcstyle

`{tdcstyle}` provides `tdc_style` a data.table focussed extension to `tidyvers_style` for `{styler}`.

## Installation

You can install the development version of tdcstyle like so:

``` r
remotes::install_gitlab("thedatacollective/tdcstyle")
```

## VSCode Binding

```json
{
  "key": "<YOUR BINDING>",
  "command": "r.runCommandWithEditorPath",
  "args": "styler::style_file('$$', style = tdcstyle::tdc_style)"
},
```

# Progress, Suggestions, and Discussion on the Basecmap

https://3.basecamp.com/5486968/projects/30071517
