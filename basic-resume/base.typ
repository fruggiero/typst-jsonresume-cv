#import "@preview/scienceicons:0.0.6": orcid-icon

// Header + first item unbreakable
#let section_with_header(title, first_item, rest_items) = [
  #block(breakable: false)[
    #title
    #first_item
  ]
  #for item in rest_items {
    [#item]
  }
]

#let getMonthNames(lang) = {
  if lang == "de" {
    return (
      "01": "Jan", "02": "Feb", "03": "Mär", "04": "Apr", 
      "05": "Mai", "06": "Jun", "07": "Jul", "08": "Aug", 
      "09": "Sep", "10": "Okt", "11": "Nov", "12": "Dez"
    )
  } else if lang == "it" {
    return (
      "01": "Gen", "02": "Feb", "03": "Mar", "04": "Apr", 
      "05": "Mag", "06": "Giu", "07": "Lug", "08": "Ago", 
      "09": "Set", "10": "Ott", "11": "Nov", "12": "Dic"
    )
  } else { // English as default
    return (
      "01": "Jan", "02": "Feb", "03": "Mar", "04": "Apr", 
      "05": "May", "06": "Jun", "07": "Jul", "08": "Aug", 
      "09": "Sep", "10": "Oct", "11": "Nov", "12": "Dec"
    )
  }
}

#let section_titles = (
  work: (de: upper("Berufserfahrung"), it: upper("Esperienza Lavorativa"), en: upper("Work Experience")),
  education: (de: upper("Bildungsweg"), it: upper("Istruzione"), en: upper("Education")),
  projects: (de: upper("Projekte"), it: upper("Progetti"), en: upper("Projects")),
  skills: (de: upper("Kenntnisse"), it: "Competenze", en: "Skills"),
  interests: (de: upper("Interessen"), it: "Interessi", en: "Interests"),
  certifications: (de: upper("Zertifikate"), it: "Certificazioni", en: "Certifications"),
  extra: (de: upper("Wahlfächer"), it: upper("Attività Extracurriculari"), en: upper("Extracurriculars")),
  languages: (de: upper("Sprachen"), it: upper("Lingue"), en: upper("Languages")),
  actual: (de: upper("Aktuell"), it: "Attuale", en: "Present"),
  conjunction_word: (de: upper("und"), it: upper("e"), en: upper("&")),
)

#let get_section_title(section, lang) = section_titles.at(section).at(lang, default: section)

#let formatDate(dateString, monthNames) = {
  let parts = dateString.split("-")
  let year = parts.at(0)
  let month = parts.at(1)
  let monthName = monthNames.at(month, default: month)
  return monthName + " " + year
}

#let getDegreeDate(lang, education) = {
  if "endDate" in education { 
    formatDate(education.endDate, getMonthNames(lang))
  } else {
    get_section_title("actual", lang)
  }
}

#let build_section(title, items, item_builder, lang) = {
  if items.len() > 0 {
    section_with_header(
      [== #get_section_title(title, lang)],
      item_builder(items.at(0), lang),
      items.slice(1, items.len()).map(item => item_builder(item, lang))
    )
  }
}

#let resume(
  author: "",
  author-position: left,
  personal-info-position: left,
  location: "",
  language: "",
  email: "",
  github: "",
  linkedin: "",
  phone: "",
  personal-site: "",
  orcid: "",
  accent-color: "#000000",
  font: "Garamond",
  paper: "a4",
  body,
) = {
  // Sets document metadata
  set document(author: author, title: author)

  // Document-wide formatting, including font and margins
  set text(
    // LaTeX style font
    font: font,
    size: 12pt,
    lang: language,
    // Disable ligatures so ATS systems do not get confused when parsing fonts.
    ligatures: false
  )

  // Reccomended to have 0.5in margin on all sides
  set page(
    // margin: (0.5in),
    margin: (top: 0.76cm, bottom: 0.76cm, left: 1.27cm, right: 1.27cm),
    paper: paper,
  )

  // Link styles
  // show link: underline

  // Small caps for section titles
  show heading.where(level: 2): it => [
    #pad(top: 0pt, bottom: -10pt, [#smallcaps(it.body)])
    #line(length: 100%, stroke: 1pt)
  ]

  // Accent Color Styling
  show heading: set text(
    fill: rgb(accent-color),
  )

  show link: set text(
    fill: rgb(accent-color),
  )

  // Name will be aligned left, bold and big
  show heading.where(level: 1): it => [
    #set align(author-position)
    #set text(
      weight: 700,
      size: 28pt,
    )
    #pad(it.body)
  ]

  // Level 1 Heading
  [= #(author)]

  // Personal Info Helper
  let contact-item(value, prefix: "", link-type: "") = {
    if value != "" {
      if link-type != "" {
        link(link-type + value)[#(prefix + value)]
      } else {
        value
      }
    }
  }

  // Personal Info
  pad(
    top: -2.5pt,
    align(personal-info-position)[
      #set text(size: 16pt) // Adjust text size for this section
      #{
        let items = (
          contact-item(email, link-type: "mailto:"),
          contact-item(phone),
          contact-item(location),
          contact-item(github, link-type: "https://"),
          contact-item(linkedin, link-type: "https://"),
          contact-item(personal-site, link-type: "https://"),
          contact-item(orcid, prefix: [#orcid-icon(color: rgb("#AECD54"))orcid.org/], link-type: "https://orcid.org/"),
        )
        items.filter(x => x != none and x != "").map(x => box(x)).join(" | ")
      }
    ],
  )

  pad(
    top: -7pt,
    line(length: 100%, stroke: 1pt)
  )
  

  // Main body.
  set par(justify: true)

  body
}

// Generic two by two component for resume
#let generic-two-by-two(
  top-left: "",
  top-right: "",
  bottom-left: "",
  bottom-right: "",
) = {
  [
    #top-left #h(1fr) #top-right \
    #bottom-left #h(1fr) #bottom-right
  ]
}

// Generic one by two component for resume
#let generic-one-by-two(
  left: "",
  right: "",
) = {
  [
    #left #h(1fr) #right
  ]
}

