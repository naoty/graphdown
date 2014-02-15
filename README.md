# Graphdown

Markdown extension for embedding graphs.

## Installation

```sh
$ gem install graphdown
```

## Usage

```rb
require "redcarpet"
require "graphdown"

class BaseRenderer < Redcarpet::Render::HTML
  include Graphdown::Renderable
end

markdown = Redcarpet::Markdown.new(BaseRenderer, fenced_code_blocks: true)
```

## Graph notation

Graphdown extends following notations for graphs.

- `[label name]`: Node named "label name"
- `[label A], [label B], ...`: Multiple nodes
- `->`: Unidirectional edge
- `<->`: Bidirectional edge
- `-[edge name]->` or `<-[edge name]->`: Edge named "edge name"

Graphdown parses these notations into graph images in SVG format.

### Examples

```markdown
# Paths for my project on GitHub

[/] <-> [/naoty] <-> [/naoty/graphdown]
[/] <-> [/naoty/graphdown]
[/] <-> [/search] -> [/naoty/graphdown]
[/] <-> [/notifications] -> [/naoty/graphdown]
```

```markdown
# Sign in and Sign out on GitHub

[/] -[POST /logout]-> [/]
[/] -> [/login] -[POST /session]-> [/]
```

```markdown
# Servers arrangement

[load balancer] -> [web server 1], [web server 2], [web server 3] -> [cache server]
[web server 1] -> [DB server 1]
[web server 2] -> [DB server 2]
[web server 3] -> [DB server 3]
```

## References

- Kazuo Misue, Kouzou Sugiyama, On Automatic Drowing of Compound Graphs for Computer Aided Diagrammatical Thinking, Journal of Information Processing Society of Japan, 1989, Vol.30, No.10, p1324-1334.
