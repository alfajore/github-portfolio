// IMAGES ARRAY
const fillImages = (name, count = 8) => {
    let arr = [];
    for (let i = 1; i <= count; i++) {
        arr.push({ img: `images/${name}${i}.png`, type: name });
    }
    return arr;
};

const gameSets = [
    { title: "Cat or Croissant?", target: "cat", itemsA: fillImages('cat'), itemsB: fillImages('croissant') },
    { title: "Drumstick or Poodle?", target: "poodle", itemsA: fillImages('poodle'), itemsB: fillImages('drumstick') },
    { title: "Puppy or Bagel?", target: "puppy", itemsA: fillImages('puppy'), itemsB: fillImages('bagel') }
];

let tiles = [];
let selectedTiles = new Set();
let gameChecked = false;
let currentTargetName = "";

// SHUFFLES THE IMAGES THAT'LL SHOW UP
function shuffle(array) {
    return array.sort(() => Math.random() - 0.5);
}

function newGame() {
    tiles = [];
    selectedTiles = new Set();
    gameChecked = false;
    
    // PICK A RANDOM SET FROM GAMESETS
    const currentSet = gameSets[Math.floor(Math.random() * gameSets.length)];
    currentTargetName = currentSet.target;

    // SHUFFLE THE ANIMALS AND OBJECTS
    let poolA = shuffle([...currentSet.itemsA]);
    let poolB = shuffle([...currentSet.itemsB]);

    // RANDOMLY SELECT 12 OUT OF THE 16 IMAGES IN THE SET
    const targetCount = Math.floor(Math.random() * 5) + 4; 
    const otherCount = 12 - targetCount;

    let finalSelection = [];
    for(let i=0; i<targetCount; i++) finalSelection.push({...poolA[i], isTarget: true});
    for(let i=0; i<otherCount; i++) finalSelection.push({...poolB[i], isTarget: false});

    // SHUFFLE THE 12 ITEMS SELECTED
    tiles = shuffle(finalSelection);

    // RESET
    document.getElementById('game-title').textContent = currentSet.title;
    document.getElementById('instructions').innerHTML = `Select all the <strong>${currentTargetName.toUpperCase()}S</strong>!`;
    document.getElementById('selected').textContent = '0';
    document.getElementById('message').textContent = '';
    document.getElementById('message').className = 'message';
    document.getElementById('checkBtn').disabled = false;

    // CREATES THE 12 GRID
    const grid = document.getElementById('grid');
    grid.innerHTML = '';

    tiles.forEach((data, i) => {
        const tile = document.createElement('div');
        tile.className = 'tile';
        tile.dataset.index = i;

        const img = document.createElement('img');
        img.src = data.img;
        tile.appendChild(img);

        tile.onclick = () => toggleTile(i);
        grid.appendChild(tile);
    });
}

function toggleTile(index) {
    if (gameChecked) return;
    const tile = document.querySelector(`[data-index="${index}"]`);

    // if already selected, unselect it. otherwise, select it
    if (selectedTiles.has(index)) {
        selectedTiles.delete(index);
        tile.classList.remove('selected');
    } else {
        selectedTiles.add(index);
        tile.classList.add('selected');
    }

    // update the counter
    document.getElementById('selected').textContent = selectedTiles.size;
}

function checkAnswer() {
    if (gameChecked || selectedTiles.size === 0) return;

    gameChecked = true;
    document.getElementById('checkBtn').disabled = true;

    let correctCount = 0;
    let totalTargets = tiles.filter(t => t.isTarget).length;

    tiles.forEach((tile, index) => {
        const tileEl = document.querySelector(`[data-index="${index}"]`);
        tileEl.classList.add('revealed');
        
        // put green check on correct selections, and red x on wrong selections
        if (tile.isTarget) {
            tileEl.classList.add('correct');
            addMark(tileEl, '✓', true); // Green mark
            if (selectedTiles.has(index)) correctCount++;
        } else if (selectedTiles.has(index)) {
            tileEl.classList.add('incorrect');
            addMark(tileEl, '✗', false); // Red mark
        }
    });

    // show win or lose message
    if (correctCount === totalTargets && selectedTiles.size === totalTargets) {
        showMessage(`Nice! You found all ${totalTargets}!`, true);
    } else {
        showMessage(`Oops! You only found ${correctCount} out of ${totalTargets}.`, false);
    }
}

function addMark(el, symbol, isCorrect) {
    const mark = document.createElement('span');
    mark.className = 'checkmark ' + (isCorrect ? 'mark-green' : 'mark-red');
    mark.textContent = symbol;
    el.appendChild(mark);
}

function showMessage(text, isCorrect) {
    const msg = document.getElementById('message');
    msg.textContent = text;
    msg.className = 'message ' + (isCorrect ? 'correct-msg' : 'incorrect-msg');
}

// start the game when page loads
newGame();