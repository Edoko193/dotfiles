# Lite MODAL

A fully customizable modal editing experience for Lite Xl

![](intro.gif)


## Configuration

The configuration of the modal experience can be done via the follow parameters:

| Field                                  | Default                     | Comment                                                   |
|:---------------------------------------|:---------------------------:|:----------------------------------------------------------| 
|`config.plugins.modal.base_mode`        | `nil`                       | default mode when opening a new document/session          |
|`config.plugins.modal.modes`            | `{}`                        | enumerate all the possible modes available                |
|`config.plugins.modal.keymaps`          | `{}`                        | table containing keymaps for each available mode          |
|`config.plugins.modal.on_key_callbacks` | `{}`                        | table containing `on_key_pressed` callbacks for each mode |
|`config.plugins.modal.carets`           | `{}`                        | carets styles for each mode                               |
|`config.plugins.modal.helpers`          | `{}`                        | available command helpers per mode                        |
|`config.plugins.modal.show_helpers`     | `true`                      | enable or disable command helper                          |
|`config.plugins.modal.status_bar`       | `{mode=true, strokes=true}` | configure the status bar widget                           |

Additionally the helper styling can be changed:

| Field                    | Default            | Comment                 |
|:-------------------------|:------------------:|:------------------------| 
|`style.helper.background` | `#000000C8`        | helper background color |
|`style.helper.text`       | `#FFFFFFDC`        | helper text color       |
|`style.helper.padding`    | 10                 | helper internal padding |
|`style.helper.margin`     | 10                 | helper external margin  |
|`style.helper.alignement` | `modal.align.LEFT` | helper alignement       |

### Configuration details

It is possible to configure any number of modes in the `modal.modes` table, for example:

```lua
config.plugins.modal.modes = {"NORMAL", "INSERT", "VISUAL"}
```
Then you should decide wich mode is the base/default mode for example:

```lua
config.plugins.modal.base_mode = "NORMAL"
```

Then decide which kind of `on_key_pressed` call back to use (*or define your owns*):

```lua
config.plugins.modal.on_key_callbacks.NORMAL = modal.on_key_command_only
config.plugins.modal.on_key_callbacks.INSERT = modal.on_key_passthrough
config.plugins.modal.on_key_callbacks.VISUAL = modal.on_key_command_only
```

The callback `on_key_command_only` will only register the keystrokes and execute
the matched commands but will not forward the strokes to `lite-xl`. This will allow to 
reproduce most modal editing stuff.

The callback `on_key_passtrought` will register the keystrokes and execute commands (if matched)
and will pass the strokes to `lite-xl`, usefull for *editing* modes.

You can define your own logics if you want something different.

Lastly you have to define the keymaps for the different modes:

```lua
config.plugins.modal.keymaps.NORMAL = {
  ["i"] = modal.go_to_mode("INSERT"), -- function call back
  ["v"] = modal.go_to_mode("VISUAL"),
  ["u"] = "doc:undo",
  ["<left>"] = {"doc:move-to-previous-char", "dialog:previous-entry"},
  ["j"] = "doc:move-to-next-line",
  ["<space>f"] = "core:open-file",
  ["P"] = "jp", -- other sequence 
  -- .....
}
config.plugins.modal.keymaps.INSERT = {
  ["<ESC>"] = modal.go_to_mode("NORMAL"),
}
-- ...
```

Each sequence can execute one or more commands, the commands can be functions or string.
If it is a string and it match another sequence, the sequence command is executed, otherwise 
it will execute as a `lite-xl` command.

Optionally it is possible to configure additional features: 
```lua
-- define BAR caret
config.plugins.modal.carets.NORMAL = modal.caret_style.BAR

-- helper definition
config.plugins.modal.helpers.NORMAL = {
  ["<space>"] = {
    {"f", "open file picker"},
    {"P", "open project picker"},--...
  }
}
```

For more detailed example please look at [lite-modal-hx](https://codeberg.org/Mandarancio/lite-modal-hx) preset.

#### Status bar

`lite-modal` provide a simple status widget positioned on the bottom left of the `lite-xl` status bar.
This widget can contains the following information:
 - The current mode, enabled by default and configurable in the variable `config.plugins.modal.status_bar.mode` (boolean)
 - The current keystroke, enabled by default and configurable in the variable `config.plugins.modal.status_bar.strokes` (boolean)

If you want to disable one or more of this widgets simply configure in your `init.lua`:

```lua
local config = require "core.config"
local modal = require "plugins.modal"


config.plugins.modal.status_bar.mode = true -- enable mode widget (not needed, just for example)
config.plugins.modal.status_bar.strokes = false -- disable strokes widget
modal.set_status_bar() -- apply the changes
```

## Commands

Two commands are added to lite:

 - `modal:redo` that redo the last executed command (N times if a number modifier is specified, a la vi)
 - `modal:help` to show the current keymap active

## Presets

### Simple Preset

Below a simple example of a demo configuration that you can simply paste in your `init.lua`:

```lua
local config = require "core.config"
local modal = require "plugins.modal"

config.plugins.modal.status_bar.strokes = false
modal.set_status_bar()

config.plugins.modal.modes = { "Move", "Edit", "Jump" }
config.plugins.modal.base_mode = "Move"

config.plugins.modal.on_key_callbacks.Move = modal.on_key_command_only
config.plugins.modal.on_key_callbacks.Edit = modal.on_key_passthrough
config.plugins.modal.on_key_callbacks.Jump = modal.on_key_command_only

config.plugins.modal.keymaps.Move = {
  ["e"] = modal.go_to_mode("Edit"),
  ["j"] = modal.go_to_mode("Jump"),
  ["<right>"] = "doc:move-to-next-char",
  ["<left>"] = "doc:move-to-previous-char",
  ["<up>"] = "doc:move-to-previous-line",
  ["<down>"] = "doc:move-to-next-line",
  [":"] = "core:find-command",
  ["<space>?"] = "modal:help",
}

config.plugins.modal.keymaps.Edit = {
  ["<ESC>"] = modal.go_to_mode("Move"),
  ["C-P"] = "core:find-command",
  ["C-?"] = "modal:help",
}

config.plugins.modal.keymaps.Jump = {
  ["<ESC>"] = modal.go_to_mode("Move"),
  ["e"] = modal.go_to_mode("Edit"),
  ["<right>"] = { "doc:select-none", "doc:select-to-next-word-end" },
  ["<left>"] = { "doc:select-none", "doc:select-to-previous-word-start" },
  ["<up>"] = { "doc:select-none", "doc:move-to-previous-line", "doc:move-to-end-of-line", "doc:select-to-previous-word-start" },
  ["<down>"] = { "doc:select-none", "doc:move-to-next-line", "doc:move-to-start-of-line", "doc:select-to-next-word-end" },
  [":"] = "core:find-command",
  ["<space>?"] = "modal:help",
}
```

### Helix Preset

For an almost full replica of the [Helix](helix-editor.com) modal experience please use the [lite-modal-hx](https://codeberg.org/Mandarancio/lite-modal-hx) preset.
