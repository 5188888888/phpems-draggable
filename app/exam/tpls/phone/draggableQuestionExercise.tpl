<div id="app">
    <form class="nopadding desc">
        <div class="card">
            <div class="card-header bg-owo-blue text-light"><span class="card-title">{x2;realhtml:$question['question']}</span></div>
            <div class="card-body">
                <div class="text-area">
                    <ul>
                        <draggable :list="data.to" animation="300" item-key="id" group="dataType" :sort="false"
                            filter=".list">
                            <template #item="{ element }">
                                <li class="list">
                                    <span>{{ element.description }}</span>
                                    <div :id="element.id" class="gap">{{ element.value ?? '' }}</div>
                                </li>
                            </template>
                        </draggable>
                    </ul>
                </div>
                <draggable class="drag-area" :list="data.from" animation="300" item-key="id"
                    :group="{ name: 'dataType', pull: 'clone', put: false }" @start="onStart" @move="onMove" @end="onEnd"
                    :sort="false" ghost-class="ghost" chosen-class="chosenClass">
                    <template #item="{ element }">
                        <div class="item">{{ element.name }}</div>
                    </template>
                </draggable>
                <div class="submit-area">
                    <button class="btn btn-primary badge" @click="checkAnswer({x2;$question[questionid]})">答题完毕</button>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
    question = '{x2;$question[questionanswer]}';
    question = (question.length > 0) ? JSON.parse(question) : {
        from: [],
        to: []
    };
    question.to.forEach((v, k) => {
        question.to[k].value = null
    });
    // 打乱顺序
    question.from = global.getRandomArr(question.from, Object.keys(question.from).length);
    // 更新数据
    dragObject.data = reactive(question);
  
    createApp({
        components: {
            'draggable': window.vuedraggable,
        },
        data() {
            return {
                data: dragObject.data
            }
        },
        methods: {
            onStart: dmethods.onStart,
            onMove: dmethods.onMove,
            onEnd: dmethods.onEnd,
            checkAnswer: dmethods.checkAnswer
        }
    }).mount('#app')
  </script>