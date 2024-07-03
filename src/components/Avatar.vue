<script setup lang="ts">
import { computed } from 'vue';

const props = defineProps<{
  svg: string;
}>();

const src = computed(
  () => `data:image/svg+xml;utf8,${encodeURIComponent(props.svg)}`
);
</script>

<template>
  <img :src="src" loading="lazy" />
</template>
