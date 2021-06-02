import React from "react"
import PropTypes from "prop-types"
class CalendarDay extends React.Component {
  render () {
    const img_url = "http://openweathermap.org/img/w/"+this.props.icon+".png"
    return (
      <div className="calendar-day card m-md-3 m-1 p-md-1 p-0">
        <img className="icon card-img-top w-100 h-auto" src={img_url} alt={this.props.weather}/>
        <div className="card-body">
          <h5 classNmae="card-title">{this.props.date}</h5>
          <p className="card-text">{this.props.engagement}</p>
        </div>
      </div>
    );
  }
}

CalendarDay.propTypes = {
  date: PropTypes.string,
  weather: PropTypes.string,
  engagement: PropTypes.string,
  icon: PropTypes.string,
};
export default CalendarDay
