import { Controller } from "stimulus"
import Chartkick from "chartkick"
import moment from 'moment'
import 'daterangepicker'

export default class extends Controller {
  static values = { identifier: Array }
  static targets = ["dateRange", "sum"];

  connect() {
    console.log(this.identifierValue)
    this.initDateRangePicker()
  }

  initDateRangePicker() {
    const options = {
      opens: 'left',
      ranges: {
        'Azi': [moment(), moment()],
        'Ieri': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Ultimele 7 zile': [moment().subtract(6, 'days'), moment()],
        'Ultimele 30 de zile': [moment().subtract(29, 'days'), moment()],
        'Luna aceasta': [moment().startOf('month'), moment().endOf('month')],
        'Luna trecută': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
      },
      startDate: moment().subtract(7, 'days'),
      endDate: moment()
    }

    $(this.dateRangeTarget).daterangepicker(options, this.updateCharts.bind(this))
  }

  updateCharts(start, end) {
    const startDate = start.format('YYYY-MM-DD')
    const endDate = end.format('YYYY-MM-DD')
    console.log(`Fetching data from ${startDate} to ${endDate}`)

    fetch(`/reports?start_date=${startDate}&end_date=${endDate}`, {
      headers: {
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      console.log("Received data:", data)

      this.identifierValue.forEach(chartId => {
        const chart = Chartkick.charts[chartId]
        console.log(chart);
        console.log(chartId);
        if (chart) {
          if (chartId === 'average_ratings_of_notices') {
            const chartData = data[chartId]
            const formattedData = chartData.map(item => ({
              name: item.ad_type_name,
              data: {
                [`${item.average_rating}`]: item.rating_count
              }
            }));
            chart.updateData(formattedData)
          } else if (chartId === 'price_earnings') {
            const chartData = data[chartId].map(category => ({
              name: category.name,
              data: category.earnings.reduce((obj, earning) => {
                const parsedPrice = parseFloat(earning.price);
                if (!isNaN(parsedPrice)) {
                  obj[earning.notice_title] = parsedPrice;
                } else {
                  console.error(`Invalid price format for ${earning.notice_title}: ${earning.price}`);
                }
                return obj;
              }, {})
            }));

            const totalPriceEarnings = data[chartId].reduce((total, category) => {
              return total + category.earnings.reduce((categoryTotal, earning) => {
                const parsedPrice = parseFloat(earning.price);
                return categoryTotal + (isNaN(parsedPrice) ? 0 : parsedPrice);
              }, 0);
            }, 0);

            chart.updateData(chartData);
            const sumTarget = this.sumTarget;
            if (sumTarget) {
              sumTarget.textContent = `${totalPriceEarnings.toFixed(2)} RON`;
            }
          } else {
            chart.updateData(data[chartId])
          }
        } else {
          console.error(`Chartkick chart instance for chart ${chartId} is not found.`)
        }
      })
    })
    .catch(error => {
      console.error("Error updating charts:", error)
    })
  }
}
