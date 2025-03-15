# json-to-elixir

## About

Simple client web app for converting JSON to an equivalent Elixir map notation.

## Development

### Environment Setup

#### Asdf
Using asdf for versioning

```sh
asdf plugin add erlang
asdf plugin add rebar
asdf plugin add gleam

asdf install
```

### Running the App
```sh
gleam deps download # Download dependencies
gleam run -m lustre/dev start   # Run the app
gleam test  # Run tests
```

### VS Code Extensions

[Tailwind CSS Intellisense](https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss)


Add the following to your `settings.json` to get intellisense for styling lustre elements with `attribute.class("")`

```json
"tailwindCSS.experimental.classRegex": [
  "attribute.class\\(\"([^\"]+)\"\\)",
],
```

[Gleam](https://marketplace.visualstudio.com/items?itemName=gleam.gleam)

Syntax highlighting and linting for gleam
```json
"[gleam]": {
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "gleam.gleam"
}
```
