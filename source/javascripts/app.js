(function () {
  var supportedLanguages = ['ru', 'en']
  var storageKey = 'articleLanguage'

  function storedLanguage() {
    try {
      return localStorage.getItem(storageKey)
    } catch (error) {
      return null
    }
  }

  function saveLanguage(language) {
    try {
      localStorage.setItem(storageKey, language)
    } catch (error) {
    }
  }

  function detectedLanguage() {
    var saved = storedLanguage()
    if (supportedLanguages.indexOf(saved) !== -1) {
      return saved
    }

    var languages = navigator.languages || [navigator.language || navigator.userLanguage || '']
    for (var i = 0; i < languages.length; i += 1) {
      var language = String(languages[i]).slice(0, 2).toLowerCase()
      if (supportedLanguages.indexOf(language) !== -1) {
        return language
      }
    }

    return 'en'
  }

  function availableLanguages() {
    var languages = {}

    Array.prototype.slice.call(document.querySelectorAll('[data-translation-content], [data-translation-title], [data-translation-menu-option]'))
      .map(function (element) {
        return element.getAttribute('data-translation-content') ||
          element.getAttribute('data-translation-title') ||
          element.getAttribute('data-translation-menu-option')
      })
      .forEach(function (language) {
        if (supportedLanguages.indexOf(language) !== -1) {
          languages[language] = true
        }
      })

    return supportedLanguages.filter(function (language) {
      return languages[language]
    })
  }

  function applyLanguage(language) {
    var available = availableLanguages()
    if (available.length === 0) {
      return
    }

    if (available.indexOf(language) === -1) {
      language = available[0]
    }

    document.documentElement.setAttribute('lang', language)

    Array.prototype.slice.call(document.querySelectorAll('[data-translation-content]')).forEach(function (element) {
      element.hidden = element.getAttribute('data-translation-content') !== language
    })

    Array.prototype.slice.call(document.querySelectorAll('[data-translation-title]')).forEach(function (element) {
      element.hidden = element.getAttribute('data-translation-title') !== language
    })

    var activeTitle = document.querySelector('[data-page-title][data-translation-title="' + language + '"]')
    if (activeTitle) {
      document.title = activeTitle.textContent
    }

    Array.prototype.slice.call(document.querySelectorAll('[data-i18n-' + language + ']')).forEach(function (element) {
      element.textContent = element.getAttribute('data-i18n-' + language)
    })

    Array.prototype.slice.call(document.querySelectorAll('[data-translation-menu]')).forEach(function (menu) {
      var label = menu.querySelector('[data-translation-current-label]')
      var button = menu.querySelector('[data-translation-menu-button]')

      menu.setAttribute('data-current-language', language)
      if (label) {
        label.textContent = language.toUpperCase()
      }
      if (button) {
        button.setAttribute('aria-label', language === 'ru' ? 'Article language: Russian' : 'Article language: English')
      }
      Array.prototype.slice.call(menu.querySelectorAll('[data-translation-menu-option]')).forEach(function (option) {
        option.setAttribute('aria-selected', option.getAttribute('data-translation-menu-option') === language ? 'true' : 'false')
      })
    })

    saveLanguage(language)
  }

  function closeLanguageMenus() {
    Array.prototype.slice.call(document.querySelectorAll('[data-translation-menu]')).forEach(function (menu) {
      var list = menu.querySelector('[data-translation-menu-list]')
      var button = menu.querySelector('[data-translation-menu-button]')

      menu.removeAttribute('data-open')
      if (list) {
        list.hidden = true
      }
      if (button) {
        button.setAttribute('aria-expanded', 'false')
      }
    })
  }

  document.addEventListener('DOMContentLoaded', function () {
    applyLanguage(detectedLanguage())

    Array.prototype.slice.call(document.querySelectorAll('[data-translation-menu-button]')).forEach(function (button) {
      button.addEventListener('click', function () {
        var menu = button.closest('[data-translation-menu]')
        if (!menu) {
          return
        }

        var list = menu.querySelector('[data-translation-menu-list]')
        if (!list) {
          return
        }

        var opened = menu.getAttribute('data-open') === 'true'

        closeLanguageMenus()
        if (!opened) {
          menu.setAttribute('data-open', 'true')
          list.hidden = false
          button.setAttribute('aria-expanded', 'true')
        }
      })
    })

    Array.prototype.slice.call(document.querySelectorAll('[data-translation-menu-option]')).forEach(function (option) {
      option.addEventListener('click', function () {
        applyLanguage(option.getAttribute('data-translation-menu-option'))
        closeLanguageMenus()
      })
    })

    document.addEventListener('click', function (event) {
      if (!event.target.closest || !event.target.closest('[data-translation-menu]')) {
        closeLanguageMenus()
      }
    })

    document.addEventListener('keydown', function (event) {
      if (event.key === 'Escape') {
        closeLanguageMenus()
      }
    })
  })
}())
