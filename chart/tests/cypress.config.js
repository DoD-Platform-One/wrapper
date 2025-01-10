
module.exports = {
    e2e: {
      env: {
        podinfo_url: "https://podinfo.dev.bigbang.mil",
        grafana_url: "https://grafana.dev.bigbang.mil",
        grafana_username: "admin",
        grafana_password: "prom-operator",
      },
      testIsolation: true,
      video: true,
      screenshot: true,
      supportFile: false,
      setupNodeEvents(on, config) {
        // implement node event listeners here
      },
    },
  }
  