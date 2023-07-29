<template>
	<div class="game">
		<div class="game__container">
			<div class="game__header">
				<div class="game__theme">
					Тема: {{ theme }}
				</div>
				<div :class="['game__timer', { 'game__timer_warning': getTimer <= warningTimer }]">
					<img
						class="game__clock"
						src="@/assets/clock.svg"
						alt="clock"
					>
					{{ formatSecondsToMinutesSeconds }}
				</div>
			</div>
			<div class="game__content">
				<div class="game__main">
					<transition name="fade">
						<div
							v-if="showFinish"
							class="game__finish"
						>
							<div class="game__finish-content">
								<div class="game__finish-wrapper">
									<div class="game__finish-text">
										{{ finishMessage }}
									</div>
									<button
										class="game__finish-btn"
										@click="reset"
									>
										Играть снова
									</button>
								</div>
							</div>
						</div>
					</transition>
					<div class="game__word">
						<div
							v-for="(wordLetter, index) in searchWord"
							:key="`wordletter-${index}`"
							class="game__word-letter"
							:style="{
								width: `calc(100% / ${searchWord.length})`
							}"
						>
							{{ wordLetter }}
						</div>
					</div>
					<div class="game__letters">
						<div
							v-for="(item) in getLettersList"
							:key="`letter-${item.letter}`"
							:class="['game__letter', `game__letter_${item.state}`]"
							@click="checkLetter(item)"
						>
							{{ item.letter }}
						</div>
					</div>
				</div>
				<div class="game__gallows">
					<canvas
						id="hangmanCanvas"
						ref="hangmanCanvas"
						width="300"
						height="400"
						class="game__canvas"
					/>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
