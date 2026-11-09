<template lang="pug">
.info-redirect-container
</template>

<script setup lang="ts">
import Setup from '@/js/setup'

Setup.setTitle('事業一覧')
Setup.setDescription('エノキ電気が行っている事業について')

definePageMeta({
  middleware: [
    () => {
      return navigateTo('/profile', { redirectCode: 301 })
    },
  ],
})

onMounted(() => {
  navigateTo('/profile', { replace: true })
})
</script>
