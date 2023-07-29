<template>
  <div class="right-menu">
    <div class="nickname">
      <label>
        <input disabled :value="this.$store.getters.nickname">
      </label>
    </div>
    <div class="sidenav">
      <rooms-list-component v-on:open-room="openRoomFromRightMenu"/>
    </div>
  </div>
</template>

<script>
import RoomsListComponent from "@/components/rooms/RoomsListComponent.vue";

export default {
  name: "RoomsRightMenuComponent",
  emits: ['open-room'],
  components: {RoomsListComponent},
  data(){
    return{
      nickname: undefined
    }
  },
  mounted() {


  },
  methods: {

    openRoomFromRightMenu(elemId){
      this.$emit('open-room', elemId);
    }
  }
}
</script>

<style scoped lang="scss">
.sidenav{
  max-width: 100%;
}
.right-menu{
  position: absolute;
  width: 25%;
  top: 0;
  left: 0;
  height: 100vh;
  box-shadow: 0 3px 5px #dedede;
}
</style>