export default {
	name: 'GamePage',
	data () {
		return {
			theme: '',
			attempts: 0,
			timer: 300,
			maxTimer: 300,
			warningTimer: 30,
			alphabet: ['а', 'б', 'в', 'г', 'д', 'е', 'ё', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я'],
			lettersList: [],
			currentWord: '',
			intervalId: null,
			searchWord: [],
			showFinish: false,
			finishMessage: '',
			pencil: new Audio(require('@/assets/pencil.mp3')),
			tickTock: new Audio(require('@/assets/tickTock.mp3')),
			gameOver: new Audio(require('@/assets/gameOver.mp3')),
			win: new Audio(require('@/assets/win.mp3')),
			welcomePage: true,
			items: [{
				theme: 'Еда',
				list: [
					'хлеб', 'суп', 'салат', 'пирог', 'торт', 'пицца', 'макароны', 'рис',
					'картофель', 'мясо', 'рыба', 'яйцо', 'сыр', 'молоко', 'йогурт',
					'фрукты', 'яблоко', 'апельсин', 'банан', 'виноград', 'помидор',
					'огурец', 'лук', 'чеснок', 'морковь', 'капуста', 'грибы',
					'чай', 'кофе', 'сахар', 'соль', 'перец', 'масло', 'кетчуп',
					'горчица', 'вода', 'сок', 'кола', 'пиво','вино', 'торт',
					'пирожное', 'мороженое', 'шоколад', 'конфеты', 'орехи',
					'изюм', 'мёд', 'десерт'
				]}, {
				theme: 'Одежда',
				list: ['куртка',
					'пальто', 'пуховик', 'свитер', 'джемпер', 'рубашка', 'футболка',
					'майка', 'блуза', 'платье', 'юбка', 'брюки', 'джинсы', 'шорты',
					'колготки', 'носки', 'трусы', 'лифчик', 'тапочки', 'туфли', 'ботинки',
					'сапоги', 'шапка', 'шарф', 'перчатки', 'костюм', 'пиджак', 'галстук', 'платок',
					'сумка', 'рюкзак', 'кошелек', 'очки', 'часы', 'украшения', 'пояс', 'шляпа',
				]
			}]
		}
	},
	computed: {
		getLettersList () {
			return this.lettersList
		},
		formatSecondsToMinutesSeconds () {
			const minutes = Math.floor(this.timer / 60);
			const remainingSeconds = this.timer % 60;
			const formattedMinutes = String(minutes).padStart(2, '0');
			const formattedSeconds = String(remainingSeconds).padStart(2, '0');
			return `${ formattedMinutes }:${ formattedSeconds }`;
		},
		getTimer () {
			return this.timer
		}
	},
	mounted () {
		this.init()
	},
	methods: {
		init () {
			this.win.pause()
			this.win.currentTime = 0
			this.tickTock.pause()
			this.tickTock.currentTime = 0
			this.gameOver.pause()
			this.gameOver.currentTime = 0
			this.clearCanvas()
			this.searchWord = []
			this.lettersList = this.createLettersList()
			this.runTimer()
			this.generateWord()
		},
		clearCanvas () {
			this.attempts = 0
			const canvas = this.$refs.hangmanCanvas;
			const ctx = canvas.getContext('2d');
			ctx.clearRect(0, 0, canvas.width, canvas.height);
		},
		reset () {
			this.showFinish = false
			this.finishMessage = ''
			this.init()
		},
		generateWord () {
			const randomItem = this.items[Math.floor(Math.random() * this.items.length)]
			const randomValue = randomItem.list[Math.floor(Math.random() * randomItem.list.length)]

			this.theme = randomItem.theme
			this.currentWord = randomValue
			console.log(this.currentWord)

			for (let i = 0; i < this.currentWord.length; i++) {
				this.searchWord.push('')
			}
		},
		createLettersList () {
			return this.alphabet.map(letter => {
				return {
					letter,
					state: 'unchecked',
					position: []
				}
			})
		},
		runTimer () {
			this.timer = this.maxTimer
			this.intervalId = setInterval(() => {
				this.timer -= 1
				if (this.timer === 0) {
					this.tickTock.pause()
					this.tickTock.currentTime = 0
					this.showGameOver('Время вышло. Вы проиграли :(')
				}
				if (this.timer === this.warningTimer) {
					this.tickTock.play()
				}
			}, 1000)
		},
		showGameOver (text = 'Вы проиграли :(') {
			this.tickTock.pause()
			this.tickTock.currentTime = 0
			this.gameOver.play()
			this.finishMessage = text
			this.showFinish = true
			clearInterval(this.intervalId)
			this.intervalId = null
		},
		checkLetter (item) {
			if (item.state === 'unchecked') {
				const positions = []
				for (let i = 0; i < this.currentWord.length; i++) {
					if (this.currentWord[i] === item.letter) {
						positions.push(i);
					}
				}
				if (positions.length) {
					item.state = 'exist'
					item.position = positions

				} else {
					item.state = 'absent'
					item.position = []
					this.attempts += 1
					this.playPencil()
					this.drawHangman()
					if (this.attempts === 10) {
						this.showGameOver('Вы проиграли :(')
					}
				}

				this.setPosition(item)
			}
		},
		setPosition (item) {
			if (item.position.length) {
				item.position.map(position => {
					this.searchWord[position] = item.letter
				})

				const count = this.searchWord.filter(item => item !== '').length

				if (count === this.currentWord.length) {
					clearInterval(this.intervalId)
					this.intervalId = null
					this.showFinish = true
					this.finishMessage = 'Вы выйграли'
					this.tickTock.pause()
					this.tickTock.currentTime = 0
					this.win.play()
				}
			}
		},
		playPencil () {
			this.pencil.playbackRate = 1
			this.pencil.play()
		},
		drawHangman() {
			const canvas = this.$refs.hangmanCanvas;
			const ctx = canvas.getContext('2d');

			switch (this.attempts) {
				case 1:
					// Основание
					ctx.beginPath()
					ctx.moveTo(50, 400)
					ctx.lineTo(400, 400)
					ctx.stroke()
					break
				case 2:
					// Вертикальная палка вверх
					ctx.beginPath();
					ctx.moveTo(50, 0);
					ctx.lineTo(50, 400);
					ctx.stroke();
					break
				case 3:
					// Горизонтальная линия наверху
					ctx.beginPath();
					ctx.moveTo(0, 0);
					ctx.lineTo(250, 0);
					ctx.stroke();

					// Перемычка
					ctx.beginPath();
					ctx.moveTo(100, 0);
					ctx.lineTo(50, 50);
					ctx.stroke();
					break
				case 4:
					// Веревка
					ctx.beginPath();
					ctx.moveTo(250, 0);
					ctx.lineTo(250, 60);
					ctx.stroke();
					break
				case 5:
					// Голова
					ctx.beginPath();
					ctx.arc(250, 90, 30, 0, Math.PI * 2);
					ctx.stroke();
					break
				case 6:
					// Тело
					ctx.beginPath();
					ctx.moveTo(250, 120);
					ctx.lineTo(250, 250);
					ctx.stroke();
					break
				case 7:
					// Рука 1
					ctx.beginPath();
					ctx.moveTo(250, 140);
					ctx.lineTo(220, 200);
					ctx.stroke();
					break
				case 8:
					// Рука 2
					ctx.beginPath();
					ctx.moveTo(250, 140);
					ctx.lineTo(280, 200);
					ctx.stroke();
					break
				case 9:
					// Нога 1
					ctx.beginPath();
					ctx.moveTo(250, 250);
					ctx.lineTo(220, 310);
					ctx.stroke();
					break
				case 10:
					// Нога 2
					ctx.beginPath();
					ctx.moveTo(250, 250);
					ctx.lineTo(280, 310);
					ctx.stroke();

					//  Глаз 1
					ctx.beginPath();
					ctx.moveTo(235, 80);
					ctx.lineTo(245, 90);
					ctx.moveTo(235, 90);
					ctx.lineTo(245, 80);
					ctx.stroke();

					// Глаз 2
					ctx.beginPath();
					ctx.moveTo(255, 80);
					ctx.lineTo(265, 90);
					ctx.moveTo(255, 90);
					ctx.lineTo(265, 80);
					ctx.stroke();
					break
			}
		}
	}
}
</script>

<style lang="scss" scoped>
.game {
	&__finish {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		display: flex;
		align-items: center;
		justify-content: center;
		background: rgba(0, 0, 0, .1);
		backdrop-filter: blur(4px);
		z-index: 1;

		&-content {
			width: 500px;
			height: 200px;
			display: flex;
			align-items: center;
			justify-content: center;
			background: #fff;
			font-size: 25px;
			border-radius: 10px;
			box-shadow: 0 0 15px 0 rgba(0,0,0,0.1);
		}

		&-btn {
			background: #fff;
			border: 1px solid #2c3e50;
			margin-top: 20px;
			border-radius: 10px;
			font-size: 18px;
			padding: 12px 24px;
			transition: .2s ease;
			cursor: pointer;

			&:hover {
				background: #2c3e50;
				color: #fff;
			}
		}
	}

	&__container {
		margin: 0 auto;
		max-width: 1000px;
		padding: 50px;
		box-shadow: 0 0 15px -3px rgba(0,0,0,0.1);
	}

	&__header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		border: 1px solid #5e5e5e;
		padding: 20px;
		border-radius: 20px;
	}

	&__theme {
		font-size: 27px;
	}

	&__timer {
		border-radius: 15px;
		font-size: 35px;
		width: 255px;
		height: 44px;
		display: flex;
		align-items: center;
		justify-content: center;

		&_warning {
			color: #be2b2b;
		}
	}

	&__clock {
		width: 50px;
		height: 50px;
		display: block;
		margin-right: 10px;
	}

	&__content {
		display: flex;
		align-items: flex-start;
		margin-top: 80px;
	}

	&__main {
		position: relative;
	}

	&__gallows {
		width: 300px;
		padding-left: 50px;
		flex-shrink: 0;
	}

	&__letters {
		margin-top: 80px;
		display: grid;
		grid-template-columns: repeat(11, 1fr);
		grid-gap: 20px;
	}

	&__letter {
		display: flex;
		align-items: center;
		justify-content: center;
		padding: 10px;
		font-size: 25px;
		border-radius: 10px;
		cursor: pointer;
		transition: .2s ease;
		position: relative;
		user-select: none;

		&:hover {
			background: #e7e7e7;
		}

		&_exist {
			background: green;
			color: #fff;

			&:hover {
				background: green;
			}
		}

		&_absent {
			opacity: .5;

			&::before {
				content: "";
				display: block;
				width: 3px;
				height: 25px;
				position: absolute;
				background: red;
				top: 14px;
				transform: rotate(45deg);
				left: 19px;
			}

			&::after {
				content: "";
				display: block;
				width: 3px;
				height: 25px;
				position: absolute;
				background: red;
				top: 14px;
				transform: rotate(-45deg);
				left: 19px;
			}
		}
	}

	&__word {
		display: flex;
		justify-content: center;
	}

	&__word {
		&-letter {
			margin: 0 10px;
			color: #5e5e5e;
			border-bottom: 2px solid #5e5e5e;
			max-width: 75px;
			height: 50px;
			font-size: 40px;
			display: flex;
			align-items: center;
			justify-content: center;
		}
	}
}

.fade-enter-active, .fade-leave-active {
	transition: opacity .2s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active до версии 2.1.8 */ {
	opacity: 0;
}
</style>
