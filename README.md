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
  :RaccPlease [daily|hourly|weekly]
  ```
  Copies the image URL to your configured register (default: system clipboard) and shows details like index, dimensions, alt text, etc.
  - Use `daily` to get the same image for the entire day
  - Use `hourly` to get the same image for the entire hour  
  - Use `weekly` to get the same image for the entire week

- **Get a random raccoon video URL**
  ```
  :RaccVideo
  ```
  Copies a raccoon video URL to your configured register and shows file size and content type.

- **Get a random raccoon meme URL**
  ```
  :RaccMeme
  ```
  Copies a raccoon meme URL to your configured register and shows details like dimensions and alt text.

- **Get a random raccoon fact**
  ```
  :RaccFact
  ```
  Displays a random raccoon fact and optionally copies it to your register.

- **Get API statistics**
  ```
  :RaccStats
  ```
  Shows API statistics including total raccoons, memes, videos, and requests.

- **Get a specific raccoon by ID**
  ```
  :RaccById <id>
  ```
  Copies a specific raccoon image URL to your register using the provided ID.

- **Get a specific meme by ID**
  ```
  :RaccMemeById <id>
  ```
  Copies a specific raccoon meme URL to your register using the provided ID.

- **List available raccoons**
  ```
  :RaccList
  ```
  Shows the count of available raccoons. Use `:RaccById <id>` to get a specific one.

- **List available memes**
  ```
  :RaccMemeList
  ```
  Shows the count of available memes. Use `:RaccMemeById <id>` to get a specific one.

## License

MIT as always! [LICENSE](./LICENSE)

