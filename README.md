# racc.nvim

A neovim plugin for stealing trash pandas from the [racc.lol](https://racc.lol) API

## Installation

### **Requirements**
- Neovim **0.9+** (0.10+ recommended)
- [`nvim-lua/plenary.nvim`](https://github.com/nvim-lua/plenary.nvim) (installed automatically if using `lazy.nvim`)

### **Using [lazy.nvim](https://github.com/folke/lazy.nvim)**

```lua
{
    "keircn/racc.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("racc").setup({
            register = "+" -- default: system clipboard
            -- register = '"' -- unnamed register
            -- register = "*" -- primary selection (X11)
        })
    end,
}
```

### **Using [packer.nvim](https://github.com/wbthomason/packer.nvim)**

```lua
use({
    "keircn/racc.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
        require("racc").setup({
            register = "+"
        })
    end,
})
```

## Usage

- **Check API status**
  ```
  :Racc
  ```
  Shows whether the API is reachable and plugin performance stats.

- **Get a random raccoon image URL**
  ```
  :RaccPlease
  ```
  Copies the image URL to your configured register (default: system clipboard) and shows details like index, dimensions, alt text, etc.

## License

MIT as always! [LICENSE](./LICENSE)

