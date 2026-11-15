-- return {
--   cmd = { 'rust-analyzer' },
--   filetypes = { 'rust' },
--   root_markers = { 'Cargo.toml', 'Cargo.lock', '.git' },
--   settings = {
--     ["rust-analyzer"] = {
--       cargo = {
--         allFeatures = true,
--         loadOutDirsFromCheck = true,
--         runBuildScripts = true,
--       },
--       -- Add clippy lints on save
--       checkOnSave = true,
--       check = {
--         command = "clippy",
--       },
--       procMacro = {
--         enable = true,
--       },
--     },
--   },
-- }

return {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
            },
            checkOnSave = true,
            check = {
                command = "clippy",
            },
            procMacro = {
                enable = true,
            },
            inlayHints = {
                bindingModeHints = { enable = false },
                closureReturnTypeHints = { enable = "always" },
                lifetimeElisionHints = { enable = "skip_trivial" },
            },
        },
    },
}
