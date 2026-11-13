<template lang="pug">
.redirect-container
</template>

<script setup lang="ts">
import Setup from '@/js/setup'

Setup.setTitle('ブログ')
Setup.setDescription('ときえのきの公式ブログ（blog.caramelos.xyz）へリダイレクトします。')

definePageMeta({
  middleware: [
    () => {
      return navigateTo('https://blog.caramelos.xyz', {
        external: true,
        redirectCode: 301,
      })
    },
  ],
})

onMounted(() => {
  window.location.href = 'https://blog.caramelos.xyz'
})
</script>
