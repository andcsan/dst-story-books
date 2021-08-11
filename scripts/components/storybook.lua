
local StoryBook = Class(function(self, inst)
    self.inst = inst

	self.inst:AddTag("storybook")
end)

function StoryBook:SetTitle(title)
	self.title = title
end

function StoryBook:SetSections(sections)
	self.sections = sections
end

function StoryBook:SetOnReadFn(onreadfn)
	self.onreadfn = onreadfn
end

function StoryBook:SetOnDoneFn(ondonefn)
	self.ondonefn = ondonefn
end

function StoryBook:OnRead(reader)
	if self.onreadfn ~= nil and reader ~= nil then
		self.onreadfn(self.inst, reader)
	end
end

function StoryBook:OnDone(reader)
	if self.ondonefn ~= nil and reader ~= nil then
		self.ondonefn(self.inst, reader)
	end
end

return StoryBook
