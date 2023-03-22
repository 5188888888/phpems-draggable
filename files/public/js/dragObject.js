// 从Vue.js提取需要的方法 -By HanskiJay
const { createApp, reactive } = Vue
const { vuedraggable } = Sortable

const examObjList = {};

/**
 * ~ 定义全局助手对象
 */
class Global {
  constructor() {
    this.basicQueryUrl = '?exam-app-customQueryApiByJ-query';
    this.questionQueryUrl = `${this.basicQueryUrl}&questionid=`;
    this.isMobile = document.body.clientWidth <= 500;
  }

  highlight(id, backgroundColor = '#eee', color = 'black') {
    const el = document.getElementById(id);
    if (el) {
      el.style.backgroundColor = backgroundColor;
      el.style.color = color;
    }
  }

  getUrlRelativePath() {
    const url = document.location.toString();
    let relUrl = new URL(url).pathname;
    if (relUrl.includes('?')) {
      relUrl = relUrl.split('?')[0];
    }
    return relUrl;
  }

  getRandomArr(arr, num) {
    let _arr = arr.concat();
    let n = _arr.length;
    let result = [];

    while (n-- && num--) {
      let index = Math.floor(Math.random() * n);
      [_arr[index], _arr[n]] = [_arr[n], _arr[index]];
      result.push(_arr[n]);
    }
    return result;
  }

  show(title, text = '', icon = 'warning') {
    if (typeof title !== 'string') {
      alert('参数不完整! 至少需要 [title] !');
      return false;
    }
    if (!this.isMobile) {
      Swal.fire({
        title,
        text,
        icon
      });
    } else {
      alert(title + '\n' + text);
    }
  }

  async submit(url, objData, callback) {
    try {
      const response = await fetch(this.getUrlRelativePath() + url, {
        method: 'POST',
        body: JSON.stringify(objData),
        headers: {
          'Content-Type': 'application/json'
        }
      });
      const data = await response.text();
      return callback(/\{(.*)\}/i.test(data) ? JSON.parse(data) : { message: 'Unknown Error', status: false });
    } catch (error) {
      console.error('提交数据时发生错误:', error);
      return null;
    }
  }

  async getQuestion(id) {
    const data = await this.submit(
      this.questionQueryUrl + id,
      { data: ':null', type: 'onlyQuestion' },
      (data) => {
        return data.message === 'success' ? data.question : {};
      }
    );
    return data;
  }
  
  ajaxSubmit(url, objData, callback) {
    let result;
    $.ajax({
      type: 'POST',
      url: this.getUrlRelativePath() + url,
      async: false,
      data: objData,
      success: (data) => { result = callback(data) }
    });
    return result;
  }

  ajaxGetQuestion(id) {
    return this.ajaxSubmit(global.questionQueryUrl + id, { data: 'null', type: 'onlyQuestion' }, (data) => {
      data = JSON.parse(data);
      return (data.message === 'success') ? data.question : {};
    });
  }
}

/**
 * ~ 定义拖拽对象
 */
class DragObject {
  constructor() {
    this.isDragging = false;
    this.data = {};
    this.target = null;
    this.items = {
      width: 0,
      nodeList: [],
    };
  }

  getWidth(text) {
    if (typeof text === 'number') {
      this.items.width = text;
    } else {
      this.items.nodeList.forEach(node => {
        if (node.name === text) {
          this.items.width = node.width;
          return;
        }
      });
      this.items.width = this.items.width === 0 ? 50 : this.items.width;
    }
    return `${this.items.width}px`;
  }

  setNodeList(nodeList) {
    this.items.nodeList = new Array(nodeList.length);
    nodeList.forEach((node, key) => {
      this.items.nodeList[key] = {
        name: node.innerText,
        width: node.clientWidth
      };
    }, nodeList);
  }

  getValue(id) {
    if (!Object.keys(this.data).length) {
      console.error('未定义的数据 [this.data] !');
      return;
    }
    return this.data.to[id]?.value || '';
  }

  removeTargetStyle(clearText = false) {
    if (!(this.target instanceof HTMLElement)) {
      return;
    }
    this.target.classList.remove('target');
    const value = this.getValue(this.target.getAttribute('id'));
    if (value === null) {
      this.target.style.width = this.getWidth(50);
      if (clearText) {
        this.target.innerText = '';
      }
    } else {
      this.target.innerText = value;
    }
  }

  reset() {
    this.target = null;
    this.items.nodeList = [];
    this.isDragging = false;
  }
}

// 事件管理对象
class EventManager {
  constructor(dragObject) {
    this.dragObject = dragObject;
    this.global = new Global;
  }

  // 拖拽事件开始时触发
  onStart() {
    // 设置开始拖拽
    this.dragObject.isDragging = true;
    // 获取真实标签DOM
    this.dragObject.setNodeList(document.querySelectorAll('.item'));
  }

  onMove(e) {
    if (!this.dragObject.isDragging) {
      return false;
    }

    const currentRelated = e.related;
    const currentPutTarget = currentRelated.lastChild;
    const target = this.dragObject.target;

    if (typeof target !== 'object') {
      this.dragObject.target = currentPutTarget;
    }

    // 获取拖拽标签的显示内容
    const draggedText = e.dragged.innerText;
    // 更新当前子对象的显示内容和宽度
    currentPutTarget.innerText = draggedText;
    currentPutTarget.style.width = this.dragObject.getWidth(draggedText);
    currentPutTarget.style.backgroundColor = '#eee';
    currentPutTarget.style.color = '#000';

    // 添加选中样式
    currentPutTarget.classList.add('target');
    if (currentPutTarget !== target) {
      this.dragObject.removeTargetStyle();
    }

    // 更新拖拽目标对象
    const value = this.dragObject.getValue(currentPutTarget.getAttribute('id')) ?? '';
    currentPutTarget.style.width = this.dragObject.getWidth(value);
    this.dragObject.target = currentPutTarget;
  }

