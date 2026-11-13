<template lang="pug">
.redirect-container
</template>

<script setup lang="ts">
import Setup from '@/js/setup'

Setup.setTitle('Twitter / X')
Setup.setDescription('ときえのき（エノキ電気）の公式Twitter / Xアカウントへリダイレクトします。')

definePageMeta({
  middleware: [
    () => {
      return navigateTo('https://twitter.com/jikantoki', {
        external: true,
        redirectCode: 301,
      })
    },
  ],
})

onMounted(() => {
  window.location.href = 'https://twitter.com/jikantoki'
})
</script>
