local assets =
{
    Asset("ANIM", "anim/books.zip"),
}

local prefabs = {
    "bookaura_proxy"
}

local function MakeStoryBook(book_def)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("books")
        inst.AnimState:SetBuild("books")
        inst.AnimState:PlayAnimation("book_gardening")

        MakeInventoryFloatable(inst, "med", nil, 0.75)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        -----------------------------------

        inst:AddComponent("inspectable")

        inst:AddComponent("storybook")
        inst.components.storybook:SetStory(book_def.story)
        inst.components.storybook:SetOnReadFn(book_def.onreadfn)
        inst.components.storybook:SetOnDoneFn(book_def.ondonefn)

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "book_gardening"

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL

        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)

        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(book_def.name, fn, assets, prefabs)
end

local function bookaura_zoom_fn(params, parent, best_dist_sq)
	local pan_gain, heading_gain, distance_gain = TheCamera:GetGains()
	TheCamera:SetGains(1.5, heading_gain, distance_gain)
    TheCamera:SetDistance(18)
end

local function SetupBookAura(inst, book)
    inst.entity:SetParent(book.entity)
end

local function bookaura_proxy_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("NOBLOCK")

    TheFocalPoint.components.focalpoint:StartFocusSource(inst, nil, nil, 3, 4, -1, { ActiveFn = bookaura_zoom_fn })

    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("sanityaura")
	inst.components.sanityaura.max_distsq = 16 -- radius of 4
    inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL_TINY
	inst.components.sanityaura.fallofffn = function (inst, observer, distsq)
        return 1
    end

    inst.Setup = SetupBookAura

	return inst
end

local books_defs = {
    {
        name = "storybook_lotr",
        story = {
            title = 'The Lord of The Rings',
            beforelines = {
                {duration = 2.5, line = "Ok! Sit down everyone,"},
                {duration = 4.5, line = "I'm gonna read The Lord of The Rings!"},
            },
            continuelines = {
                {duration = 4.0, line = "Where did I stop? Aaah yes..."},
            },
            lines = {
                {duration = 2.5, line = "Early in the Second Age of Middle-earth,"},
                {duration = 3.0, line = "elven smiths forged nine Rings of Power for mortal men,"},
                {duration = 2.0, line = "seven for the Dwarf-Lords,"},
                {duration = 4.5, line = "and three for the Elf-Kings..."},
                {duration = 1.5, line = "At the same time, "},
                {duration = 4.5, line = "the Dark Lord Sauron made the One Ring to rule them all..."},
                {duration = 2.5, line = "As the Last Alliance of Elves and Men fell,"},
                {duration = 3.5, line = "the Ring fell into the hands of Prince Isildur."},
                {duration = 2.0, line = "After Isildur was killed by orcs,"},
                {duration = 4.5, line = "the Ring lay at the bottom of the river Anduin."},
                {duration = 3.0, line = "Over time, Sauron captured the nine Rings"},
                {duration = 3.0, line = "and turned their owners into the Ringwraiths,"},
                {duration = 4.5, line = "terrible beings who roamed the world searching for the One Ring."},
			}
        },

        onreadfn = function (inst, reader)
            if inst ~= nil then
                inst.bookaura_proxy = SpawnPrefab("bookaura_proxy")
                inst.bookaura_proxy:Setup(inst)
            end
        end,

        ondonefn = function (inst, reader)
            if inst.bookaura_proxy ~= nil and inst.bookaura_proxy:IsValid() then
                print("Removing bookaura prefab")
                inst.bookaura_proxy:Remove()
                inst.bookaura_proxy = nil
            end
        end
    }
}

local books = {}

for i, v in ipairs(books_defs) do
    table.insert(books, MakeStoryBook(v))
end

return unpack(books),
    Prefab("bookaura_proxy", bookaura_proxy_fn)
