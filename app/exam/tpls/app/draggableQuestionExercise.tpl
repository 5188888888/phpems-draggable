<script>
    global = new Global;
    question = global.ajaxGetQuestion("{x2;$question[questionid]}");
    question = (Object.keys(question).length > 0) ? question : {
      from: [],
      to: []
    };
    // 打乱顺序
    question.from = global.getRandomArr(question.from, Object.keys(question.from).length);
  
    dragObject = new DragObject;
    dragObject.data = reactive(question);
    eM = new EventManager(dragObject);
    questionManager = new QuestionManager(dragObject, "{x2;$question[questionid]}");
    
  
    createApp({
      components: {
        'draggable': window.vuedraggable,
        'eM': eM,
        'questionManager': questionManager
      },
      data() {
        return {
          data: dragObject.data,
          eM: eM,
          questionManager: questionManager
        }
      }
    }).mount('#app')
  </script>
  
  
  
  <div id="app">
    <div class="card">
      <div class="card-header bg-owo-blue text-light"><span class="card-title">{x2;realhtml:$question['question']}</span></div>
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
        <div class="submit-area">
            <button class="btn btn-primary badge" @click="questionManager.checkAnswer({x2;$question[questionid]})">答题完毕</button>
        </div>
        <input type="hidden" id="formData" name="targs[questionanswer7]" />
      </div>
    </div>
  </div>