// Cannot just use normal --- ligature becuase ligatures are disabled for good reasons
#let dates-helper(
  start-date: "",
  end-date: "",
) = {
  start-date + " " + $dash.em$ + " " + end-date
}

#let formatDateRange(item, lang) = {
  let monthNames = getMonthNames(lang)
  
  if "startDate" in item and not "endDate" in item {
    dates-helper(
      start-date: formatDate(item.startDate, monthNames),
      end-date: get_section_title("actual", lang)
    )
  } else if "endDate" in item and not "startDate" in item {
    formatDate(item.startDate, monthNames)
  } else if "startDate" in item and "endDate" in item {
    if item.startDate == item.endDate {
      formatDate(item.startDate, monthNames)
    } else {
      dates-helper(
        start-date: formatDate(item.startDate, monthNames),
        end-date: formatDate(item.endDate, monthNames)
      )
    }
  } else {
    ""
  }
}

// Section components below
#let getWorkPart(job, lang) = {
  generic-two-by-two(
    top-left: strong(job.name),
    top-right: strong(formatDateRange(job, lang)),
    bottom-left: emph(job.position),
    ..if "location" in job and job.location != none {
      (bottom-right: emph(job.location))
    },
  )

  if "highlights" in job and job.highlights != none {
    for highlight in job.highlights {
      [- #highlight]
    }
  }
}

#let work(work: (), lang: "") = {
  build_section("work", work, getWorkPart, lang)
}

#let getProjectPart(proj, lang) = {
  generic-two-by-two(
    top-left: strong(proj.name),
    top-right: strong(formatDateRange(proj, lang)),
    ..if "roles" in proj and proj.roles != none and proj.roles.len() > 0 {
      (bottom-left: emph(proj.roles.join(", ")))
    },
    ..if "url" in proj and proj.url != none {
      (bottom-right: proj.url)
    },
  )

  if "highlights" in proj and proj.highlights != none {
    for highlight in proj.highlights {
      [- #highlight]
    }
  }
}

#let projects(projects: (), lang: "") = {
  build_section("projects", projects, getProjectPart, lang)
}

#let getEduPart(education_item, lang) = {
  generic-two-by-two(
    top-left: strong(education_item.institution),
    top-right: strong(getDegreeDate(lang, education_item)),
    bottom-left: emph(education_item.studyType + ", " + education_item.area),
  )
}

#let edu(education: (), lang: "") = {
  build_section("education", education, getEduPart, lang)
}

#let cumulativeCertSkillsInterests(
  certifications: (),
  skills: (),
  interests: (),
  lang: "",
) = {
  // Title line
  let title_text = ""
  if certifications != none and certifications.len() > 0 {
    title_text += upper(get_section_title("certifications", lang))
  }
  if skills != none and skills.len() > 0 {
    title_text += if title_text != "" { ", " } else { "" }
    title_text += upper(get_section_title("skills", lang))
  }
  if interests != none and interests.len() > 0 {
    title_text += if title_text != "" { " " + get_section_title("conjunction_word", lang) + " " } else { "" }
    title_text += upper(get_section_title("interests", lang))
  }

  let title = [== #title_text]

  // Certifications block
  let cert_block = if certifications != none and certifications.len() > 0 {
    block(breakable: false)[
      - #strong(get_section_title("certifications", lang)): #for (i, cert) in certifications.enumerate() {
        if i != 0 { ", " }
        cert.name
      }
    ]
  } else { none }

  // Skills blocks
  let skills_blocks = if skills != none and skills.len() > 0 {
    skills.map(skill => block(breakable: false)[
      - #strong(skill.name): #for (i, keyword) in skill.keywords.enumerate() {
        if i != 0 { ", " }
        keyword
      }
    ])
  } else { () }

  // Interests block
  let interests_block = if interests != none and interests.len() > 0 {
    block(breakable: false)[
      - #strong(get_section_title("interests", lang)): #for (i, interest) in interests.enumerate() {
        if i != 0 { ", " }
        interest.name
      }
    ]
  } else { none }

  // Collect all blocks, filter out none
  let all_blocks = (cert_block,).filter(x => x != none) + skills_blocks + (interests_block,).filter(x => x != none)

  // Use section_with_header if there is at least one block
  if all_blocks.len() > 0 {
    section_with_header(
      title,
      all_blocks.at(0),
      all_blocks.slice(1, all_blocks.len())
    )
  }
}
