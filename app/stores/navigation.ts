import { defineStore } from 'pinia'

export const useNavigationStore = defineStore('navigation', {
  state: () => ({
    /** その他ダイアログの表示状態 */
    optionsDialog: false,
  }),
  actions: {
    openOptions() {
      this.optionsDialog = true
    },
    closeOptions() {
      this.optionsDialog = false
    },
    toggleOptions() {
      this.optionsDialog = !this.optionsDialog
    },
  },
})
