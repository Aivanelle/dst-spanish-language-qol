name = "Un ajuste al español"
version = "1.1"
author = "Aivan"
description = "Un mod encargado principalmente de mostrar los adjetivos de los objetos en el orden correcto del idioma español.\n" ..
  "Este mod funciona con cualquier mod de traducción, pero fue hecho para trabajar de una mejor manera con la traducción hecha por joshua_vlad.\n\n" ..
  "Versión " .. version

api_version = 10

dst_compatible = true
dont_starve_compatible = false
client_only_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
  {
    name = "unknownAdjectives",
    label = "Adjetivos desconocidos",
    hover = "Muestra u oculta los adjetivos de objetos desconocidos para el mod, como pueden ser aquellos agregados por nuevas actualizaciones u otros mods.",
    options =
    {
      {
        description = "Por defecto",
        data = "default",
        hover = "Utiliza los adjetivos por defecto incluidos en tu mod de traducción."
      },
      {
        description = "Ocultar",
        data = "hide",
        hover = "Solo verás el nombre del objeto, sin palabras extra añadidas."
      }
    },
    default = "default"
  }
}
