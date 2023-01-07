vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.cmdheight = 2 -- more space in the neovim command line for displaying messages

local jdtls_status, jdtls = pcall(require, "jdtls")
if not jdtls_status then return end

-- determine os
local home = os.getenv "HOME"
local workspace_path
local config
if vim.fn.has "mac" == 1 then
  workspace_path = home .. "/.cache/jdtls/workspace/"
  config = "mac"
elseif vim.fn.has "unix" == 1 then
  workspace_path = home .. "/.cache/jdtls/workspace/"
  config = "linux"
else
  print "Unsupported system"
end

-- find root of project
-- local root_dir = vim.fn.getcwd()
-- if root_dir == nil or root_dir == "" then return end
--
local root_markers = { ".git", "mvnw" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then return end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_dir = workspace_path .. project_name

local bundles = {}
-- local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
-- vim.list_extend(
--   bundles,
--   vim.split(
--     vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"),
--     "\n"
--   )
-- )
-- vim.list_extend(
--   bundles,
--   vim.split(
--     vim.fn.glob(
--       mason_path
--         .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
--     ),
--     "\n"
--   )
-- )

return {
  cmd = {
    "java", -- or '/path/to/java11_or_newer/bin/java'
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:"
        .. home
        .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob(
      home
      .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
    ),
    "-configuration",
    home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. config,
    "-data",
    workspace_dir,
  },

  root_dir = root_dir,

  settings = {
    java = {
      home = os.getenv "JAVA_HOME",
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-19",
            path = "/opt/homebrew/Cellar/openjdk/19.0.1/libexec/openjdk.jdk/Contents/Home",
          },
          {
            name = "JavaSE-18",
            path = "/Library/Java/JavaVirtualMachines/jdk-18.0.2.1.jdk/Contents/Home",
          },
          {
            name = "JavaSE-11",
            path = "/opt/homebrew/Cellar/openjdk@11/11.0.16.1_1/libexec/openjdk.jdk/Contents/Home",
          },
          {
            name = "JavaSE-1.8",
            path = "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home",
          },
          {
            name = "JavaSE-1.7",
            path = "/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home",
          },
        },
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath "config"
              .. "user/lsp/formatter/idea-google-format.xml",
          profile = "GoogleStyle",
        },
      },
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
      importOrder = {
        "com",
        "org",
        "javax",
        "java",
      },
    },
    extendedClientCapabilities = extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },

  flags = {
    allow_incremental_sync = true,
  },

  init_options = {
    bundles = bundles,
  },
}
