local M = {}

local function nearest_matching_brace(flags)
    return unpack(vim.api.nvim_call_function('searchpairpos', {'(', '', ')', flags}))
end

function M.move_next_matching_brace()
    nearest_matching_brace('W')
end

function M.move_prev_matching_brace()
    nearest_matching_brace('bW')
end

return M
