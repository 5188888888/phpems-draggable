<script>
  let answer = '{x2;$question[questionanswer]}';

  let dragObject = new DragObject;
  dragObject.data = reactive((answer.length > 0) ? JSON.parse(answer) : {
    from: [],
    to: []
  });
  let eM = new EventManager(dragObject);
  let question = new QuestionManager(dragObject, "{x2;$question[questionid]}");
  

  createApp({
    components: {
      'draggable': window.vuedraggable,
      'eM': eM,
      'question': question
    },
    data() {
      return {
        data: dragObject.data,
        eM: eM,
        question: question
      }
    }
  }).mount('#app')
</script>



<div id="app">
  <div class="card">
    <div class="card-header bg-owo-blue text-light"><span class="card-title">拖放题模型</span></div>
    <div class="card-body">
      <div class="text-area">
        <ul>
          <draggable :list="data.to" animation="300" item-key="id" group="dataType" :sort="false" filter=".list">
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
        :group="{ name: 'dataType', pull: 'clone', put: false }" @start="eM.onStart($event)" @move="eM.onMove($event)" @end="eM.onEnd($event)"
        :sort="false" ghost-class="ghost" chosen-class="chosenClass">
        <template #item="{ element }">
          <div class="item">{{ element.name }}</div>
        </template>
      </draggable>
      标签ID从左往右、从上到下依次递增. 起始ID为 '0'.
      <div class="submit-area">
        <button type="button" class="btn btn-primary" @click="question.addOption($event)">添加选项</button>
        <button type="button" class="btn btn-danger" @click="question.delOption($event)">删除选项</button>
        <button type="button" class="btn btn-primary" @click="question.addOption('target')">添加放置区选项</button>
        <button type="button" class="btn btn-danger" @click="question.delOption('target')">删除放置区选项</button>
        <button type="button" class="btn btn-primary" @click="question.saveAnswer()">保存答案</button>
      </div>
      <input type="hidden" id="formData" name="targs[questionanswer7]" />
    </div>
  </div>
</div>