import '@hotwired/turbo-rails'
import { Application } from '@hotwired/stimulus'

let application

if (typeof window.Stimulus === "undefined") {
  application = Application.start()
  application.debug = false
  window.Stimulus = application
} else {
  application = window.Stimulus
}

import SpreeGoogleAnalyticsController from 'spree_google_analytics/controllers/spree_google_analytics_controller'

application.register('spree_google_analytics', SpreeGoogleAnalyticsController)