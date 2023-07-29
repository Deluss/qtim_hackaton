<template>
  <div id="app">
		<welcome-page
			v-if="showWelcomePage"
			@update="goGame"
		/>
    <game-page
			v-else
		/>
  </div>
</template>

<script>
import GamePage from '@/components/GamePage.vue'
import WelcomePage from '@/components/WelcomePage.vue'

export default {
  name: 'App',
  components: {
		GamePage,
		WelcomePage
  },
	data () {
		return {
			showWelcomePage: true
		}
	},
	methods: {
		goGame () {
			this.showWelcomePage = false
		}
	}
}
</script>

<style lang="scss">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
