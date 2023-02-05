# crudris

Crudris is a Crystal API wrapper for the [Eludris](https://github.com/eludris) API.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     crudris:
       github: tooolifelesstocode/crudris
   ```

2. Run `shards install`

## Basic Usage

```crystal
require "crudris"

client = Crudris::Client.new("Bot Bot Bot Bot Bot")
client.connect
```
