PrefabFiles = {"storybooks"}

AddPrefabPostInitAny(function(inst)
  if inst:HasTag("player") and inst:HasTag("reader") then
    inst:AddComponent("storybookreader")
  end
end)

AddRecipe("storybook_hobbit", {Ingredient("papyrus", 2), Ingredient("bluegem", 2)}, GLOBAL.CUSTOM_RECIPETABS.BOOKS,
  GLOBAL.TECH.NONE, nil, nil, nil, nil, nil, "images/inventoryimages.xml", "book_gardening.tex")

GLOBAL.STRINGS.NAMES.STORYBOOK_HOBBIT = "The Hobbit"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.STORYBOOK_HOBBIT = "The Hobbit"
GLOBAL.STRINGS.RECIPE_DESC.STORYBOOK_HOBBIT = "Join on an epic fantasy!"

local READSTORY = AddAction("READSTORY", "Read story", function(act)
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

local State = GLOBAL.State
local EventHandler = GLOBAL.EventHandler
local TimeEvent = GLOBAL.TimeEvent
local CanEntitySeeTarget = GLOBAL.CanEntitySeeTarget
local FRAMES = GLOBAL.FRAMES
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS

local function StopTalkSound(inst, instant)
  if not instant and inst.endtalksound ~= nil and inst.SoundEmitter:PlayingSound("talk") then
    inst.SoundEmitter:PlaySound(inst.endtalksound)
  end
  inst.SoundEmitter:KillSound("talk")
end

AddStategraphState("wilson", State {
  name = "storybook_open",
  tags = {"doing", "nodangle"},

  onenter = function(inst)
    inst.sg.statemem.action = inst.bufferedaction
    inst.components.locomotor:Stop()
    if not inst:PerformBufferedAction() then
      inst.sg.statemem.not_interupted = true
      inst.sg:GoToState("idle")
    else
      inst.AnimState:OverrideSymbol("book_cook", "cookbook", "book_cook")
      inst.AnimState:PlayAnimation("action_uniqueitem_pre")
      inst.AnimState:PushAnimation("reading_in", false)
      inst.AnimState:PushAnimation("reading_loop", false)
    end
  end,

  events = {EventHandler("ontalk", function(inst)
    inst.sg.statemem.started = true
  end), EventHandler("donetalking", function(inst)
    if inst.sg.statemem.started then
      inst.sg:GoToState("storybook_close")
    end
  end), EventHandler("animover", function(inst)
    if inst.AnimState:AnimDone() then
      inst.sg.statemem.not_interupted = true
      inst.sg:GoToState("storybook_loop")
    end
  end)},

  onexit = function(inst)
    if inst.bufferedaction == inst.sg.statemem.action and
      (inst.components.playercontroller == nil or inst.components.playercontroller.lastheldaction ~= inst.bufferedaction) then
      inst:ClearBufferedAction()
    end
    if not inst.sg.statemem.not_interupted then
      StopTalkSound(inst, true)
      if inst.components.talker ~= nil then
        inst.components.talker:ShutUp()
      end
    end
  end
})

AddStategraphState("wilson", State {
  name = "storybook_loop",
  tags = {"doing", "nodangle"},

  onenter = function(inst)
    inst.components.locomotor:Stop()
    inst.AnimState:PushAnimation("reading_loop", false)
  end,

  events = {EventHandler("animover", function(inst)
    if inst.AnimState:AnimDone() then
      inst.sg.statemem.not_interupted = true
      inst.sg:GoToState("storybook_loop")
    end
  end), EventHandler("donetalking", function(inst)
    inst.sg.statemem.not_interupted = true
    StopTalkSound(inst, true)
    inst.sg:GoToState("storybook_close")
  end)},

  onexit = function(inst)
    if not inst.sg.statemem.not_interupted then
      StopTalkSound(inst, true)
      if inst.components.talker ~= nil then
        inst.components.talker:ShutUp()
      end
    end
  end
})

AddStategraphState("wilson", State {
  name = "storybook_close",
  tags = {"doing", "nodangle"},

  onenter = function(inst)
    inst.components.locomotor:Stop()
    inst.AnimState:PlayAnimation("reading_pst")
  end,

  events = {EventHandler("animover", function(inst)
    if inst.AnimState:AnimDone() then
      inst.sg:GoToState(inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil and "item_out" or "idle")
    end
  end)},

  onexit = function(inst)
    if not inst.sg.statemem.not_interupted then
      StopTalkSound(inst, true)
      if inst.components.talker ~= nil then
        inst.components.talker:ShutUp()
      end
    end
  end
})

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(READSTORY, "storybook_open"))
-- AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(READSTORY, "storybook_open"))
