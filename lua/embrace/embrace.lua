local M = {}

local function nearest_matching_brace(flags)
    return unpack(vim.api.nvim_call_function('searchpairpos', {'(', '', ')', flags}))
end

local function char_under_cursor()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    return vim.api.nvim_get_current_line():sub(col+1,col+1)
end

local function find_elem_start()
    return unpack(vim.api.nvim_call_function('searchpos', {[[(\|\s]], 'bW'}))
end

local function find_elem_end()
    return unpack(vim.api.nvim_call_function('searchpos', {[[)\|\s]], 'W'}))
end

local function prev_elem_start()
    vim.api.nvim_call_function('searchpos', {[[(\|\S\|)]], 'bW'})
    if char_under_cursor() == ')' then
        M.move_prev_matching_brace()
    else -- TODO: add case for strings too
        vim.api.nvim_call_function('searchpos', {[[(\|\s]], 'bW'})
    end
end

local function next_elem_end()
    vim.api.nvim_call_function('searchpos', {[[(\|\S\|)]], 'W'})
    if char_under_cursor() == '(' then
        M.move_next_matching_brace()
    else
        vim.api.nvim_call_function('searchpos', {[[)\|\s\|\n]], 'W'})
    end
end

local function delete_under_cursor() -- i feel like there should be a better way
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    line = line:sub(1, col) .. line:sub(col+2, line:len())
    vim.api.nvim_set_current_line(line)
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

function M.insert_before_elem()
    find_elem_end()
    vim.api.nvim_put({')'}, 'c', false, false)
    find_elem_start()
    vim.api.nvim_put({'( '}, 'c', true, false)

    vim.api.nvim_command('startinsert')
end

function M.insert_after_elem()
    find_elem_start()
    vim.api.nvim_put({'('}, 'c', true, false)
    find_elem_end()
    vim.api.nvim_put({' )'}, 'c', false, false)

    vim.api.nvim_command('startinsert')
end

function M.slurp_back()
    local curpos = vim.api.nvim_win_get_cursor(0)

    if char_under_cursor() ~= '(' then
        nearest_matching_brace('bW')
    end
    delete_under_cursor()

    prev_elem_start()
    vim.api.nvim_put({'('}, 'c', true, false)

    vim.api.nvim_win_set_cursor(0, curpos)
end

function M.slurp_forth()
    local curpos = vim.api.nvim_win_get_cursor(0)

    if char_under_cursor() ~= ')' then
        nearest_matching_brace('W')
    end
    delete_under_cursor()

    next_elem_end()
    vim.api.nvim_put({')'}, 'c', true, false)

    vim.api.nvim_win_set_cursor(0, curpos)
end

return M
