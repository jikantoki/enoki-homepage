import { defineCustomElements } from '@ionic/pwa-elements/loader'

export default defineNuxtPlugin(() => {
  defineCustomElements(window)
})
