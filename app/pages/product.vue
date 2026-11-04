<template lang="pug">
.redirect-container
</template>

<script setup lang="ts">
definePageMeta({
  middleware: [
    () => {
      return navigateTo('/', { redirectCode: 301 })
    },
  ],
})

onMounted(() => {
  navigateTo('/', { replace: true })
})
</script>
