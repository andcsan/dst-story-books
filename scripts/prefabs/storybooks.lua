local assets =
{
    Asset("ANIM", "anim/books.zip"),
}

local prefabs = {
    "bookaura_proxy"
}

local function MakeStoryBook(name, book_def)
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
        inst.components.storybook:SetTitle(book_def.title)
        inst.components.storybook:SetSections(book_def.sections)
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

    return Prefab("storybook_"..name, fn, assets, prefabs)
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
    inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL
	inst.components.sanityaura.fallofffn = function (inst, observer, distsq)
        return 1
    end

    inst.Setup = SetupBookAura

	return inst
end

local books = {}

for i, v in pairs(require("storybooks")) do
    table.insert(books, MakeStoryBook(i, v))
end

return unpack(books),
    Prefab("bookaura_proxy", bookaura_proxy_fn)
