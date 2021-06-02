import React from "react"
import PropTypes from "prop-types"
import CalendarDay from './CalendarDay';
class Calendar extends React.Component {
  render () {
    const weather_days = [];
    this.props.days.forEach((day) => {
      weather_days.push(
        <CalendarDay
          date={day.date}
          weather={day.weather}
          engagement={day.engagement}
          icon={day.icon}
        />
      );
    });
    return (
      <div className="calendar">{weather_days}</div>
    );
  }
}

Calendar.propTypes = {
  days: PropTypes.array
};
export default Calendar
