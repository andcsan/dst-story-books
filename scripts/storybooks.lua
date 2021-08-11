local books =
{
    hobbit =
    {
        name = "The Hobbit",

        onreadfn = function (inst, reader)
            if inst ~= nil then
                inst.bookaura_proxy = SpawnPrefab("bookaura_proxy")
                inst.bookaura_proxy:Setup(inst)
            end
        end,

        ondonefn = function (inst, reader)
            if inst.bookaura_proxy ~= nil and inst.bookaura_proxy:IsValid() then
                inst.bookaura_proxy:Remove()
                inst.bookaura_proxy = nil
            end
        end,

        sections =
        {
            {
                title = "",
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
        }
    }
}

return books
