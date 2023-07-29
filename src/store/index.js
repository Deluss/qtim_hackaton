import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)
export default new Vuex.Store({
  state: {

    nickname: localStorage.getItem('nickname') || undefined
  },
  getters: {
    nickname: state => {
      return state.nickname
    }
  },
  mutations: {
    setNickName: (state, payload) => {
      state.nickname = payload
      localStorage.setItem('nickname', payload)
    }
  },
  actions: {
  },
  modules: {
  }
})
