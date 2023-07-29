<template>
	<div class="welcome-page">
		<div class="welcome-page__content">
			<img class="welcome-page__image" src="@/assets/hangman.jpeg" alt="hangman">
			<div class="welcome-page__main">
				<h1>
					Старая добрая игра "Виселица"
				</h1>
				<div class="welcome-page__text">
					Игра создана в рамках корпоративного хакатона компании <a class="welcome-page__link" href="https://qtim.pro" target="_blank">QTIM</a> лучшей командой на свете:
				</div>
				<div class="welcome-page__members">
			<span
				v-for="(member, index) in shuffleArray(team)"
				:key="`member-${member}`"
			>
				{{ member }}{{ index !== team.length -1 ? ',' : '.' }}
			</span>
				</div>
				<div class="welcome-page__footer">
					<button
						class="welcome-page__button"
						@click="goGame"
					>
						Начать играть
					</button>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
	export default {
		name: 'WelcomePage',
		data () {
			return {
				team: [
					'Дрыкина Анна',
					'Вишневская Анастасия',
					'Воронцова София',
					'Любимов Никита',
					'Брикуля Тимур',
					'Кара Артем',
					'Глазков Андрей'
				]
			}
		},
		methods: {
			shuffleArray(array) {
				for (let i = array.length - 1; i > 0; i--) {
					const j = Math.floor(Math.random() * (i + 1));
					[array[i], array[j]] = [array[j], array[i]];
				}
				return array;
			},
			goGame () {
				this.$emit('update')
			}
		}
	}
</script>

<style
	lang="scss"
	scoped
>
.welcome-page {
	&__image {
		width: 300px;
	}

	&__text {
		font-size: 18px;
		text-align: center;
	}

	&__members {
		font-size: 18px;
		margin-top: 20px;
		text-align: center;
	}

	&__footer {
		margin-top: 20px;
		display: flex;
		justify-content: center;
	}

	&__button {
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

	&__link {
		color: #2c3e50;
	}
}
</style>
