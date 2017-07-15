local Env = getfenv()
wrapObjects = function(Obj)
    local New = newproxy(true)
    local Fake = getmetatable(New)
    if (typeof(Obj) ~= "Instance") then return end
    Fake.__index = function(Self, Method)
        if (Method == "getChildren") then
            return function() return Obj:GetChildren() end
        end
        if (Method == "service") then
            return function(q, w)
                local Ran, Res = pcall(function()
                    Env.game:GetService(w)
                end)
                if Ran then
                    return Env.game:GetService(w)
                end
            end
        end
        if (Method == "findFirstChild") then
            return function(q, w)
                return Obj:FindFirstChild(w)
            end
        end
        if (Method == "kill") then
            return function(q)
                if (typeof(q) == "Instance") then
                    if (q.className == "Player") then
                        if (q.Character) then
                            q.Character:breakJoints()
                        end
                    end
                end
            end
        end
        return wrapObjects(Obj[Method])
    end
    Fake.__newindex = function() return end
    Fake.__tostring = function() return New end
    Fake.__metatable = false
    return New
end
return wrapObjects
