
# tdcstyle

`{tdcstyle}` provides `tdc_style`, an opinionated `{data.table}` styler that builds on `tidyverse_style` for `{styler}`. It tries, with varying success to, balance readability with concise expressions.

The `style()` function styles the active file, or the active text selection (if made), with preference given to active selection.

*Note:* This is built for the dev version of `{data.table}` that makes use of the `let()` function. A much nicer alternative to `:=()`.

## Installation

You can install the development version of tdcstyle like so:

``` r
remotes::install_github("thedatacollective/tdcstyle")
```

# Usage

  - Plug it into styler with: `styler::style_file(<path>, style = tdcstyle::tdc_style)`
  - OR make a binding for `tdcstyle::style()` which uses the `{rstudioapi}` to style the active file or actively selected text.

# Highlights

* Split out filters onto new lines, lead by `&` and `|`. Parenthesised parts of the filter are not split.
* argument alignment for `let`
* pull up trailing brackets
* In multiline expressions, push filter onto a new line

```r
      donors[
        is.na(force_reason)
        | (is.na(other_reason) & cashemerg_hag_amount >= 1000),
        let(force_include = "Y",
            force_reason = "01. High Mid Value Cash/Emerg",
            pack = "MV")]
```

* Put internal data.table syntax sugar functions on new lines:

```r
      mailingbase[,
        .(this = that + 1,
          foo = func(bar)),
        .(foo, bar)]

```

* Pair `fcase` condition / expressions on same lines:

```r

      mailingbase[
        is.na(VP1),
        let(VP1 = fcase(
            segment == "Active Donors", "1.2 Active Donors (AD)",
            segment == "Flood Emergency", "1.3 Flood Emergency"
            default == "Standard"
            ))]

```

* Substitute `:=()` for `let()`

## VSCode Binding

From the command palette acessed `Preferences: Open Keyboard Shortcuts (JSON)`, and add a new binding like:

```json
{
  "key": "<YOUR BINDING>",
  "command": "r.runCommand",
  "args": "tdcstyle::style()"
},
```

* RStudio users can do something similar with [{shrtcts}](https://github.com/gadenbuie/shrtcts).

# Options

- `tdcstyle.exapnd_args` Set to `TRUE` to enable `{grrkstyle}`-esque expassion of function arguments onto new lines. `FALSE` by default.

---

Free software by:

![The data collective logo](inst/images/thedatacollective.png)
