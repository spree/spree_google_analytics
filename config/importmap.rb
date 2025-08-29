pin 'application-spree_google_analytics', to: 'spree_google_analytics/application.js', preload: false

pin_all_from SpreeGoogleAnalytics::Engine.root.join('app/javascript/spree_google_analytics/controllers'),
             under: 'spree_google_analytics/controllers',
             to:    'spree_google_analytics/controllers',
             preload: 'application-spree_google_analytics'
