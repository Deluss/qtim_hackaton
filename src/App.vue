<template>
  <div id="app">
<!--    <HelloWorld msg="Welcome to Your Vue.js App"/>-->
    <main-page-component />
  </div>
</template>

<script>
import MainPageComponent from "@/components/MainPageComponent.vue";
export default {
  name: 'App',
  components: {
    MainPageComponent,
  },
  mounted() {
    this.generateNick()
  },
  methods: {
    generateNick(){
      let nick = this.$store.getters.nickname;
      if (!nick){
        nick = `player-${(Math.random() + 1).toString(36).substring(7)}`
        this.$store.commit('setNickName', nick)
        this.nickname = nick
      }else{
        this.nickname = nick
      }
    },
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
