// Counting equation number
#let equation_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter(math.equation)
    let n = c.at(loc).at(0)
    "(" + str(chapt) + "." + str(n) + ")"
  })
}

// Counting table number
#let table_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter("table-chapter" + str(chapt))
    let n = c.at(loc).at(0)
    str(chapt) + "." + str(n + 1)
  })
}

// Counting image number
#let image_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter("image-chapter" + str(chapt))
    let n = c.at(loc).at(0)
    str(chapt) + "." + str(n + 1)
  })
}

// Definition of table format
#let tab(tab, caption: "") = {
  figure(
    tab,
    caption: caption,
    supplement: [Table],
    numbering: table_num,
    kind: "table",
  )
}

// Definition of image format
#let img(img, caption: "") = {
  figure(
    img,
    caption: caption,
    supplement: [Fig.],
    numbering: image_num,
    kind: "image",
  )
}

// Definition of content to string
#let to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(to-string).join("")
  } else if content.has("body") {
    to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

// Definition of chapter outline
#let toc() = {
  align(left)[
    #text(size: 16pt, weight: "bold", font: ("Times New Roman", "Yu Gothic"))[
      #v(27pt)
      目次
      #v(27pt)
    ]
  ]

  set text(size: 10pt)
  set par(leading: 1.24em, first-line-indent: 0pt)
  locate(loc => {
    let elements = query(heading.where(outlined: true), loc)
    for el in elements {
      let before_toc = query(heading.where(outlined: true).before(loc), loc).find((one) => {one.body == el.body}) != none
      let page_num = if before_toc {
        numbering("i", counter(page).at(el.location()).first())
      } else {
        counter(page).at(el.location()).first()
      }

      link(el.location())[#{
        // acknoledgement has no numbering
        let chapt_num = if el.numbering != none {
          numbering(el.numbering, ..counter(heading).at(el.location()))
        } else {none}

        if el.level == 1 {
          set text(weight: "black")
          if chapt_num == none {} else {
            [第]
            chapt_num
            [章　]
          }
          let rebody = to-string(el.body)
          rebody
        } else if el.level == 2 {
          h(2em)
          chapt_num
          " "
          let rebody = to-string(el.body)
          rebody
        } else {
          h(5em)
          chapt_num
          " "
          let rebody = to-string(el.body)
          rebody
        }
      }]
      box(width: 1fr, h(0.5em) + box(width: 1fr, repeat[$dot.c$]) + h(0.5em))
      [#page_num]
      linebreak()
    }
  })
}

// Setting empty par
#let empty_par() = {
  v(-2em)
  box()
}

