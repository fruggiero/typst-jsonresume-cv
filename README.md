# Typst Resume Template with JsonResume Integration

A modern, clean resume template built with [Typst](https://typst.app/) that integrates seamlessly with the [JsonResume](https://jsonresume.org/) standard. This template is based on the excellent [basic-typst-resume-template](https://github.com/stuxf/basic-typst-resume-template) by stuxf, enhanced with JsonResume compatibility and multilingual support.

## ✨ Features

- **JsonResume Integration**: Uses the standard JsonResume format for data
- **Multilingual Support**: Built-in support for Italian and English (easily extensible)
- **Clean Design**: Professional, ATS-friendly layout
- **Modular Architecture**: Separate layout logic from data handling
- **Customizable Sections**: Show/hide sections as needed
- **Unbreakable Headers**: Section titles stay with their content
- **Modern Typography**: Beautiful typography with customizable fonts and colors

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/fruggiero/typst-jsonresume-cv.git
   cd typst-jsonresume-cv
   ```

2. **Install dependencies** (optional, for automation)
   ```bash
   npm install
   ```

3. **Edit your resume data**
   - Update `basic-resume/resume.json` with your information following the [JsonResume schema](https://jsonresume.org/schema/)

4. **Customize the template** (optional)
   - Edit `basic-resume/resume.typ` to show/hide sections or adjust settings
   - Modify `basic-resume/base.typ` for layout changes

5. **Generate your resume**
   ```bash
   # Using Typst directly
   typst compile basic-resume/resume.typ
   
   # Or using the automation script
   npm start
   ```

## 📁 Project Structure

```
cv/
├── basic-resume/
│   ├── base.typ          # Layout and styling logic
│   ├── resume.typ        # Data integration and composition
│   ├── resume.json       # Your resume data (JsonResume format)
│   └── resume.pdf        # Generated PDF output
├── index.js              # Node.js automation script
├── package.json          # Dependencies and scripts
└── README.md
```

## 🛠️ Architecture

### Separation of Concerns

- **`base.typ`**: Contains all layout, styling, and presentation logic. No dependencies on JsonResume format.
- **`resume.typ`**: Handles data extraction from JsonResume and composes the final document. Allows easy customization.
- **`resume.json`**: Standard JsonResume data file.

### Key Components

- **`section_with_header`**: Ensures section titles stay with their first content item (unbreakable)
- **`build_section`**: Generic section builder that handles empty sections gracefully
- **`formatDateRange`**: Intelligent date range formatting with multilingual support
- **`getProfile`**: Helper function to extract social media profiles from JsonResume data
- **Multilingual sections**: Automatic translation of section titles via `get_section_title`
- **Date formatting**: Smart handling of ongoing positions, single dates, and date ranges
- **Modular sections**: Work, Education, Projects, Skills, Certifications, Interests
- **Cumulative sections**: Skills, certifications, and interests can be combined in one section

## ⚙️ Customization

### Show/Hide Sections

Edit the configuration variables in `resume.typ`:

```typst
// Configure visibility of sections
#let show_work = true
#let show_projects = true
#let show_education = true
#let show_cert_skills_interests = true
```

### Language Support

Set your language in `resume.json`:

```json
{
  "meta": {
    "language": "it"
  }
}
```

### Styling

Customize colors, fonts, and layout in the `resume.with()` call:

```typst
#show: resume.with(
  author: name,
  location: address,
  email: emailAddress,
  language: lang,
  accent-color: "#2D6A4F",  // Change accent color
  font: "Garamond",         // Change font family
  paper: "a4",              // Paper size
  // ...other parameters...
)
```

## 🌍 Adding New Languages

1. **Add translations** to the `section_titles` dictionary in `base.typ`:

```typst
#let section_titles = (
  work: (it: "Esperienza Lavorativa", en: "Work Experience", fr: "Expérience"),
  education: (it: "Istruzione", en: "Education", fr: "Formation"),
  // ...existing sections...
)
```

2. **Add month names** to `getMonthNames()` function:

```typst
#let getMonthNames(lang) = {
  if lang == "it" {
    // ...existing Italian months...
  } else if lang == "fr" {
    return (
      "01": "Jan", "02": "Fév", "03": "Mar", "04": "Avr",
      // ...other French months...
    )
  } else {
    // ...existing English months...
  }
}
```

## 🤖 Automation

The project includes multiple automation options:

### Node.js Script
Use the included Node.js script for automated PDF generation:

```bash
npm start
# or
node index.js
```

This script compiles the Typst document and handles any errors gracefully.

## 📋 JsonResume Schema

This template supports the full [JsonResume schema](https://jsonresume.org/schema/). Key supported sections:

- **basics**: Name, contact information, profiles (GitHub, LinkedIn, etc.)
- **work**: Work experience with highlights and location
- **education**: Educational background with degrees and institutions
- **projects**: Personal/professional projects with roles and URLs
- **skills**: Technical skills organized by category with keywords
- **certificates**: Certifications and licenses
- **interests**: Personal interests and hobbies

### Example JsonResume Structure

```json
{
  "meta": {
    "language": "en"
  },
  "basics": {
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "location": {
      "city": "San Francisco",
      "region": "CA"
    },
    "profiles": [
      {
        "network": "GitHub",
        "url": "github.com/johndoe"
      }
    ]
  },
  "work": [
    {
      "name": "Company Name",
      "position": "Software Engineer",
      "startDate": "2020-01",
      "endDate": "2023-12",
      "highlights": [
        "Led development of key features",
        "Improved system performance by 30%"
      ]
    }
  ]
}
```

## 🎨 Usage Examples

### Basic Resume Composition

```typst
#import "base.typ": *

