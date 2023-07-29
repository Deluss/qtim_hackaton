<template>
	<div class="room-list">
		<div class="room-list_element" v-for="elem in rooms" :key="elem.id" :id="elem.id" @click="openRoom(elem.id)">
			<div class="room-list_element__left">
				<div class="room-list_element__name">
					{{ elem.name }}
				</div>
			</div>
			<div class="room-list_element__right">
				<div class="room-list_element__state" :class="elem.state.toLowerCase()">
				</div>
				<div class="room-list_element__amt">
					{{ elem.amt }} / 2
				</div>
			</div>
		</div>
	</div>
</template>

<script>
export default {
  name: "RoomsListComponent",
  emits: ['open-room'],
  data() {
    return {
      rooms: [],
      url: undefined
      }
  },
  mounted() {
    this.url = process.env.VUE_APP_BACKROOM_URL
    this.joinRoom()
  },
  methods: {
    openRoom(elemId){
      if(!elemId) return
      this.$emit('open-room', elemId)
    },
    async joinRoom(){
      try {
        this.axios
            .post(`${this.url}/api/room/join`, {}, {headers: {nickname: this.$store.getters.nickname}})
            .then(res => {
              const temp = res.data.response;
              this.rooms.push({
                id: temp.id,
                name: `room - ${temp.id}`,
                state: temp.status,
                amt: 0,
              });
              this.$emit('open-room', temp.id)
            });
      }catch (e) {
        this.rooms = []
      }
    }
  }
}
</script>

<style scoped lang="scss">
.room-list {
	display: flex;
	flex-direction: column;
	flex-wrap: nowrap;

	&_element {
		display: flex;
		flex-direction: row;
		flex-wrap: nowrap;
		align-content: center;
		align-items: center;
		height: 42px;
		border: 1px solid black;
		border-bottom: none;
		cursor: pointer;
		justify-content: space-between;
		padding: 0.5em;

		&__name {

		}

		&__state {
			width: 16px;
			height: 16px;
			border-radius: 25px;
			background-color: whitesmoke;

			&.waiting {
				background-color: orange;
			}

			&.play {
				background-color: gray;
			}

			&.closed {
				background-color: red;
			}
		}

		&__amt {

		}

		&__right {
			display: flex;
			flex-direction: column-reverse;
			flex-wrap: nowrap;
			align-items: flex-end;
		}
	}

	&_element:last-child {
		border-bottom: 1px solid black;
	}

}
</style>
