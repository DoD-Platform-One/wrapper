before(function () {
    cy.visit(Cypress.env('grafana_url'));
  
    if (Cypress.env('keycloak_test_enable')) {
      cy.wait(500);
      cy.contains('SSO').click();
      cy.performKeycloakLogin(Cypress.env('tnr_username'), Cypress.env('tnr_password'))
    } else {
      cy.get('input[name="user"]').type(Cypress.env('grafana_username'));
      cy.get('input[name="password"]').type(Cypress.env('grafana_password'));
      cy.contains('Log in').click();
      cy.wait(1000);
    }
});
  
describe('Wrapper Podinfo Dashboard Testing', function () {
  it('Test for Logs Dashboard', function () {
    cy.visit(`${Cypress.env('grafana_url')}/dashboards`);
    cy.wait(500);
    cy.get('div[data-testid="input-wrapper"]').within(() => {
      cy.get('input').type('Wrapper Podinfo Test Dashboard');
    })
    cy.wait(500);
    cy.get('a').contains('Wrapper Podinfo Test Dashboard').click();
    // Start intercept to use later in wait to ensure data actually finishes loading
    cy.intercept('POST', '**/query*').as('apiQuery');
    // this misspelling is intentional (part of the actual UI)
    cy.get('[data-testid="data-testid Panel header PodInfo CPU"]').should('not.contain', 'No data');
  });
});
