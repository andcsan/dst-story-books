PrefabFiles = {
	"storybooks",
}

AddPrefabPostInitAny(function (inst)
	if inst:HasTag("player") then
		inst:AddComponent("storybookreader")
	end
end)

local READSTORY = AddAction("READSTORY", "Read story", function (act)
    local targ = act.invobject

    if targ ~= nil and act.doer ~= nil then
		if targ.components.storybook ~= nil and act.doer.components.storybookreader ~= nil then
			return act.doer.components.storybookreader:Read(targ)
		end
	end

	return true
end)

READSTORY.priority = 10

AddComponentAction("INVENTORY", "storybook", function(inst, doer, actions, right)
	if (doer:HasTag("storybookreader")) then
		table.insert(actions, GLOBAL.ACTIONS.READSTORY)
	end
end)

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(READSTORY, "dostorytelling"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(READSTORY, "dostorytelling"))

AddRecipe(
    "storybook_lotr",
	{Ingredient("papyrus", 2), Ingredient("bluegem", 2)},
    GLOBAL.CUSTOM_RECIPETABS.BOOKS,
    GLOBAL.TECH.NONE,
	nil, nil, nil, nil, nil, "images/inventoryimages.xml", "book_gardening.tex"
)

GLOBAL.STRINGS.NAMES.STORYBOOK_LOTR = "The Lord of The Rings"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.STORYBOOK_LOTR = "Definitely my favorite one!"
GLOBAL.STRINGS.RECIPE_DESC.STORYBOOK_LOTR = "Join on an epic fantasy!"