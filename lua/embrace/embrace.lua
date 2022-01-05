local M = {}

local function nearest_matching_brace(flags)
    return unpack(vim.api.nvim_call_function('searchpairpos', {'(', '', ')', flags}))
end

local function char_under_cursor()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    return vim.api.nvim_get_current_line():sub(col+1,col+1)
end

function M.move_next_matching_brace()
    nearest_matching_brace('W')
end

function M.move_prev_matching_brace()
    nearest_matching_brace('bW')
end

function M.insert_before_list()
    if char_under_cursor() ~= ')' then
        nearest_matching_brace('W')
    end
    vim.api.nvim_put({')'}, 'c', false, false)

    nearest_matching_brace('bW')
    vim.api.nvim_put({'( '}, 'c', false, false)

    vim.api.nvim_command('startinsert')
end

function M.insert_after_list()
    if char_under_cursor() ~= '(' then
        nearest_matching_brace('bW')
    end

    vim.api.nvim_put({'('}, 'c', false, false)

    nearest_matching_brace('W')
    vim.api.nvim_put({' )'}, 'c', false, false)

    vim.api.nvim_command('startinsert')
end

return M
