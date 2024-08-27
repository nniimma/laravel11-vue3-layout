<template>
    <Header/>
    <main>
      <slot />
    </main>
    <Footer />
</template>

<script setup>
    // Imports
    import Header from './Header.vue';
    import Footer from './Footer.vue';

    // Uses

    // Refs

    // Props & Emits

    // Computed

    // Methods

    // Hooks
</script>
<style scoped lang="scss">
    @import '@scss/layout/layout.scss';
    
</style>