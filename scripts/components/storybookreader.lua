
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
		local story = book.components.storybook.story

		if story == nil or type(story) == "string" then
			return false
		end

		self.book = book

		book.components.storybook:OnRead(self.inst);

		local lines = {}

		for i, v in ipairs(story.beforelines) do
			table.insert(lines, { message = v.line, noanim = true, duration = tonumber(v.duration) })
		end

		for i, v in ipairs(story.lines) do
			table.insert(lines, { message = v.line, noanim = true, duration = tonumber(v.duration) })
		end

		self.inst.components.talker:Say(lines, nil, true, true)

		self.inst:ListenForEvent("donetalking", on_done_talking)

		return true
	end

	return false
end


return StoryBookReader
