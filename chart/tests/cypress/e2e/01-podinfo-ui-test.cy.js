describe('Basic Podinfo Tests', function() {
    it('Check Podinfo is accessible', function() {
        cy.visit(Cypress.env('podinfo_url'))
    })
  })
