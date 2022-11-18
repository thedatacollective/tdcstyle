
# tdcstyle

`{tdcstyle}` provides `tdc_style` a data.table focussed extension to `tidyvers_style` for `{styler}`.

The `style()` function styles the active file, or the active text selection (if made), with preference given to active selection.

## Installation

You can install the development version of tdcstyle like so:

``` r
remotes::install_gitlab("thedatacollective/tdcstyle")
```
## VSCode Binding

From the command palette acessed `Preferences: Open Keyboard Shortcuts (JSON)`, and add a new binding like:

```json
{
  "key": "<YOUR BINDING>",
  "command": "r.runCommand",
  "args": "tdcstyle::style()"
},
```

# Options

- `tdcstyle.exapnd_args` Set to `TRUE` to enable `{grrkstyle}`-esque expassion of function arguments onto new lines. `FALSE` by default.


# Progress, Suggestions, and Discussion on the Basecmap

https://3.basecamp.com/5486968/projects/30071517
