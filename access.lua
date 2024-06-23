local ngx = require("ngx")

local function check_access_using_cookie()
    local raw_cookie_header = ngx.req.get_headers()["Cookie"]

    if type(raw_cookie_header) ~= "string" then
        return false
    end

    local raw_cookie = raw_cookie_header

    return raw_cookie == "secret"
end

local function check_access_using_db()
    local handle = io.popen([[sqlite3 access.db "select is_premium from user where id='abc-def' limit 1;"]]);

    if handle == nil then
        ngx.say("Failed to open database")
        return false
    end

    local result = string.sub(1, 1, handle:read("*a"))

    handle:close()

    return result == "1"
end


if check_access_using_db() then
    return
else
    ngx.say("Access denied")
    -- ngx.redirect("/login")
end

