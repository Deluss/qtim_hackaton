<template>
	<div class="game">
		<div class="game__container">
			<div class="game__header">
				<div class="game__theme">
					Тема: Животное
				</div>
				<div class="game__timer">
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
								{{ finishMessage }}
							</div>
						</div>
					</transition>
					<div class="game__word">
						<div
							v-for="(wordLetter, index) in searchWord"
							:key="`wordletter-${index}`"
							class="game__word-letter"
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
					<canvas id="hangmanCanvas" width="400" height="400" ref="hangmanCanvas" />
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
			attempts: 0,
			timer: 300,
			wordLength: 5,
			alphabet: ['а', 'б', 'в', 'г', 'д', 'е', 'ё', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я'],
			lettersList: [],
			intervalId: null,
			searchWord: [],
			showFinish: false,
			finishMessage: '',
			audio: new Audio(require('@/assets/pencil.mp3'))
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
		}
	},
	mounted () {
		this.lettersList = this.createLettersList()
		this.runTimer()
		for (let i = 0; i < this.wordLength; i++) {
			this.searchWord.push('')
		}
		console.log('this.searchWord', this.searchWord)
	},
	methods: {
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
			this.intervalId = setInterval(() => {
				this.timer -= 1
				if (this.timer === 0) {
					clearInterval(this.intervalId)
					this.intervalId = null
					this.finishMessage = 'Время вышло лошара'
					this.showFinish = true
				}
			}, 1000)
		},
		checkLetter (item) {
			if (item.letter === 'к') {
				item.state = 'exist'
				item.position = [0, 3]
			} else if (item.letter === 'о') {
				item.state = 'exist'
				item.position = [1]
			} else if (item.letter === 'ш') {
				item.state = 'exist'
				item.position = [2]
			} else if (item.letter === 'а') {
				item.state = 'exist'
				item.position = [4]
			} else {
				item.state = 'absent'
				item.position = []
				this.attempts += 1
				this.playSound()
				this.drawHangman()
				if (this.attempts === 10) {
					this.finishMessage = 'Вы проиграли'
					this.showFinish = true
					clearInterval(this.intervalId)
					this.intervalId = null
				}
			}
			this.setPosition(item)
		},
		setPosition (item) {
			if (item.position.length) {
				item.position.map(position => {
					this.searchWord[position] = item.letter
				})
			}
		},
		playSound () {
			this.audio.playbackRate = 1.3
			this.audio.play()
		},
		drawHangman() {
			const canvas = this.$refs.hangmanCanvas;
			const ctx = canvas.getContext('2d');

			ctx.clearRect(0, 0, canvas.width, canvas.height);

			if (this.attempts >= 1) {
				ctx.beginPath();
				ctx.moveTo(50, 400);
				ctx.lineTo(400, 400);
				ctx.stroke();
			}

			if (this.attempts >= 2) {
				// Вертикальная палка вверх (вертикальная линия)
				ctx.beginPath();
				ctx.moveTo(50, 0);
				ctx.lineTo(50, 400);
				ctx.stroke();
			}

			if (this.attempts >= 3) {
				// Горизонтальная линия (палка для виселицы)
				ctx.beginPath();
				ctx.moveTo(0, 0);
				ctx.lineTo(250, 0);
				ctx.stroke();

				// Перемычка
				ctx.beginPath();
				ctx.moveTo(100, 0);
				ctx.lineTo(50, 50);
				ctx.stroke();
			}

			if (this.attempts >= 4) {
				// Веревка
				ctx.beginPath();
				ctx.moveTo(250, 0);
				ctx.lineTo(250, 60);
				ctx.stroke();
			}

			if (this.attempts >= 5) {
				// Голова (круг)
				ctx.beginPath();
				ctx.arc(250, 90, 30, 0, Math.PI * 2);
				ctx.stroke();
			}

			if (this.attempts >= 6) {
				// Тело
				ctx.beginPath();
				ctx.moveTo(250, 120);
				ctx.lineTo(250, 250);
				ctx.stroke();
			}

			if (this.attempts >= 7) {
				// Рука 1
				ctx.beginPath();
				ctx.moveTo(250, 140);
				ctx.lineTo(220, 200);
				ctx.stroke();
			}

			if (this.attempts >= 8) {
				// Рука 2
				ctx.beginPath();
				ctx.moveTo(250, 140);
				ctx.lineTo(280, 200);
				ctx.stroke();
			}

			if (this.attempts >= 9) {
				// Нога 1
				ctx.beginPath();
				ctx.moveTo(250, 250);
				ctx.lineTo(220, 310);
				ctx.stroke();
			}

			if (this.attempts >= 10) {
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
			}
		}
	}
}
</script>

<style lang="scss" scoped>
.game {
	font-family: 'Roboto', sans-serif;
	padding-left: 25%;

	&__finish {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		display: flex;
		align-items: center;
		justify-content: center;
		background: #fff;
		z-index: 1;

		&-content {
			width: 500px;
			height: 200px;
			display: flex;
			align-items: center;
			justify-content: center;
			background: lightgray;
			font-size: 25px;
			border-radius: 5px;
		}
	}

	&__container {
		margin: 0 auto;
		max-width: 1000px;
		padding: 50px 0;
	}

	&__header {
		display: flex;
		justify-content: space-between;
	}

	&__theme {
		font-size: 27px;
	}

	&__timer {
		border-radius: 15px;
		background: #D9D9D9;
		font-size: 35px;
		width: 255px;
		height: 44px;
		display: flex;
		align-items: center;
		justify-content: center;
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
			border-bottom: 2px solid #000;
			width: 75px;
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