  // 拖拽事件结束触发
  onEnd(e, id) {
    if (e.from === e.to) {
      this.dragObject.removeTargetStyle(true);
      this.dragObject.reset();
      return false;
    }

    this.dragObject.data.to.splice(e.newIndex, 1);

    // 取回当前拖拽对象放置目标与其ID
    let target = this.dragObject.target;

    target.style.width = this.dragObject.getWidth(e.item.innerText);
    this.dragObject.data.to[target.getAttribute('id')]['value'] = e.item.innerText;
    target.innerText = e.item.innerText;
    target.classList.remove('target');

    this.dragObject.reset();
    if (examMode) {
      let input = document.getElementById(`draggableQuestion${id}`);
      let data = examObjList[id].data.to;
      input.value = JSON.stringify(data);
    }
  }
}

class QuestionManager {
  constructor(dragObject, questionId) {
    this.dragObject = dragObject;
    this.questionId = questionId;
    this.global = new Global;
  }

  checkAnswer() {
    if (!this.dragObject.data.to.every(option => option.value !== undefined)) {
      this.global.show('未完成做题', '请检查题目是否还有未完成的选项!', 'error');
      return;
    }

    // 提交确认模态框数据
    const confirmOptions = {
      title: '确定要提交吗?',
      text: '提交做题后不可更改!',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    };

    // 确认提交数据方法
    const confirmSubmit = async () => {
      let tmp = { title: '', icon: '' };
      this.global.submit(this.global.questionQueryUrl + this.questionId, { data: this.dragObject.data.to, type: 'verify' },
        (data) => {
          if (data.status) {
            for (const [k, v] of Object.entries(data.message)) {
              this.global.highlight(k, !v ? 'red' : 'green', 'white');
            }
          }

          switch (data.correct) {
            case 'wrong':
              tmp.title = '答案有误! 请仔细检查!';
              tmp.icon = 'error';
              break;
            case 'success':
              tmp.title = '恭喜, 回答正确!';
              tmp.icon = 'success';
              break;
            default:
              tmp.title = '[Dx0001] 未知错误! 请联系站点管理员检查该问题.';
              tmp.icon = 'error';
              break;
          }
          this.global.show(tmp.title, tmp?.text || '', tmp.icon);
        });
    };

    if (!this.global.isMobile) {
      Swal.fire(confirmOptions).then(result => {
        if (result.isConfirmed) {
          const answers = this.dragObject.data.to.map(option => `<br/>${option.description}: ${option.value}`).join('');
          Swal.fire('答案显示', '你的答案: ' + answers, 'success').then(() => { confirmSubmit() });
        }
      });
    } else {
      if (confirm('确定要提交吗?', '提交做题后不可更改!')) {
        confirmSubmit();
      }
    }
  }

  saveAnswer() {
    const answer = JSON.stringify(this.dragObject.data);
    document.querySelector('#formData').value = answer;

    if (!this.questionId) {
      this.global.show('Error!', '[Dx0002] 系统错误! 请联系站点管理员排除问题!', 'error');
      return;
    }

    const url = this.global.getUrlRelativePath() + this.global.questionQueryUrl + this.questionId;
    const data = { data: answer, type: 'modify' };

    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    })
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          throw new Error('[Dx0003] 系统错误! 请联系站点管理员排除问题!');
        }
      })
      .then(json => {
        if (json.message === 'success') {
          this.global.show('成功!', '', 'success');
        } else {
          throw new Error('[Dx0004] 系统错误! 请联系站点管理员排除问题!');
        }
      })
      .catch(error => {
        this.global.show(error.message, '', 'error');
      });
  }

  async addOption(type) {
    const name = (type !== 'target') ? '' : '放置区';
    try {
      const { value: value } = await Swal.fire({
        title: `新增${name}选项`,
        input: 'text',
        showCancelButton: true,
        inputValidator: (value) => {
          if (!value) {
            throw new Error('参数不能为空!');
          }
        }
      });

      if (!value) return;

      if (type === 'target') {
        this.dragObject.data.to.push({
          id: Object.keys(this.dragObject.data.from).length,
          description: value
        });
      } else {
        this.dragObject.data.from.push({
          id: Object.keys(this.dragObject.data.to).length,
          name: value
        });
      }
      this.saveAnswer();
    } catch (error) {
      console.error(error);
    }
  }

  async delOption(type) {
    const name = (type !== 'target') ? '' : '放置区';
    try {
      const { value: value } = await Swal.fire({
        title: `请输入删除${name}选项ID:`,
        icon: 'warning',
        input: 'text',
        showCancelButton: true,
        inputValidator: (value) => {
          if (!value) {
            throw new Error('参数不能为空!');
          }
        }
      });

      if (!value) return;

      const dataKey = (type === 'target') ? 'to' : 'from';
      const index = parseInt(value, 10);
      this.dragObject.data[dataKey].splice(index, 1);
      this.saveAnswer();
    } catch (error) {
      console.error(error);
    }
  }
}