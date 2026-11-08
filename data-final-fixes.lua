---------------------------------------------------------------------------------------------------
---[ data-final-fixes.lua ]---
---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Información del MOD ]---
---------------------------------------------------------------------------------------------------

local This_MOD = GMOD.get_id_and_name()
if not This_MOD then return end
GMOD[This_MOD.id] = This_MOD

---------------------------------------------------------------------------------------------------

function This_MOD.start()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Valores de la referencia
    This_MOD.reference_values()

    --- Obtener los elementos
    This_MOD.get_elements()

    --- Modificar los elementos
    for _, spaces in pairs(This_MOD.to_be_processed) do
        for _, space in pairs(spaces) do
            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

            --- Crear los elementos
            This_MOD.create_item(space)
            This_MOD.create_entity(space)
            This_MOD.create_recipe(space)
            This_MOD.create_tech(space)

            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        end
    end

    --- Valores a usar en control.lua
    This_MOD.load_styles()
    This_MOD.load_icon()
    This_MOD.load_sound()

    --- Ocultar elementos
    This_MOD.hidden___Earendel()

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.reference_values()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Contenedor de los elementos que el MOD modoficará
    This_MOD.to_be_processed = {}

    --- Validar si se cargó antes
    if This_MOD.setting then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores de la referencia en todos los MODs
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Cargar la configuración
    This_MOD.setting = GMOD.setting[This_MOD.id] or {}

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores de la referencia en este MOD
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- IDs de las entidades
    This_MOD.id_sender = "A01A"
    This_MOD.id_receiver = "A02A"

    --- Nombre de las entidades
    This_MOD.name_sender = GMOD.name .. "-" .. This_MOD.id_sender .. "-sender"
    This_MOD.name_receiver = GMOD.name .. "-" .. This_MOD.id_receiver .. "-receiver"

    --- Nombre de la tecnología
    This_MOD.name_tech = This_MOD.prefix .. "transmission-tech"

    --- Ruta a los multimedias
    This_MOD.path_sound = "__" .. This_MOD.prefix .. This_MOD.name .. "__/sound/"

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Valores originales
    This_MOD.aai_sender = "aai-signal-sender"
    This_MOD.aai_receiver = "aai-signal-receiver"
    This_MOD.aai_filter = "aai-filter"
    This_MOD.aai_tech = "aai-signal-transmission"

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Cambios del MOD ]---
---------------------------------------------------------------------------------------------------

function This_MOD.get_elements()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if GMOD.entity[This_MOD.name_sender] then return end
    if GMOD.entity[This_MOD.name_receiver] then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores para el proceso
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Space = {}
    Space.filter = data.raw["decider-combinator"][This_MOD.aai_filter]
    Space.tech = data.raw.technology[This_MOD.aai_tech]

    Space.entity_sender = GMOD.entity[This_MOD.aai_sender]
    Space.entity_receiver = GMOD.entity[This_MOD.aai_receiver]

    Space.item_sender = GMOD.item[This_MOD.aai_sender]
    Space.item_receiver = GMOD.item[This_MOD.aai_receiver]

    Space.recipe_sender = data.raw.recipe[This_MOD.aai_sender]
    Space.recipe_receiver = data.raw.recipe[This_MOD.aai_receiver]

    for key, value in pairs(Space) do
        Space[key] = GMOD.copy_with_format(value)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if GMOD.get_length(Space) ~= 8 then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Guardar la información
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.to_be_processed.entities = This_MOD.to_be_processed.entities or {}
    This_MOD.to_be_processed.entities[Space.filter.name] = Space

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------

function This_MOD.create_item(space)
    --- Emisor
    local Sender = space.item_sender
    Sender.name = This_MOD.name_sender
    Sender.place_result = This_MOD.name_sender

    --- Receptor
    local Receiver = space.item_receiver
    Receiver.name = This_MOD.name_receiver
    Receiver.place_result = This_MOD.name_receiver

    --- Crear el prototipo
    GMOD.extend(Sender, Receiver)
end

function This_MOD.create_entity(space)
    --- Emisor
    local Sender = space.entity_sender
    Sender.minable.results[1].name = This_MOD.name_sender
    Sender.name = This_MOD.name_sender

    --- Receptor
    local Receiver = space.entity_receiver
    Receiver.minable.results[1].name = This_MOD.name_receiver
    Receiver.name = This_MOD.name_receiver

    --- Combinador
    local Filter = space.filter
    Filter.minable.results = nil
    Filter.name = This_MOD.prefix .. Filter.type

    --- Crear el prototipo
    GMOD.extend(Sender, Receiver, Filter)
end

function This_MOD.create_recipe(space)
    --- Emisor
    local Sender = space.recipe_sender
    Sender.name = This_MOD.name_sender
    Sender.results[1].name = This_MOD.name_sender

    --- Receptor
    local Receiver = space.recipe_receiver
    Receiver.name = This_MOD.name_receiver
    Receiver.results[1].name = This_MOD.name_receiver

    --- Crear el prototipo
    GMOD.extend(Sender, Receiver)
end

