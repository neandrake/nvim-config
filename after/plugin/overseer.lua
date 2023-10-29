local overseer = require('overseer')

overseer.setup()

vim.keymap.set("n", "<leader>ot", overseer.toggle)
vim.keymap.set("n", "<leader>or", overseer.run_template)
