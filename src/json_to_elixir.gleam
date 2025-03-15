import lustre
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// MODEL -----------------------------------------------------------------------

type Model {
  Model(word: Word, input_language: Language, input: String, output: String)
}

type Word =
  String

type Language {
  JSON
  Elixir
}

fn init(_flags) -> Model {
  Model("", input_language: JSON, input: "", output: "")
}

// UPDATE ----------------------------------------------------------------------

pub type Msg {
  SetWord(String)
  FlipInputMode
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    SetWord(word) -> Model(..model, word: word)
    FlipInputMode -> {
      let new_input_language = case model.input_language {
        JSON -> Elixir
        Elixir -> JSON
      }

      Model(..model, input_language: new_input_language)
    }
  }
}

// VIEW ------------------------------------------------------------------------

fn view(model: Model) -> element.Element(Msg) {
  html.body([attribute.class("flex flex-col h-dvh w-screen")], [
    header(),
    main_area(model),
  ])
}

fn header() -> element.Element(Msg) {
  html.header([attribute.class("flex items-center h-32 bg-purple-300 pl-10")], [
    html.h1([attribute.class("text-4xl")], [element.text("JSON to Elixir Map")]),
  ])
}

fn main_area(model: Model) -> element.Element(Msg) {
  html.main([attribute.class("flex-grow p-6 bg-white overflow-y-hidden")], [
    html.div(
      [attribute.class("flex flex-row h-full w-full gap-10 overflow-y-auto")],
      [
        view_language_box(model, input_language(model)),
        view_switch_button(),
        view_language_box(model, output_language(model)),
      ],
    ),
  ])
}

fn view_language_box(_model: Model, language: Language) -> element.Element(Msg) {
  html.div([attribute.class("flex flex-col  w-1/2 items-center")], [
    html.div([attribute.class("text-2xl")], [element.text(to_string(language))]),
  ])
}

fn view_switch_button() -> element.Element(Msg) {
  html.button([attribute.class("mb-auto"), event.on_click(FlipInputMode)], [
    element.text("Change Mode"),
  ])
}

// HELPERS ---------------------------------------------------------------------

const json_string = "JSON"

const elixir_string = "Elixir"

fn input_language(model: Model) -> Language {
  model.input_language
}

fn output_language(model: Model) -> Language {
  case model.input_language {
    JSON -> Elixir
    Elixir -> JSON
  }
}

fn to_string(language: Language) -> String {
  case language {
    JSON -> json_string
    Elixir -> elixir_string
  }
}
