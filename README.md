# hubot-jakucho
[![travis-image]][travis-url] [![Dependency Status][daviddm-url]][daviddm-image] [![coveralls-image]][coveralls-url]

Reply jakucho (瀬戸内寂聴) image when you say SESSHO (殺生) words.

See [`src/jakucho.coffee`](src/jakucho.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install moqada/hubot-jakucho --save`

Then add **hubot-jakucho** to your `external-scripts.json`:

```json
["hubot-jakucho"]
```

## Sample Interaction

```
user1>> fuck!
hubot>> @user1 http://i.imgur.com/0PdXItV.jpg
```

[travis-url]: https://travis-ci.org/moqada/hubot-jakucho
[travis-image]: http://img.shields.io/travis/moqada/hubot-jakucho/master.svg?style=flat
[daviddm-url]: https://david-dm.org/moqada/hubot-jakucho.svg?theme=shields.io
[daviddm-image]: http://img.shields.io/david/moqada/hubot-jakucho.svg?style=flat
[coveralls-url]: https://coveralls.io/r/moqada/hubot-jakucho
[coveralls-image]: http://img.shields.io/coveralls/moqada/hubot-jakucho/master.svg?style=flat
