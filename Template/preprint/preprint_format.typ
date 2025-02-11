
// 数式のナンバリング
#let equation_num(_) = {
  locate(loc => {
    let c = counter(math.equation)
    let n = c.at(loc).at(0)
    "(" + str(n) + ")"
  })
}

// 図のナンバリング
#let image_num(_) = {
  locate(loc => {
    let c = counter("image-counter")
    let n = c.at(loc).at(0)
    str(n + 1)
  })
}

// 表のナンバリング
#let table_num(_) = {
  locate(loc => {
    let c = counter("table-counter")
    let n = c.at(loc).at(0)
    str(n + 1)
  })
}

// 図形式
#let img(img, caption: "") = {
  figure(
    img,
    caption: caption,
    supplement: [Fig.],
    numbering: image_num,
    kind: "image",
  )
}

// 表形式
#let tab(tab, caption: "") = {
  figure(
    tab,
    caption: caption,
    supplement: [Table],
    numbering: table_num,
    kind: "table",
  )
}

// 図表のキャプション
#let styled_caption(caption) = {
  text(caption, size: 9.5pt)
}

// // コンテンツを文字列に変換: 変更不要
// #let to-string(content) = {
//   if content.has("text") {
//     content.text
//   } else if content.has("children") {
//     content.children.map(to-string).join("")
//   } else if content.has("body") {
//     to-string(content.body)
//   } else if content == [ ] {
//     " "
//   }
// }

// 空白行: 変更不要
#let empty_par() = {
  v(-1em)
  box()
}

// 本体
#let preprint(
  presentation: "",
  title: "",
  author: "",
  university: "",
  faculty: "",
  department: "",
  major: "",
  field: "",
  laboratory: "",
  date: ("", "", ""),
  paper-size: "a4",
  bibliography-file: none,
  body,
) = {
  // 引用番号
  show ref: it => {
    if it.element != none and it.element.func() == figure {
      let el = it.element
      let loc = el.location()

      // link(loc)[
      //   #if el.kind == "image" or el.kind == "table" {
      //     let num = global_table_counter.at(loc).at(0) + 1
      //     it.element.supplement
      //     " "
      //     str(num)
      //   } else if el.kind == "thmenv" {
      //     let thms = query(selector(<meta:thmenvcounter>).after(loc), loc)
      //     let number = thmcounters.at(thms.first().location()).at("latest")
      //     it.element.supplement
      //     " "
      //     numbering(it.element.numbering, ..number)
      //   } else {
      //     it
      //   }
      // ]
    } else if it.element != none and it.element.func() == math.equation {
      let el = it.element
      let loc = el.location()
      let num = global_equation_counter.at(loc).at(0) + 1
      it.element.supplement
      " ("
      str(num)
      ")"
    } else if it.element != none and it.element.func() == heading {
      let el = it.element
      let loc = el.location()
      let num = numbering(el.numbering, ..counter(heading).at(loc))
      if el.level == 1 {
        str(num)
        "章"
      }
    } else {
      it
    }
  }

  // キャプション番号のカウント
  show figure: it => {
    set align(center)
    if it.kind == "image" {
      set text(size: 9.5pt)
      it.body
      it.supplement
      " " + it.counter.display(it.numbering)
      " " + it.caption.body
      "."
      locate(loc => {
        let c = counter("image-counter")
        c.step()
      })
    } else if it.kind == "table" {
      set text(size: 9.5pt)
      it.supplement
      " " + it.counter.display(it.numbering)
      " " + it.caption.body
      "."
      set text(size: 9.5pt)
      it.body
      locate(loc => {
        let c = counter("table-counter")
        c.step()
      })
    } else {
      it
    }
  }

  // ドキュメントのメタデータを設定
  set document(title: title, author: author)

  // 本文フォントを設定
  set text(
    font: ("Times New Roman", "Yu Mincho"),
    size: 9.5pt,
  )

  // ページのプロパティを設定
  set page(
    columns: (2),
    paper: paper-size,
    margin: (bottom: 15mm, top: 15mm, left: 15mm, right: 15mm),
    footer: [
      #align(center)[#counter(page).display("1")]
    ],
  )

  counter(page).update(1)

  // Configure paragraph properties.
  set par(spacing: 1em, leading: 0.75em, first-line-indent: 1em, justify: true)

  // サブセクションの書式 ("2.1"など)
  set heading(
    numbering: (..nums) => {
      nums.pos().map(str).join(".") + " "
    },
  )

  // セクション
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    set text(weight: "bold", size: 11pt, font: ("Yu Gothic", "Times New Roman"))
    // 付録など章番号を付けない場合も考慮
    let pre_chapt = if it.numbering != none {
      text()[
        #numbering(it.numbering, ..counter(heading).at(it.location()))
        #h(0.5em)
      ]
    } else { none }
    align(left)[
      #pre_chapt
      #it.body \
    ]
  } + empty_par()

  // サブセクション
  show heading.where(level: 2): it => {
    set text(weight: "bold", size: 10.5pt, font: ("Yu Gothic", "Times New Roman"))
    let pre_chapt = {
      text()[
        #numbering(it.numbering, ..counter(heading).at(it.location()))
        #h(0.5em)
      ]
    }
    align(left)[
      #pre_chapt
      #it.body \
    ]
  }

  show heading: it => {
    set par(leading: 0.78em, first-line-indent: 0em, justify: true)
    set block(above: 1.5em, below: 1.5em) // ?
    it
  }

  // 日付 (右上)
  place(
    top,
    float: true,
    scope: "parent",
    text(size: 9.5pt)[
      #presentation #h(1fr) #date.at(0) 年 #date.at(1) 月 #date.at(2) 日
    ],
  )
  // タイトル
  place(
    top + center,
    float: true,
    scope: "parent",
    text(font: "Yu Mincho", size: 12pt, weight: "bold")[
      #v(15pt)
      #title
    ],
  )
  // 所属・氏名 (タイトル右下)
  place(
    top,
    float: true,
    scope: "parent",
    text(size: 9.5pt)[
      #v(10pt)
      #h(1fr) #university #faculty #department #major \
      #h(1fr) #field #laboratory #author
      #v(10pt)
    ],
  )

  // 式番号引用時のprefix
  // number-align: bottomは複数行の数式に対して最終行の数式のみに番号を振る設定
  // 詳細は https://typst.app/docs/reference/math/equation/
  set math.equation(supplement: [式], numbering: equation_num, number-align: bottom)

  //消さないでね
  body

  // 参考文献: bibliography-fileで設定したBiBTeX形式ファイル
  if bibliography-file != none {
    show bibliography: set text(9pt, lang: "en")
    bibliography(bibliography-file, title: "参考文献", style: "ieee")
  }
}
