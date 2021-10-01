local on_read_sanity_aura_fn = function(inst, reader)
  if inst ~= nil then
    inst.bookaura_proxy = SpawnPrefab("bookaura_proxy")
    inst.bookaura_proxy:Setup(inst)
  end
end

local on_done_sanity_aura_fn = function(inst, reader)
  if inst.bookaura_proxy ~= nil and inst.bookaura_proxy:IsValid() then
    inst.bookaura_proxy:Remove()
    inst.bookaura_proxy = nil
  end
end

local books = {
  hobbit = {
    title = "The Hobbit",
    onreadfn = on_read_sanity_aura_fn,
    ondonefn = on_done_sanity_aura_fn,
    sections = {{
      title = "",
      lines = {{
        duration = 3,
        line = "In a hole in the ground there lived a hobbit."
      }, {
        duration = 3,
        line = "Not a nasty, dirty, wet hole,"
      }, {
        duration = 4,
        line = "filled with the ends of worms and an oozy smell,"
      }, {
        duration = 3,
        line = "nor yet a dry, bare,"
      }, {
        duration = 4,
        line = "sandy hole with nothing in it to sit down on or to eat:"
      }, {
        duration = 3,
        line = "it was a hobbit-hole, and that means comfort."
      }, {
        duration = 4,
        line = "It had a perfectly round door like a porthole,painted green,"
      }, {
        duration = 3,
        line = "with a shiny yellow brass knob in the exact middle."
      }, {
        duration = 3,
        line = "The door opened on to a tubeshaped hall like a tunnel:"
      }, {
        duration = 3,
        line = "a very comfortable tunnel without smoke,"
      }, {
        duration = 3,
        line = "with panelled walls, and floors tiled and carpeted,"
      }, {
        duration = 2,
        line = "provided with polished chairs,"
      }, {
        duration = 3,
        line = "and lots and lots of pegs for hats and coats"
      }, {
        duration = 3,
        line = "- the hobbit was fond of visitors."
      }, {
        duration = 2,
        line = "The tunnel wound on and on,"
      }, {
        duration = 4,
        line = "going fairly but not quite straight into the side of the hill"
      }, {
        duration = 4,
        line = "- The Hill, as all the people for many miles round called it"
      }, {
        duration = 3,
        line = "- and many little round doors opened out of it,"
      }, {
        duration = 3,
        line = "first on one side and then on another."
      }, {
        duration = 3,
        line = "No going upstairs for the hobbit:"
      }, {
        duration = 2,
        line = "bedrooms, bathrooms, cellars,"
      }, {
        duration = 2,
        line = "pantries (lots of these),"
      }, {
        duration = 3,
        line = "wardrobes (he had whole rooms devoted to clothes),"
      }, {
        duration = 3,
        line = "kitchens, dining-rooms, all were on the same floor,"
      }, {
        duration = 2,
        line = "and indeed on the same passage."
      }, {
        duration = 4,
        line = "The best rooms were all on the left-hand side (going in),"
      }, {
        duration = 3,
        line = "for these were the only ones to have windows,"
      }, {
        duration = 4,
        line = "deep-set round windows looking over his garden and meadows beyond,"
      }, {
        duration = 2,
        line = "sloping down to the river."
      }, {
        duration = 3,
        line = "This hobbit was a very well-to-do hobbit,"
      }, {
        duration = 2,
        line = "and his name was Baggins."
      }, {
        duration = 4,
        line = "The Bagginses had lived in the neighbourhood of The Hill for time out of mind,"
      }, {
        duration = 3,
        line = "and people considered them very respectable,"
      }, {
        duration = 3,
        line = "not only because most of them were rich,"
      }, {
        duration = 3,
        line = "but also because they never had any adventures"
      }, {
        duration = 2,
        line = "or did anything unexpected:"
      }, {
        duration = 3,
        line = "you could tell what a Baggins would say on any question"
      }, {
        duration = 3,
        line = "without the bother of asking him."
      }, {
        duration = 3,
        line = "This is a story of how a Baggins had an adventure,"
      }, {
        duration = 3,
        line = "found himself doing and saying things altogether unexpected."
      }, {
        duration = 3,
        line = "He may have lost the neighbours' respect,"
      }, {
        duration = 2,
        line = "but he gained-well,"
      }, {
        duration = 5,
        line = "you will see whether he gained anything in the end."
      }}
    }, {
      title = "",
      lines = {{
        duration = 3,
        line = "\"Good morning!\" said Bilbo,"
      }, {
        duration = 3,
        line = "and he meant it. The sun was shining,"
      }, {
        duration = 4,
        line = "and the grass was very green."
      }, {
        duration = 2,
        line = "But Gandalf looked at him"
      }, {
        duration = 3,
        line = "from under long bushy eyebrows"
      }, {
        duration = 4,
        line = "that stuck out further than the brim of his shady hat."
      }, {
        duration = 3,
        line = "\"What do you mean?\" he said."
      }, {
        duration = 3,
        line = "\"Do you wish me a good morning,"
      }, {
        duration = 3,
        line = "or mean that it is a good morning"
      }, {
        duration = 2,
        line = "whether I want not;"
      }, {
        duration = 3,
        line = "or that you feel good this morning;"
      }, {
        duration = 3,
        line = "or that it is morning to be good on?\""
      }, {
        duration = 3,
        line = "\"All of them at once,\" said Bilbo."
      }, {
        duration = 4,
        line = "[...] \"I am looking for someone to share in an adventure"
      }, {
        duration = 2,
        line = "that I am arranging,"
      }, {
        duration = 4,
        line = "and it's very difficult to find anyone.\" said Gandalf."
      }, {
        duration = 3,
        line = "I should think so - in these parts!"
      }, {
        duration = 4,
        line = "We are plain quiet folk and have no use for adventures."
      }, {
        duration = 3,
        line = "Nasty disturbing uncomfortable things!"
      }, {
        duration = 2,
        line = "Make you late for dinner!"
      }, {
        duration = 3,
        line = "I can't think what anybody sees in them,"
      }, {
        duration = 2,
        line = "said our Mr. Baggins."
      }, {
        duration = 3,
        line = "[...] \"Good morning!\" he said at last."
      }, {
        duration = 3,
        line = "\"We don't want any adventures here, thank you!"
      }, {
        duration = 3,
        line = "You might try over The Hill or across The Water.\""
      }, {
        duration = 5,
        line = "By this he meant that the conversation was at an end."
      }}
    }}
  }
}

return books
