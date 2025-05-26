local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#fcfcfc" }  -- Docview
style.background2 = { common.color "#fcfcfc" } -- Treeview
style.background3 = { common.color "#ececec" } -- Command view
style.text = { common.color "#7c8186" } -- default text color
style.caret = { common.color "#ffaa33" }
style.accent = { common.color "#5c6166" } -- selected object text color
-- style.dim - text color for nonactive tabs, tabs divider, prefix in log and
-- search result, hotkeys for context menu and command view
style.dim = { common.color "#bcc1c6" }
style.divider = { common.color "#fcfcfc" } -- Line between nodes
style.selection = { common.color "#036dd626" }
style.line_number = { common.color "#8a919966" }
style.line_number2 = { common.color "#777777" } -- With cursor
style.line_highlight = { common.color "#dcdcdc" } -- every highlighted line in docview, treeview, and commandview
style.scrollbar = { common.color "#cccccc" }
style.scrollbar2 = { common.color "#bcbcbc" } -- Hovered
style.scrollbar_track = { common.color "#dcdcdc" }
style.nagbar = { common.color "#FF7777" }
style.nagbar_text = { common.color "#FFFFFF" }
style.nagbar_dim = { common.color "rgba(0, 0, 0, 0.45)" }
style.drag_overlay = { common.color "rgba(200,200,200,0.45)" }
style.drag_overlay_tab = { common.color "#93DDFA" }
style.good = { common.color "#72b886" }
style.warn = { common.color "#FFA94D" }
style.error = { common.color "#ff6666" }
style.modified = { common.color "#1c7c9c" }

style.syntax["normal"] = { common.color "#5c6166" }
style.syntax["symbol"] = { common.color "#f07171" } -- object's property, class name
style.syntax["comment"] = { common.color "#787b8099" }
style.syntax["keyword"] = { common.color "#fa8d3e" }  -- local function end if case namespace use const
style.syntax["keyword2"] = { common.color "#55b4d4" } --  self int float, function parameter, function variable, class property
style.syntax["number"] = { common.color "#ffaa33" } -- numeric value, const name, null
style.syntax["literal"] = { common.color "#f07171" }  -- true false nil
style.syntax["string"] = { common.color "#86b300" }
style.syntax["operator"] = { common.color "#ed9366" } -- = + - / < >
style.syntax["function"] = { common.color "#f2ae49" }

style.log["INFO"]  = { icon = "i", color = style.text }
style.log["WARN"]  = { icon = "!", color = style.warn }
style.log["ERROR"] = { icon = "!", color = style.error }
