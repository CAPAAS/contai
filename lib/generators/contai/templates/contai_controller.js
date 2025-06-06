import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"]
  static values = { 
    model: String, 
    recordId: Number,
    outputTarget: String
  }

  connect() {
    this.setupButton()
  }

  setupButton() {
    const button = this.element.querySelector('.contai-generate-btn')
    if (button) {
      button.addEventListener('click', this.generate.bind(this))
    }
  }

  async generate(event) {
    event.preventDefault()
    
    const button = event.target
    const originalText = button.textContent
    
    try {
      button.disabled = true
      button.textContent = 'Generating...'
      
      const response = await fetch('/contai/generate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.getCSRFToken()
        },
        body: JSON.stringify({
          model: this.modelValue,
          id: this.recordIdValue
        })
      })
      
      const data = await response.json()
      
      if (data.success) {
        this.updateOutput(data.content)
        this.showSuccess()
      } else {
        this.showError(data.errors || [data.error])
      }
    } catch (error) {
      this.showError(['Network error occurred'])
    } finally {
      button.disabled = false
      button.textContent = originalText
    }
  }

  updateOutput(content) {
    if (this.hasOutputTarget) {
      this.outputTarget.value = content
      this.outputTarget.dispatchEvent(new Event('input', { bubbles: true }))
    } else {
      const fieldName = this.outputTargetValue || 'body'
      const field = this.element.querySelector(`[name*="${fieldName}"]`)
      if (field) {
        field.value = content
        field.dispatchEvent(new Event('input', { bubbles: true }))
      }
    }
  }

  showSuccess() {
    this.showNotification('Content generated successfully!', 'success')
  }

  showError(errors) {
    const message = Array.isArray(errors) ? errors.join(', ') : errors
    this.showNotification(`Error: ${message}`, 'error')
  }

  showNotification(message, type) {
    const notification = document.createElement('div')
    notification.className = `contai-notification contai-${type}`
    notification.textContent = message
    notification.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      padding: 10px 15px;
      border-radius: 4px;
      color: white;
      z-index: 1000;
      background-color: ${type === 'success' ? '#28a745' : '#dc3545'};
    `
    
    document.body.appendChild(notification)
    
    setTimeout(() => {
      notification.remove()
    }, 3000)
  }

  getCSRFToken() {
    const token = document.querySelector('meta[name="csrf-token"]')
    return token ? token.getAttribute('content') : ''
  }
}
