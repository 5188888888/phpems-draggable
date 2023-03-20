<script>
    question = global.getQuestion(currentId);
    question = ((question.from.length > 0) && (question.to.length > 0)) ? question : {
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
            onChange: (e) => {
                console.log('hello world')
            }
        }
    }).mount('#app' + currentId)
  </script>