local core = require "core"
local common = require "core.common"
local config = require "core.config"
local keymap = require "core.keymap"
local style = require "core.style"
local View = require "core.view"


local item_height_result = {}
  

local function get_item_height(item)
  local h = item_height_result[item]
  if not h then
    h = {}
    h.normal = style.code_font:get_height() + style.padding.y
    h.current = h.normal
    h.target = h.current
    item_height_result[item] = h
  end
  return h
end


local KeyMapView = View:extend()



function KeyMapView:new(mode, helpers)
  KeyMapView.super.new(self)
  self.helpers = helpers
  self.padding = 1
  if self.helpers == nil then
    self.helpers = {}
  end
  for _, k in ipairs(self.helpers) do
    if #k[1] + 1 > self.padding then
      self.padding = #k[1] + 1
    end
  end
  self.mode = mode
  if self.mode == nil then
    self.mode = ""
  end
  self.scrollable = true
  self.yoffset = 0
end

function KeyMapView:get_name()
  return "Keymap " .. self.mode
end

local function spaced(str, pad)
  local res = str
  if #str < pad then
    for _ = 1, pad - #str do
      res = res .. ' '
    end
  end
  return res
end

function KeyMapView:each_item()
  local x, y = self:get_content_offset()
  y = y + style.padding.y + self.yoffset
  return coroutine.wrap(function()
    for _, v in ipairs(self.helpers) do
      local item = spaced(v[1], self.padding) .. ": " .. v[2]
      local h = get_item_height(item).current
      coroutine.yield(item, x, y, self.size.x, h)
      y = y + h
    end
  end)
end

function KeyMapView:get_scrollable_size()
  local _, y_off = self:get_content_offset()
  local last_y, last_h = 0, 0
  for _, _, y, _, h in self:each_item() do
    last_y, last_h = y, h
  end
  if not config.scroll_past_end then
    return last_y + last_h - y_off + style.padding.y
  end
  return last_y + self.size.y - y_off
end

function KeyMapView:on_mouse_pressed(button, px, py, clicks)
  if KeyMapView.super.on_mouse_pressed(self, button, px, py, clicks) then
    return true
  end

  local index, selected
  for item, x, y, w, h in self:each_item() do
    if px >= x and py >= y and px < x + w and py < y + h then
      selected = item
      break
    end
  end

  if selected then
    if keymap.modkeys["ctrl"] then
      system.set_clipboard(core.get_log(selected))
      core.status_view:show_message("i", style.text, "copied entry #" .. index .. " to clipboard.")
    end
  end

  return true
end

function KeyMapView:update()
  local item = core.log_items[#core.log_items]
  if self.last_item ~= item then
    local lh = style.code_font:get_height() + style.padding.y
    if 0 < self.scroll.to.y then
      local index = #core.log_items
      while index > 1 and self.last_item ~= core.log_items[index] do
        index = index - 1
      end
      local diff_index = #core.log_items - index
      self.scroll.to.y = self.scroll.to.y + diff_index * lh
      self.scroll.y = self.scroll.to.y
    else
      self.yoffset = -lh
    end
    self.last_item = item
  end


  self:move_towards("yoffset", 0, nil, "keymap")

  KeyMapView.super.update(self)
end

-- this is just to get a date string that's consistent
function KeyMapView:draw()
  self:draw_background(style.background)

  local th = style.code_font:get_height()
  local lh = th + style.padding.y -- for one line

  for item, x, y, w, h in self:each_item() do
    if y + h >= self.position.y and y <= self.position.y + self.size.y then
      core.push_clip_rect(x, y, w, h)
      x = x + style.padding.x


      w = w - (x - self:get_content_offset())

      common.draw_text(style.code_font, style.text, item, "left", x, y, w, lh)
      core.pop_clip_rect()
    end
  end
  KeyMapView.super.draw_scrollbar(self)
end

return KeyMapView

