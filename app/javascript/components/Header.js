import React from "react"
import PropTypes from "prop-types"
class Header extends React.Component {
  render () {
    return (<header>
        <h1 className="m-2">Acme Engagement Tool</h1>
        <h2 className="p-4">Five Day Forecast for {this.props.location}</h2>
      </header>);
  }
}

Header.propTypes = {
  location: PropTypes.string
};
export default Header
