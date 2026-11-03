<template lang="pug">
.wait
  .wait-wrap(style="background:rgb(var(--v-theme-background));")
    img.splash-img(src="/icon.png")
    p.mt-4.text-h6.splash-text エノキ電気
    p.text-h7.splash-text ENOKI ELECTRONICS
    .ma-16
    .loading
      v-progress-linear(indeterminate)
</template>

<script lang="ts">
export default {
  name: 'Splash',
}
</script>

<style lang="scss" scoped>
.wait-wrap {
  position: fixed;
  z-index: 9999;
  width: 100%;
  height: 100%;
  background-color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  .splash-img {
    width: 128px;
    border-radius: 9999px;
  }
  .loading {
    width: 100px;
  }
}
</style>
