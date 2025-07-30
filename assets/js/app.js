// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

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

    // Handle explicit close buttons (e.g., overlay, X button)
    const closeButtons = this.el.querySelectorAll('[data-action="close-menu"]')
    closeButtons.forEach(button => {
      button.addEventListener("click", (e) => {
        e.preventDefault()
        e.stopPropagation()
        this.closeMenu()
      })
    })

    // Prevent menu from closing when clicking on navigation links within the sidebar
    const sidebarLinks = this.sidebar.querySelectorAll('a, button')
    sidebarLinks.forEach(link => {
      // Only prevent closing for links that don't have data-action="close-menu"
      if (!link.hasAttribute('data-action') || link.getAttribute('data-action') !== 'close-menu') {
        link.addEventListener("click", (e) => {
          // Allow toggle buttons and other interactive elements to work normally
          // Only prevent menu closure for navigation links (href attributes)
          if (link.tagName === 'A' && link.hasAttribute('href')) {
            // For navigation links, stop propagation but don't prevent default
            e.stopPropagation()
            // Don't close the menu for navigation links
          }
          // For buttons (like toggle buttons), allow them to work normally
          // Don't prevent default or stop propagation for buttons
        })
      }
    })

    // Close menu when clicking outside via overlay
    if (this.overlay) {
      this.overlay.addEventListener("click", () => {
        this.closeMenu()
      })
    }

    // Close menu on Escape key
    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape" && this.isOpen) {
        this.closeMenu()
      }
    })

    // Prevent LiveView from closing the menu during navigation
    this.handleEvent("phx:page-loading-start", () => {
      // Don't close menu on page loading
    })

    this.handleEvent("phx:page-loading-stop", () => {
      // Don't close menu on page loading stop
    })
  },

  toggleMenu() {
    this.isOpen ? this.closeMenu() : this.openMenu()
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

// Connect if there are any LiveViews on the page
liveSocket.connect()

// Expose liveSocket on window for debug
window.liveSocket = liveSocket