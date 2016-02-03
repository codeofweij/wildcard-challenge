calculator = ()->

	factorial = [0, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800, 479001600]

	P = (N,M)->

		if N<M
			return 0
		if N==M
			return factorial[N]
		return factorial[N] / factorial[(N-M)]

	calc: (numCards, input) ->
		slotsAvail = input.split("*").length - 1
		return P(slotsAvail, numCards)

main = (Calculator, $http)->

	vm = this

	vm.sourceFile = "http://dmr5j7qv7f30s.cloudfront.net/problem1input.txt?key=f768a18881f272bc3bcab4ea94c03604"

	vm.solveProb1 = ()->

		vm.numCards = 5
		# simple xmlHttpRequest to get the data
		$http
	  		method: 'GET'
	  		url: vm.sourceFile
		.then (response) ->
			vm.inputData = response.data

			rows = vm.inputData.split('\n')
			cols = []

			# matrix transform
			index = 0
			for char in vm.inputData
				if char == '\n'
					index = 0
				else
					if !cols[index]
						cols[index] = ""
					cols[index]+= char
					index++

			# now go get permuatations
			count = 0
			for r in rows
				count+= Calculator.calc( vm.numCards, r )

			for c in cols
				count+= Calculator.calc( vm.numCards, c )

			vm.count = count
			return
		return


	vm.prob2 =
		numOfCandidateCards: 1
		budget: 2912
		debug: false

	vm.solveProb2 = ()->

		calc = (totalCards)->

			vm.prob2.debugOut = []

			Generation = [9, 10, 21, 20, 7, 11, 4, 15, 7, 7, 14, 5, 20, 6, 29, 8, 11, 19, 18, 22, 29, 14, 27, 17, 6, 22, 12, 18, 18, 30]
			Overhead =   [21, 16, 19, 26, 26, 7, 1, 8, 17, 14, 15, 25, 20, 3, 24, 5, 28, 9, 2, 14, 9, 25, 15, 13, 15, 9, 6, 20, 27, 22]
			cost = 0
			for i in [0..totalCards-1]
				cardsLeft = totalCards-1-i
				cost+= Generation[i]
				cost+= Overhead[i]*(cardsLeft)

				vm.prob2.debugOut[i] =
					card: i
					generation: Generation[i]
					overhead: Overhead[i]
					overheadMultiplier: cardsLeft
					cost: Generation[i] + Overhead[i]*(cardsLeft)
					totalCost: cost

			return cost

		vm.prob2.totalCost = calc( vm.prob2.numOfCandidateCards )
		return

	vm.solveProb2()

	return

angular.module('wildcard', [])
	.service 'Calculator', calculator
	.controller 'MainCtrl', main


