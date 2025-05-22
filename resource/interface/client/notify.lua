---@alias NotificationPosition 'top' | 'top-right' | 'top-left' | 'bottom' | 'bottom-right' | 'bottom-left' | 'center-right' | 'center-left'
---@alias NotificationType 'info' | 'warning' | 'success' | 'error'
---@alias IconAnimationType 'spin' | 'spinPulse' | 'spinReverse' | 'pulse' | 'beat' | 'fade' | 'beatFade' | 'bounce' | 'shake'

---@class NotifyProps
---@field id? string
---@field title? string
---@field description? string
---@field duration? number
---@field showDuration? boolean
---@field position? NotificationPosition
---@field type? NotificationType
---@field style? { [string]: any }
---@field icon? string | { [1]: any, [2]: string }
---@field iconAnimation? IconAnimationType
---@field iconColor? string
---@field alignIcon? 'top' | 'center'
---@field sound? { bank?: string, set: string, name: string }

-- Si necesitas alguna configuración adicional, asegúrate de tener un archivo de configuración.
local settings = require 'resource.settings'

-- Asegúrate de que la tabla global "lib" esté inicializada.
lib = lib or {}

--- Envía una notificación delegando la lógica en el recurso origen_notify.
--- Se adapta el formato recibido (tabla con title, description y type)
--- al formato que espera origen_notify: ShowNotification(message, type)
---@param data NotifyProps
function lib.notify(data)
    -- Construir el mensaje final combinando título y descripción.
    local message = ""
    if data.title and data.description then
        message = data.title .. ": " .. data.description
    elseif data.title then
        message = data.title
    else
        message = data.description or ""
    end

    -- Definir el tipo de notificación (por defecto 'info' si no se especifica).
    local notifType = data.type or "info"
    if notifType == "inform" then
        notifType = "info"
    end

    -- Llama al recurso origen_notify pasando el mensaje y el tipo.
    return exports["origen_notify"]:ShowNotification(message, notifType)
end

---@class DefaultNotifyProps
---@field title? string
---@field description? string
---@field duration? number
---@field position? NotificationPosition
---@field status? 'info' | 'warning' | 'success' | 'error'
---@field id? number

--- Función de notificación por defecto para compatibilidad hacia versiones anteriores.
--- Convierte la propiedad "status" en "type" y llama a lib.notify.
---@param data DefaultNotifyProps
function lib.defaultNotify(data)
    data.type = data.status
    if data.type == "inform" then
        data.type = "info"
    end
    return lib.notify(data)
end

-- Registra los eventos para que otros recursos puedan utilizar las notificaciones centralizadas.
RegisterNetEvent("ox_lib:notify")
AddEventHandler("ox_lib:notify", lib.notify)

RegisterNetEvent("ox_lib:defaultNotify")
AddEventHandler("ox_lib:defaultNotify", lib.defaultNotify)