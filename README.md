# StumpWM Window switch

Windows switch module for StumpWM

## Installation

```bash
cd ~/.stumpwm.d/modules/
git clone https://github.com/Junker/stumpwm-window-switch window-switch
```

```lisp
(stumpwm:add-to-load-path "~/.stumpwm.d/modules/window-switch")
(load-module "window-switch")
```

## Usage

```lisp
  (define-key *top-map* (kbd "M-Tab") "select-previous-window")
  (define-key *top-map* (kbd "s-Tab") "windowlist-last")
```

### Parameters

- **window-switch:\*timeout\*** - timeout in secs after which the window will be
added as last one (default: 1)
