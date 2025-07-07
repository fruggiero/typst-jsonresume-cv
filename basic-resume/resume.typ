#import "base.typ": *

#let getProfile(resume, network) = {
  let profile = none

  if "profiles" in resume.basics and resume.basics.profiles != none {
    for p in resume.basics.profiles {
      if "network" in p and p.network == network {
        profile = p
        break
      }
    }
  }
  
  profile
}

// Set data
#let r = json("resume.json")
#let lang = r.meta.language
#let name = r.basics.name
#let address = r.basics.location.city + ", " + r.basics.location.region
#let emailAddress = r.basics.email
#let phoneNumber = r.basics.phone
#let website = r.basics.at("url", default:none) //Set to none if you want to hide it
#let githubProfile = none
#let linkedinProfile = none
#if getProfile(r, "GitHub") != none {
  githubProfile = getProfile(r, "GitHub").url
}
#if getProfile(r, "LinkedIn") != none {
  linkedinProfile = getProfile(r, "LinkedIn").url
}

// Configure visibility of sections
#let show_work = true
#let show_projects = true
#let show_education = true
#let show_cert_skills_interests = true

#show: resume.with(
  author: name,
  location: address,
  email: emailAddress,
  language: lang,
  ..if githubProfile != none {
    (github: githubProfile)
  },

  ..if linkedinProfile != none {
    (linkedin: linkedinProfile)
  },

  phone: phoneNumber,

  ..if website != none {
    ( personal-site: website )
  },
)

// Section work experience
#if show_work and r.work != none and r.work.len() > 0 {
  work(work: r.work, lang: lang)
}
// Section projects
#if show_projects and r.projects != none and r.projects.len() > 0 {
  projects(projects: r.projects, lang: lang)
}
// Section education
#if show_education and r.education != none and r.education.len() > 0 {
  edu(education: r.education, lang: lang)
}
// Section certificates, skills and interests
#if show_cert_skills_interests and (
  (("certificates" in r and r.certificates != none and r.certificates.len() > 0) or
  ("skills" in r and r.skills != none and r.skills.len() > 0) or
  ("interests" in r and r.interests != none and r.interests.len() > 0))
) {
  cumulativeCertSkillsInterests(
    ..if "certificates" in r and r.certificates != none {
      (certifications: r.certificates)
    },
    ..if "skills" in r and r.skills != none {
      (skills: r.skills)
    },
    ..if "interests" in r and r.interests != none and r.interests.len() > 0 {
      (interests: r.interests)
    },
    lang: lang,
  )
}