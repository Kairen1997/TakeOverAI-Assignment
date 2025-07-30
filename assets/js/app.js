// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

// Burger menu hooks
const BurgerMenuHooks = {
  mounted() {
    this.sidebar = this.el.querySelector("#sidebar")
    this.overlay = this.el.querySelector("#menu-overlay")
    this.isOpen = false

    // Handle burger menu toggle
    const toggleButton = this.el.querySelector('[data-action="toggle-menu"]')
    if (toggleButton) {
      toggleButton.addEventListener("click", (e) => {
        e.preventDefault()
        e.stopPropagation()
        this.toggleMenu()
      })
    }

    // Handle burger menu close
    const closeButtons = this.el.querySelectorAll('[data-action="close-menu"]')
    closeButtons.forEach(button => {
      button.addEventListener("click", (e) => {
        e.preventDefault()
        e.stopPropagation()
        this.closeMenu()
      })
    })

    // Close menu when clicking outside
    if (this.overlay) {
      this.overlay.addEventListener("click", () => {
        this.closeMenu()
      })
    }

    // Close menu on escape key
    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape" && this.isOpen) {
        this.closeMenu()
      }
    })

    // Close menu when clicking on navigation links
    const navLinks = this.el.querySelectorAll("nav a")
    navLinks.forEach(link => {
      link.addEventListener("click", () => {
        this.closeMenu()
      })
    })
  },

  toggleMenu() {
    if (this.isOpen) {
      this.closeMenu()
    } else {
      this.openMenu()
    }
  },

  openMenu() {
    if (this.sidebar && this.overlay) {
      this.sidebar.classList.remove("-translate-x-full")
      this.sidebar.classList.add("translate-x-0")
      this.overlay.classList.remove("hidden")
      this.isOpen = true
    }
  },

  closeMenu() {
    if (this.sidebar && this.overlay) {
      this.sidebar.classList.remove("translate-x-0")
      this.sidebar.classList.add("-translate-x-full")
      this.overlay.classList.add("hidden")
      this.isOpen = false
    }
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {
    BurgerMenu: BurgerMenuHooks
  }
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