function This_MOD.create_tech(space)
    --- Tecnología base
    local Tech = space.tech
    Tech.name = This_MOD.name_tech
    Tech.effects = {
        { type = "unlock-recipe", recipe = This_MOD.name_sender },
        { type = "unlock-recipe", recipe = This_MOD.name_receiver }
    }

    --- Crear el prototipo
    GMOD.extend(Tech)
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
--- [ Valores a usar en control.lua ] ---
---------------------------------------------------------------------------------------------------

function This_MOD.load_styles()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores a usar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Cambiar los guiones del nombre
    local Prefix = string.gsub(This_MOD.prefix, "%-", "_")

    --- Renombrar
    local Styles = data.raw["gui-style"].default

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Multiuso
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    Styles[Prefix .. "flow_vertival_8"] = {
        type = "vertical_flow_style",
        vertical_spacing = 8
    }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cabeza
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    Styles[Prefix .. "flow_head"] = {
        type = "horizontal_flow_style",
        horizontal_spacing = 8,
        bottom_padding = 7
    }

    Styles[Prefix .. "label_title"] = {
        type = "label_style",
        parent = "frame_title",
        button_padding = 3,
        top_margin = -3
    }

    Styles[Prefix .. "empty_widget"] = {
        type = "empty_widget_style",
        parent = "draggable_space",
        horizontally_stretchable = "on",
        vertically_stretchable = "on",
        height = 24
    }

    Styles[Prefix .. "button_close"] = {
        type = "button_style",
        parent = "close_button",
        left_click_sound = "__core__/sound/gui-tool-button.ogg",
        padding = 2,
        margin = 0,
        size = 24
    }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cuerpo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    Styles[Prefix .. "frame_entity"] = {
        type = "frame_style",
        parent = "entity_frame",
        padding = 0
    }

    Styles[Prefix .. "frame_body"] = {
        type = "frame_style",
        parent = "entity_frame",
        padding = 4
    }

    Styles[Prefix .. "drop_down_channels"] = {
        type = "dropdown_style",
        parent = "dropdown",
        list_box_style = {
            type = "list_box_style",
            maximal_height = 320,
            item_style = {
                type = "button_style",
                parent = "list_box_item",
                left_click_sound = "__core__/sound/wire-connect-pole.ogg",
            },
        },
        width = 296 + 32
    }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Nuevo canal
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    Styles[Prefix .. "button_red"] = {
        type = "button_style",
        parent = "tool_button_red",
        left_click_sound = "__core__/sound/gui-tool-button.ogg",
        padding = 0,
        margin = 0,
        size = 28
    }

    Styles[Prefix .. "button_green"] = {
        type = "button_style",
        parent = "tool_button_green",
        left_click_sound = This_MOD.path_sound .. "empty_audio.ogg",
        padding = 0,
        margin = 0,
        size = 28
    }

    Styles[Prefix .. "button_blue"] = {
        type = "button_style",
        parent = "tool_button_blue",
        left_click_sound = "__core__/sound/gui-tool-button.ogg",
        padding = 0,
        margin = 0,
        size = 28
    }

    Styles[Prefix .. "button_add"] = {
        type = "button_style",
        parent = Prefix .. "button_blue",
        left_click_sound = "__core__/sound/wire-connect-pole.ogg",
    }

    Styles[Prefix .. "button"] = {
        type = "button_style",
        parent = "button",
        left_click_sound = "__core__/sound/gui-tool-button.ogg",
        top_margin = 1,
        padding = 0,
        size = 28
    }

    Styles[Prefix .. "stretchable_textfield"] = {
        type = "textbox_style",
        width = 296
    }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.load_icon()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Name = GMOD.name .. "-icon"
    if data.raw["virtual-signal"][Name] then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Crear la señal
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.extend({
        type = "virtual-signal",
        name = Name,
        localised_name = "",
        icon = This_MOD.path_graphics .. "icons/select-icon-black.png",
        icon_size = 40,
        subgroup = "virtual-signal",
        order = "z-z-o"
    })

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.load_sound()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.extend({
        type = "sound",
        name = "gui_tool_button",
        filename = "__core__/sound/gui-tool-button.ogg",
        volume = 1.0
    })

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
--- [ Ocultar las antenas de Earendel ] ---
---------------------------------------------------------------------------------------------------

function This_MOD.hidden___Earendel()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Ocultar las creaciones los elementos
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, name in pairs({
        "aai-signal-sender",
        "aai-signal-receiver",
        "aai-filter"
    }) do
        local Item = GMOD.item[name] or {}
        local Entity = GMOD.entity[name] or {}
        local Recipe = data.raw.recipe[name] or {}

        Item.hidden = true
        Entity.hidden = true
        Recipe.hidden = true

        GMOD.item[name] = nil
        GMOD.recipes[name] = nil
        GMOD.entity[name] = nil
    end

    data.raw.technology["aai-signal-transmission"].hidden = true

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Iniciar el MOD ]---
---------------------------------------------------------------------------------------------------

This_MOD.start()

---------------------------------------------------------------------------------------------------
