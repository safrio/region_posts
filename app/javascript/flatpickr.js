const flatpickr = require("flatpickr")
const config = {
  mode: 'range',
  static: false,
  monthSelectorType: 'static',
  dateFormat: 'M j, Y H:i',
  enableTime: true,
  time_24hr: true,
  defaultHour: 0,
  prevArrow: '<svg class="fill-current" width="7" height="11" viewBox="0 0 7 11"><path d="M5.4 10.8l1.4-1.4-4-4 4-4L5.4 0 0 5.4z" /></svg>',
  nextArrow: '<svg class="fill-current" width="7" height="11" viewBox="0 0 7 11"><path d="M1.4 10.8L0 9.4l4-4-4-4L1.4 0l5.4 5.4z" /></svg>',
  locale: {
    rangeSeparator: ' - ',
    firstDayOfWeek: 1
  },
  parseDate: function(date) {
    return new Date(Date.parse(date))
  },
  onOpen: () => {
  },
  onReady: (_selectedDates, _dateStr, instance) => {
    const customClass = instance.element.getAttribute('data-class')
    instance.calendarContainer.classList.add(customClass)
    if (instance.element.dataset?.startDate && instance.element.dataset?.endDate) {
      instance.setDate([instance.element.dataset.startDate, instance.element.dataset.endDate])
    }
  },
  onChange: (selectedDates, _dateStr, instance) => {
    if (selectedDates.length === 1) {
      var dateStart = instance.formatDate(selectedDates[0], 'M j, Y H:i')
      var dateEnd = instance.formatDate(selectedDates[0], 'M j, Y H:i')

      return instance.element.value = dateStart + ' - ' + dateEnd
    }
  },
  onKeyDown: (selectedDates, _dateStr, instance) => {
    if (instance.element.dataset.disableOnKeydown) return

    if (event.key === 'Enter' && selectedDates.length === 2) {
      instance.close()
      instance.element.form.requestSubmit()
    }
  },
  onClose: (selectedDates, _dateStr, _instance) => {
    if (_instance.element.dataset.disableOnClose) return

    const eventData = { selectedDates: selectedDates }
    const event = new CustomEvent('datepickerClosed', { detail: eventData })

    document.dispatchEvent(event)
  }
}

const connectFlatPickr = () => flatpickr('#flatpickr', config)

document.addEventListener("turbo:load", connectFlatPickr)
document.addEventListener("turbo:frame-load", connectFlatPickr)
