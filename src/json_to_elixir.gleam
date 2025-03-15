import lustre
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event
import lustre/internals/vdom

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// MODEL -----------------------------------------------------------------------

type Model {
  Model(
    input_language: Language,
    output_language: Language,
    input: String,
    output: String,
  )
}

type Language {
  JSON
  Elixir
}

fn init(_flags) -> Model {
  Model(input_language: JSON, output_language: Elixir, input: "", output: "")
}

// UPDATE ----------------------------------------------------------------------

pub type Msg {
  FlipInputMode
  SetInput(String)
  CopyOutput
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    FlipInputMode -> {
      Model(
        input_language: model.output_language,
        output_language: model.input_language,
        input: model.output,
        output: model.input,
      )
    }
    SetInput(text) -> Model(..model, input: text)
    CopyOutput -> {
      copy_to_clipboard()
      model
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
  html.header(
    [
      attribute.class(
        "flex items-center h-32 pl-10 bg-slate-800 text-purple-300",
      ),
    ],
    [
      html.h1([attribute.class("text-4xl")], [
        element.text("JSON to Elixir Map"),
      ]),
    ],
  )
}

fn main_area(model: Model) -> element.Element(Msg) {
  html.main(
    [attribute.class("flex-grow p-6 bg-slate-800 overflow-y-hidden text-white")],
    [
      html.div(
        [attribute.class("flex flex-row h-full w-full gap-10 overflow-y-auto")],
        [view_input_box(model), view_switch_button(), view_output_box(model)],
      ),
    ],
  )
}

fn view_input_box(model: Model) -> element.Element(Msg) {
  view_language_box([element.text(to_string(model.input_language))], [
    html.textarea(
      [
        attribute.class(
          "h-full w-full rounded-lg bg-white p-3 text-start text-black text-wrap resize-none",
        ),
        event.on_input(SetInput),
      ],
      model.input,
    ),
  ])
}

fn view_output_box(model: Model) -> element.Element(Msg) {
  view_language_box(
    [
      element.text(to_string(model.output_language)),
      html.button([attribute.class("text-lg"), event.on_click(CopyOutput)], [
        html.img([
          attribute.src(
            "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fpics.freeicons.io%2Fuploads%2Ficons%2Fpng%2F4498062351543238871-512.png&f=1&nofb=1&ipt=153bcca2c44542e83a362d25d403f1f1822c8a16d7825efebed0fe8056e302c0&ipo=images",
          ),
          attribute.width(35),
        ]),
      ]),
    ],
    [
      html.textarea(
        [
          attribute.id("output-box"),
          attribute.class(
            "h-full w-full rounded-lg bg-white p-3 text-start text-black text-wrap resize-none",
          ),
          attribute.disabled(True),
        ],
        model.output,
      ),
    ],
  )
}

fn view_language_box(
  header: List(vdom.Element(Msg)),
  text_box: List(vdom.Element(Msg)),
) -> element.Element(Msg) {
  html.div([attribute.class("flex flex-col w-1/2 gap-3")], [
    html.div([attribute.class("flex flex-row ml-12 text-2xl gap-3")], header),
    html.div(
      [
        attribute.class(
          "h-full w-full bg-gray-500 rounded-xl p-3 overflow-y-hidden",
        ),
      ],
      text_box,
    ),
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

fn to_string(language: Language) -> String {
  case language {
    JSON -> json_string
    Elixir -> elixir_string
  }
}

@external(javascript, "./js/copyToClipboard.js", "copy_to_clipboard")
fn copy_to_clipboard() -> Nil