#let r = json("resume.json")
#let lang = r.meta.language

#show: resume.with(
  author: r.basics.name,
  location: r.basics.location.city + ", " + r.basics.location.region,
  email: r.basics.email,
  language: lang,
  accent-color: "#2D6A4F"
)

// Sections are automatically included based on show_* variables
```

### Custom Section Order

```typst
// In resume.typ body parameter:
body: [
  // Sezione Esperienza Lavorativa
  #if show_work and r.work != none and r.work.len() > 0 {
    #work(work: r.work, lang: lang)
  }
  // Sezione Progetti
  #if show_projects and r.projects != none and r.projects.len() > 0 {
    #projects(projects: r.projects, lang: lang)
  }
  // Sezione Istruzione
  #if show_education and r.education != none and r.education.len() > 0 {
    #edu(education: r.education, lang: lang)
  }
  // Sezione Certificazioni, Competenze, Interessi
  #if show_cert_skills_interests {
    #cumulativeCertSkillsInterests(
      certifications: r.certificates,
      skills: r.skills,
      interests: r.interests,
      lang: lang
    )
  }
]
```

## 🔧 Advanced Customization

### Adding New Section Types

1. **Create a section builder function** in `base.typ`:

```typst
#let getCustomPart(item, lang) = {
  generic-two-by-two(
    top-left: strong(item.title),
    top-right: strong(item.date),
    bottom-left: emph(item.description),
  )
}

#let custom(items: (), lang: "") = {
  build_section("custom", items, getCustomPart, lang)
}
```

2. **Add translations** for the new section:

```typst
#let section_titles = (
  // ...existing sections...
  custom: (it: "Sezione Personalizzata", en: "Custom Section"),
)
```

### Custom Date Formatting

The template includes intelligent date formatting that handles:
- Single dates
- Date ranges
- Ongoing positions (shows "Present" or "Attuale")
- Same start/end dates

## 🚀 Performance Tips

- **Large JsonResume files**: The template efficiently handles large resume files
- **Multiple languages**: Switch languages by changing the `meta.language` field
- **PDF optimization**: Generated PDFs are optimized for ATS systems

## 🙏 Credits

- **Original Template**: [basic-typst-resume-template](https://github.com/stuxf/basic-typst-resume-template) by stuxf
- **Data Standard**: [JsonResume](https://jsonresume.org/) community
- **Typesetting Engine**: [Typst](https://typst.app/) team
- **Icons**: [Science Icons](https://github.com/jneug/typst-scienceicons) for ORCID support

## 📄 License

This project maintains the same license as the original template. Please check the original repository for license details.

## 🤝 Contributing

Contributions are welcome! Feel free to:

- **Add new languages**: Extend the multilingual support
- **Improve layouts**: Enhance the visual design
- **Add features**: New section types, better date handling, etc.
- **Fix bugs**: Report and fix any issues
- **Documentation**: Improve examples and guides

### Development Setup

1. Install [Typst](https://typst.app/docs/installation/)
2. Clone the repository
3. Make your changes to `base.typ` or `resume.typ`
4. Test with `typst compile basic-resume/resume.typ`
5. Submit a pull request

## 🐛 Troubleshooting

### Common Issues

**"Cannot loop over content" error**
- Check that arrays are properly formed in `cumulativeCertSkillsInterests`
- Ensure `skills_blocks` is an array, not content
- Verify you're using the correct syntax for building arrays with filter operations

**"Type content has no method filter" error**
- This occurs when trying to filter content blocks instead of arrays
- Use proper array construction: `(item1, item2).filter(x => x != none)`
- Ensure spread operators are used correctly in content blocks

**Missing translations**
- Add missing language keys to `section_titles`
- Verify `meta.language` is set correctly in `resume.json`

**Date formatting issues**
- Ensure dates follow `YYYY-MM` or `YYYY-MM-DD` format
- Check for typos in date fields

**PDF not generating**
- Verify Typst installation: `typst --version`
- Check for syntax errors in `.typ` files
- Ensure `resume.json` is valid JSON

## 📞 Support

If you encounter issues:

1. **Check the documentation**: [Typst Docs](https://typst.app/docs/) and [JsonResume Schema](https://jsonresume.org/schema/)
2. **Review examples**: Look at the provided `resume.json` example
3. **Search issues**: Check existing GitHub issues
4. **Create an issue**: Provide minimal reproduction steps

---

**Happy resume building!** 🎯

*Create beautiful, professional resumes with the power of Typst and the flexibility of JsonResume.*
