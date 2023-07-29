<template>
  <div class="">
    {{roomId}}
    <h1> game board</h1>
		<game-page />
  </div>
</template>

<script>
import GamePage from '@/components/GamePage.vue'

export default {
	components: { GamePage },
  props: {
    roomId: String
  },
  name: "GameCompoonent"
}
</script>

<style scoped>

</style>
