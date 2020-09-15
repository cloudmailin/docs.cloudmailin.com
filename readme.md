# CloudMailin Open Source Documentation

We're constantly looking for ways to improve CloudMailin and innovate to give the best we possibly can to our users. Since most of our users are developers it makes sense that we use github to manage our documentation.

If you want to see something changed in the documentation or have an example to add then just fork the docs, send us a pull request and we'll be super grateful!

The documentation and some examples of how you can receive email in your web framework can be viewed online at [http://docs.cloudmailin.com](http://docs.cloudmailin.com)

Thanks,
The CloudMailin team.

## Development

### Installation

```bash
docker-compose build
```

### Running in Development Mode

```bash
docker-compose up docs
```

You can then head to: http://localhost:5000/

## Checks

```bash
docker-compose run docs bash -c "bundle exec nanoc check"
```

## Deploying

```bash
docker-compose run docs bash -c "bundle exec nanoc compile -e production && FOG_RC=.fog bundle exec nanoc deploy --target staging"
```

## Generating Rouge CSS Files

```
rougify style --scope='pre code' igorpro > ./content/assets/stylesheets/syntax.css
```
