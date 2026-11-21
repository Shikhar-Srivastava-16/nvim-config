local jdtls = require("jdtls")

-- Find the project root
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }
local root_dir = vim.fs.root(0, root_markers)
if not root_dir then
    return
end

-- Each project needs its own workspace dir
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

local config = {
    cmd = { "jdtls", "-data", workspace_dir },

    root_dir = root_dir,

    settings = {
        java = {
            signatureHelp = { enabled = true },
            completion = {
                favoriteStaticMembers = {
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            project = {
                sourcePaths = { "src", "code" },
                outputPath = "bin",
            },
        },
    },

    init_options = {
        bundles = {}, -- debug/test bundles go here (see below)
    },
}

jdtls.start_or_attach(config)
