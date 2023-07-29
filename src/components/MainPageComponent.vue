<template>
  <div class="main-page">
    <rooms-right-menu-component v-on:open-room="openRoomMainPage"/>
    <game-component v-if="roomId" :room-id="roomId"/>
  </div>
</template>

<script>
import RoomsRightMenuComponent from "@/components/rooms/RoomsRightMenuComponent.vue";
import GameComponent from "@/components/game/GameComponent.vue";

export default {
  name: "MainPageComponent",
  components: {GameComponent, RoomsRightMenuComponent},
  data(){
    return {
      roomId: undefined
    }
  },
  methods: {
    openRoomMainPage(elemId){
      this.roomId = elemId
    }
  }
}
</script>

<style scoped>

</style>