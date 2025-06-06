(() => {
  'use strict';

  document.addEventListener('click', (e) => {
    const button = e.target.closest('[data-contai-model]');
    if (!button) return;
    
    e.preventDefault();
    
    const model = button.dataset.contaiModel;
    const recordId = button.dataset.contaiRecordId;
    const outputTarget = button.dataset.contaiOutputTarget;
    
    generateContaiContent(button, model, recordId, outputTarget);
  });

  function generateContaiContent(button, model, recordId, outputTarget) {
    const originalText = button.textContent;
    
    button.disabled = true;
    button.textContent = 'Generating...';
    
    fetch('/contai/generate', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.getAttribute('content')
      },
      body: JSON.stringify({
        model: model,
        id: recordId
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        updateOutput(outputTarget, data.content);
        showNotification('Content generated successfully!', 'success');
      } else {
        showNotification('Error: ' + (data.errors || data.error), 'error');
      }
    })
    .catch(() => {
      showNotification('Network error occurred', 'error');
    })
    .finally(() => {
      button.disabled = false;
      button.textContent = originalText;
    });
  }

  function updateOutput(fieldName, content) {
    const field = document.querySelector(`[name*="${fieldName}"]`);
    if (field) {
      field.value = content;
      field.dispatchEvent(new Event('input'));
    }
  }

  function showNotification(message, type) {
    const notification = document.createElement('div');
    notification.className = `contai-notification contai-${type}`;
    notification.textContent = message;
    
    Object.assign(notification.style, {
      position: 'fixed',
      top: '20px',
      right: '20px',
      padding: '10px 15px',
      borderRadius: '4px',
      color: 'white',
      zIndex: '1000',
      backgroundColor: type === 'success' ? '#28a745' : '#dc3545'
    });
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
      notification.remove();
    }, 3000);
  }
})();