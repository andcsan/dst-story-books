local StoryBookReader = Class(function(self, inst)
  self.inst = inst
  self.book = nil;
  self.inst:AddTag("storybookreader")
end)

function StoryBookReader:OnRemoveFromEntity()
  self.inst:RemoveTag("storybookreader")
end

local function on_done_talking(inst)
  local self = inst.components.storybookreader

  if self ~= nil then
    self:OnDone()
  end
end

function StoryBookReader:OnDone()
  self.inst:RemoveEventCallback("donetalking", on_done_talking)

  if self.book ~= nil and self.book.components.storybook ~= nil then
    self.book.components.storybook:OnDone(self.inst)
  end

  self.book = nil
end

function StoryBookReader:Read(book)
  if book ~= nil and book.components.storybook ~= nil then
    local title = book.components.storybook.title
    local sections = book.components.storybook.sections

    if sections == nil or type(sections) ~= "table" then
      return false
    end

    self.book = book

    book.components.storybook:OnRead(self.inst)

    local lines = {}

    if title ~= nil and type(title) == "string" then
      table.insert(lines, {
        message = title,
        noanim = true,
        duration = 3.0
      })
    end

    local section = sections[math.random(#sections)]

    for i, v in ipairs(section.lines) do
      table.insert(lines, {
        message = v.line,
        noanim = true,
        duration = tonumber(v.duration)
      })
    end

    self.inst.components.talker:Say(lines, nil, true, true)
    self.inst:ListenForEvent("donetalking", on_done_talking)

    return true
  end

  return false
end

return StoryBookReader
