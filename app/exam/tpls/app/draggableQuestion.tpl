<script>
  let answer = '{x2;$question[questionanswer]}';
  // 更新数据
  dragObject.data = reactive((answer.length > 0) ? JSON.parse(answer) : {
    from: [],
    to: []
  });

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
      saveAnswer() {
        // 从PHP模板引擎取回问题ID
        let questionId = "{x2;$question['questionid']}";
        let answer = JSON.stringify(dragObject.data);
        document.querySelector('#formData').value = answer;
        $.post(dmethods.GetUrlRelativePath() + '?exam-master-questions-draggableQuestion&questionid=' + questionId, { data: answer, type: 'add' }, (data, status) => {
          if (data === 'ok') {
            Swal.fire({
              title: '成功!',
              icon: 'success'
            })
          } else {
            Swal.fire({
              title: '[Dx0012] 系统错误! 请联系站点管理员排除问题!',
              icon: 'error'
            })
          }
        })
      },
      onStart: dmethods.onStart,
      onMove: dmethods.onMove,
      onEnd: dmethods.onEnd,
      async addOption(type) {
        let name = (type !== 'target') ? '' : '放置区';
        const { value: value } = await Swal.fire({
          title: `新增${name}选项`,
          input: 'text',
          showCancelButton: true,
          inputValidator: (value) => {
            if (!value) {
              return '参数不能为空!'
            }
          }
        })

        if (value) {
          if (type === 'target') {
            dragObject.data.to.push({
              id: Object.keys(dragObject.data.to).length,
              description: value
            })
          } else {
            dragObject.data.from.push({
              id: Object.keys(dragObject.data.from).length,
              name: value
            })
          }
          this.saveAnswer();
        }
      },
      async delOption(type) {
        let name = (type !== 'target') ? '' : '放置区';
        const { value: value } = await Swal.fire({
          title: `请输入删除${name}选项ID:`,
          icon: 'warning',
          input: 'text',
          showCancelButton: true,
          inputValidator: (value) => {
            if (!value) {
              return '参数不能为空!'
            }
          }
        })

        if (value) {
          dragObject.data[(type === 'target') ? 'to' : 'from'].splice(value, 1);
          this.saveAnswer();
        }
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
                <span>ID: {{ element.id }} {{ element.description }}</span>
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
      标签ID从左往右依次递增. 起始ID为 '0'.
      <div class="submit-area">
        <button type="button" class="btn btn-primary" @click="addOption">添加选项</button>
        <button type="button" class="btn btn-danger" @click="delOption">删除选项</button>
        <button type="button" class="btn btn-primary" @click="addOption('target')">添加放置区选项</button>
        <button type="button" class="btn btn-danger" @click="delOption('target')">删除放置区选项</button>
        <button type="button" class="btn btn-primary" @click="saveAnswer">保存答案</button>
      </div>
      <input type="hidden" id="formData" name="targs[questionanswer7]" />
    </div>
  </div>
</div>