// Construction of paper
#let master_thesis(
  // The master thesis title.
  title: "ここにtitleが入る",

  // The paper`s author.
  author: "ここに著者が入る",

  // The author's information
  university: "",
  faculty: "",
  department: "",
  major: "",
  mentor1: "",
  mentor1-post: "",
  mentor2: "",
  mentor2-post: "",
  class: "",
  date: ("", "", "", ""),

  paper-type: "論文",

  // The paper size to use.
  paper-size: "a4",

  // The path to a bibliography file if you want to cite some external
  // works.
  bibliography-file: none,

  // The paper's content.
  body,
) = {
  // citation number
  show ref: it => {
    if it.element != none and it.element.func() == figure {
      let el = it.element
      let loc = el.location()
      let chapt = counter(heading).at(loc).at(0)

      link(loc)[#if el.kind == "image" or el.kind == "table" {
          // counting 
          let num = counter(el.kind + "-chapter" + str(chapt)).at(loc).at(0) + 1
          it.element.supplement
          " "
          str(chapt)
          "."
          str(num)
        } else if el.kind == "thmenv" {
          let thms = query(selector(<meta:thmenvcounter>).after(loc), loc)
          let number = thmcounters.at(thms.first().location()).at("latest")
          it.element.supplement
          " "
          numbering(it.element.numbering, ..number)
        } else {
          it
        }
      ]
    } else if it.element != none and it.element.func() == math.equation {
      let el = it.element
      let loc = el.location()
      let chapt = counter(heading).at(loc).at(0)
      let num = counter(math.equation).at(loc).at(0)

      it.element.supplement
      " ("
      str(chapt)
      "."
      str(num)
      ")"
    } else if it.element != none and it.element.func() == heading {
      let el = it.element
      let loc = el.location()
      let num = numbering(el.numbering, ..counter(heading).at(loc))
      if el.level == 1 {
        str(num)
        "章"
      } else if el.level == 2 {
        str(num)
        "節"
      } else if el.level == 3 {
        str(num)
        "項"
      }
    } else {
      it
    }
  }

  // counting caption number
  show figure: it => {
    set align(center)
    if it.kind == "image" {
      set text(size: 10pt)
      it.body
      it.supplement
      " " + it.counter.display(it.numbering)
      " " + it.caption.body
      locate(loc => {
        let chapt = counter(heading).at(loc).at(0)
        let c = counter("image-chapter" + str(chapt))
        c.step()
      })
    } else if it.kind == "table" {
      set text(size: 10pt)
      it.supplement
      " " + it.counter.display(it.numbering)
      " " + it.caption.body
      set text(size: 10.5pt)
      it.body
      locate(loc => {
        let chapt = counter(heading).at(loc).at(0)
        let c = counter("table-chapter" + str(chapt))
        c.step()
      })
    } else {
      it
    }
  }

  // Set the document's metadata.
  set document(title: title, author: author)

  // Set the body font. TeX Gyre Pagella is a free alternative
  // to Palatino.
  set text(font: (
    "Times New Roman",
    "Yu Mincho"
    ), size: 10pt)

  // Configure the page properties.
  set page(
    paper: paper-size,
    margin: (bottom: 1.75cm, top: 2.25cm),
  )

  // The first page.
  align(center)[
    #v(80pt)

    #text(
      size: 16pt,
    )[
      #class#paper-type
    ]
    #v(40pt)
    #text(
      size: 19pt,
      weight: "black",
      font: ("Yu Gothic", "Times New Roman")
    )[
      #title
    ]
    #v(120pt)
    #text(
      size: 16pt,
    )[
      指導教員\
      #mentor1　#mentor1-post\
      #mentor2　#mentor2-post
    ]
    #v(40pt)
    #text(
      size: 16pt,
    )[
      #date.at(0) 年（令和#date.at(1) 年） #date.at(2) 月 #date.at(3) 日
    ]

    #text(
      size: 16pt,
    )[
      #university #faculty #department #major
    ]
    #v(30pt)
    #text(
      size: 22pt,
    )[
      #author
    ]

    #pagebreak()
  ]

  set page(
    footer: [
      #align(center)[#counter(page).display("i")]
    ]
  )

  counter(page).update(1)

  // Configure paragraph properties.
  set par(leading: 0.78em, first-line-indent: 1em, justify: true)
  show par: set block(spacing: 0.78em)

  // Configure chapter headings.
  set heading(
      numbering: (..nums) => {
      nums.pos().map(str).join(".") + " "
    },
  )
  show heading.where(level: 1): it => {
    pagebreak()
    counter(math.equation).update(0)
    set block(spacing: 1.5em)
    let pre_chapt = if it.numbering != none {
          set text(weight: "black", size: 30pt, font: ("Yu Gothic", "Times New Roman"))
          v(220pt)
          align(center)[
            第#numbering(it.numbering, ..counter(heading).at(it.location()))章
          ]
        } else {none}
        
    if it.numbering != none {
      set text(weight: "black", size: 30pt, font: ("Yu Gothic", "Times New Roman"))
      align(center)[
        #pre_chapt 
        #it.body \
        #v(50pt)
      ]
    } else {
      align(center)[
        #pre_chapt 
        #it.body \
        #v(50pt)
      ]
    }
  }
  show heading.where(level: 2): it => {
    set text(weight: "bold", size: 16pt, font: ("Yu Gothic", "Times New Roman"))
    set block(above: 1.5em, below: 1.5em)
    it
  }

  show heading: it => {
    set text(weight: "bold", size: 14pt, font: ("Yu Gothic", "Times New Roman"))
    set block(above: 1.5em, below: 1.5em)
    it
  } + empty_par()


  // Start with a chapter outline.
  toc()

  set page(
    footer: [
      #align(center)[#counter(page).display("1")]
    ]
  )

  counter(page).update(1)
 
  set math.equation(supplement: [式], numbering: equation_num, number-align: bottom)

  body
}