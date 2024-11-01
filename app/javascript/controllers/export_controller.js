import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['form']
  static values = {
    mainForm: { type: String, default: '' },
  }

  connect() {
    this.formTarget.addEventListener('submit', this.onSubmit.bind(this))
  }

  onSubmit() {
    this.changeURL()
  }

  changeURL() {
    this.formTarget.querySelectorAll("input[name]:not([name='authenticity_token']):not([name='email'])").forEach(el => el.remove())
    const mainFormElements = Array.from(document.querySelector(this.mainFormValue).elements)
    mainFormElements.forEach(el => this.addHiddenField(el.name, el.value))
  }

  addHiddenField(key, value) {
    const input = document.createElement('input')
    input.type = 'hidden'
    input.name = key
    input.value = value
    this.formTarget.appendChild(input)
  }

  disconnect() {
    this.formTarget.removeEventListener('submit', this.onSubmit.bind(this))
  }
}
