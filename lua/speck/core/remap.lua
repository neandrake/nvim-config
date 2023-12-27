-- Easy way to open up netrw / Disabled for nvim-tree.
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Easy way to move selected lines up/down
vim.keymap.set("v", "J", ":m'>+<CR>gv=gv")
vim.keymap.set("v", "K", ":m-2<CR>gv=gv")

vim.keymap.set("n", "<C-j>", ":<C-u>m+<CR>==")
vim.keymap.set("n", "<C-k>", ":<C-u>m-2<CR>==")


-- Keep cursor position when using J
--vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor in middle of screen when using C-d/C-u
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor in middle when jumping between search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Use instead of p to paste over selected contents but keep current copied
-- buffer instead of replacing it with the contents that were overwritten.
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yanks into system clipboard instead of vim clipboard
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete to void register so deleted contents do not overwrite clipboard
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Makes C-c behave like Esc, some minor differences exist:
--   When in V mode and modifying multiple vertical lines then using C-c it
--   won't keep the changes, but using Esc will keep changes.
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Don't ever press Q, "it's the worst place in the universe"
vim.keymap.set("n", "Q", "<nop>")

-- Format entire file
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end)

--
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Use leader-x to mark the current file as executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
