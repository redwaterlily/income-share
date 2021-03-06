import React from "react";
import {
  Container,
  Menu,
  Modal,
  Button,
  Grid,
  Image,
  Header
} from "semantic-ui-react";
import { Link } from "react-router-dom";
import metamask from "../static/metamask.png";
import "../index.css";

export const FixedMenu = ({ contract, accounts }) => (
  <Menu
    style={{ height: "85px", background: "rgba(41, 52, 61, 0.8)", paddingLeft:"15%", paddingRight:"15%" }}
    fixed="top"
    inverted
  >
      
      <Menu.Item as={Link} to="/" header style={{fontSize:"25px"}}>
        Income Share Portal
      </Menu.Item>
      <Menu.Item as={Link} to="/agreements" header>
        Agreements
      </Menu.Item>
      <Menu.Item as={Link} to="/manage" header>
        Manage
      </Menu.Item>
      <Menu.Item as={Link} to="/student" header>
        Student
      </Menu.Item>

      <Menu.Item position="right">
        {renderWelcome(contract, accounts)}
      </Menu.Item>
      <Menu.Item
        as="a"
        target="_"
        href="https://github.com/open-esq/"
        position=""
      >
     <Image size="mini" src="https://i.ibb.co/cXMrJSb/Open-Esq-Clipped.png" />
          <Header as="h3" style={{ paddingLeft:"7px", margin:"0", color:"#e6e6e6"}}>Open Esquire</Header>

      </Menu.Item>
  </Menu>
);

const renderWelcome = (contract, accounts) => {
  if (contract == undefined) {
    return <MetaMaskModal />;
  } else if (accounts && accounts.length == 0) {
    return (
      <div>
        {" "}
        <strong>Please unlock your Metamask account! </strong>
        <Image style={{ display: "inline-block" }} src={metamask} />
      </div>
    );
  } else {
    return (
      <div>
        Welcome, <strong>{accounts[0]}</strong>!
      </div>
    );
  }
};

const MetaMaskModal = () => (
  <div>
    <div
      style={{ marginTop: "-5px", paddingBottom: "5px", fontWeight: "bold" }}
    >
      Running on Rinkeby Testnet
    </div>
    <Modal
      basic
      size={"tiny"}
      trigger={
        <Button className="metaBtn">
          Get Metamask{" "}
          <Image style={{ display: "inline-block" }} src={metamask} />
        </Button>
      }
    >
      <Modal.Header
        className="modalHeader"
        style={{ fontSize: "1.6em", color: "#F0F2EB" }}
      >
        Let's get you set up!{" "}
      </Modal.Header>
      <Modal.Content image style={{ paddingLeft: "60px" }}>
        <Modal.Description>
          <Grid columns={2}>
            <Grid.Row>
              <Grid.Column>
                <Header
                  as="h2"
                  content="Install and Setup MetaMask"
                  className="modalText"
                  style={{ color: "#00B6E4", marginBottom: "-20px" }}
                />
              </Grid.Column>
              <Grid.Column>
                <Image style={{ display: "inline-block" }} src={metamask} />
              </Grid.Column>
            </Grid.Row>
            <Grid.Row>
              <Grid.Column>
                <h3 className="modalSubText">
                  Click{" "}
                  <a className="modalLink" href="https://metamask.io/">
                    here{" "}
                  </a>
                  to install
                </h3>
              </Grid.Column>
            </Grid.Row>
          </Grid>
          <Grid columns={2}>
            <Grid.Row>
              <Grid.Column>
                <Header
                  as="h2"
                  content="Unlock your MetaMask"
                  className="modalText"
                  style={{ color: "#00B6E4", marginBottom: "-20px" }}
                />
              </Grid.Column>
              <Grid.Column>
                <Image style={{ display: "inline-block" }} src={metamask} />
              </Grid.Column>
            </Grid.Row>
          </Grid>

          <Grid columns={2}>
            <Grid.Row>
              <Grid.Column>
                <Header
                  as="h2"
                  content="Connect to the Rinkeby Ethereum network"
                  className="modalText"
                  style={{ color: "#00B6E4" }}
                />
              </Grid.Column>
            </Grid.Row>
          </Grid>
        </Modal.Description>
      </Modal.Content>
      <div />
    </Modal>
  </div>
);

export default FixedMenu;
