import React from "react";
import { Container, Loader, Tab } from "semantic-ui-react";
import "semantic-ui-css/semantic.min.css";
import Web3Container from "../utils/Web3Container";
import IncomeAssignmentContract from "../contracts/IncomeAssignment.json";
import OwnedTokens from "./OwnedTokens"

class Manage extends React.Component {

  render() {

    const panes = [
      {
        menuItem: "Owned Tokens",
        render: () => (
          <Tab.Pane
          >
            <OwnedTokens/>
          </Tab.Pane>
        )
      },
      {
        menuItem: "Assignments",
        render: () => (
          <Tab.Pane

          >
            Yo here now
          </Tab.Pane>
        )
      }
    ]
    return (
      <Container style={{ marginTop: "7em" }}>
        <Tab menu={{}} panes={panes} />
      </Container>
    );
  }
}

export default () => (
  <Web3Container
    contractJSON={IncomeAssignmentContract}
    renderLoading={() => <div>Loading</div>}
    render={({ web3, accounts, contract }) => (
      <Manage web3={web3} accounts={accounts} contract={contract} />
    )}
  />
);