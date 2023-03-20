// 从Vue.js提取需要的方法 -By HanskiJay
const { createApp, reactive } = Vue
const { vuedraggable } = Sortable

const global = {
  basicQueryUrl: '?exam-app-customQueryApiByJ-query',
  questionQueryUrl: '?exam-app-customQueryApiByJ-query&questionid=',
  isMobile: (document.body.clientWidth <= 500),
  highlight(id, backgroundColor = '#eee', color = 'black') {
    document.getElementById(id).style.backgroundColor = backgroundColor;
    document.getElementById(id).style.color = color;
  },
  GetUrlRelativePath() {
    let url = document.location.toString();
    let arrUrl = url.split('//');

    let start = arrUrl[1].indexOf('/');
    let relUrl = arrUrl[1].substring(start); //stop省略, 截取从start开始到结尾的所有字符

    if (relUrl.indexOf('?') != -1) {
      relUrl = relUrl.split('?')[0];
    }
    return relUrl;
  },
  getRandomArr(arr, num) {
    let _arr = arr.concat();
    let n = _arr.length;
    let result = [];

    // 先打乱数组
    while (n-- && num--) {
      let index = Math.floor(Math.random() * n); // 随机位置
      [_arr[index], _arr[n]] = [_arr[n], _arr[index]]; // 交换数据
      result.push(_arr[n]); // 取出当前最后的值，即刚才交换过来的值
    }
    return result;
  },
  show(obj) {
    if ((typeof obj !== 'object') || !Object.hasOwn(obj, 'title')) {
      alert('参数不完整! 至少需要 [title] !');
      return false;
    }
    if (!global.isMobile) {
      Swal.fire({
        title: obj.title,
        text: obj.text ?? '',
        icon: obj.icon ?? 'warning'
      })
    } else {
      alert(obj.title + "\n" + (obj.text ?? ''));
    }
  },
  submit(url, objData, callback) {
    let result;
    $.ajax({
      type: 'POST',
      url: global.GetUrlRelativePath() + url,
      async: false,
      data: objData,
      success: (data) => { result = callback(data) }
    });
    return result;
  },
  getQuestion(id) {
    return global.submit(global.questionQueryUrl + id, { data: 'null', type: 'onlyQuestion' }, (data) => {
      data = JSON.parse(data);
      return (data.message === 'success') ? data.question : {};
    });
  }
};

// 拖动组件
const dragObject = {
  state: false,
  data: {},
  target: '',
  items: {
    _width: 0,
    nodeList: [],
    width(text) {
      if ((typeof text) === 'number') {
        this._width = text;
      } else {
        this.nodeList.forEach((v) => {
          if (v.name === text) {
            this._width = v.width;
            return;
          }
        });
        this._width = (this._width === 0) ? 50 : this._width;
      }
      return (this._width) + 'px';
    },
    setNodeList(nodeList) {
      this.nodeList = new Array(nodeList.length);
      nodeList.forEach((v, k) => {
        this.nodeList[k] = { name: v.innerText, width: v.clientWidth };
      });
    }
  },
  getValue(id) {
    if (Object.keys(this.data).length === 0) {
      console.error('未定义的数据 [this.data] !');
      return;
    }
    return this.data.to[id]['value'] ?? '';
  },
  removeTargetStyle(clearText = false) {
    if ((typeof this.target) !== 'object') {
      return;
    }
    this.target.classList.remove('target');
    // 判断是否存在有效值
    let value = this.getValue(this.target.getAttribute('id'));
    if (value === null) {
      this.target.style.width = this.items.width(50);
      if (clearText) {
        this.target.innerText = '';
      }
    } else {
      this.target.innerText = value;
    }
  },
  reset() {
    this.target = '';
    this.itemWidth = null;
    this.items.nodeList = null;
    this.state = false;
  }
};


const dmethods = {
  // 拖拽事件开始时触发
  onStart() {
    // 设置开始拖拽
    dragObject.state = true;
    // 获取真实标签DOM
    dragObject.items.setNodeList(document.querySelectorAll('.item'));
  },

  // 拖拽事件移动时触发
  onMove(e) {
    if (!dragObject.state) {
      return false;
    }

    // 当前关联对象
    let currentRelated = e.related;
    let currentPutTarget = currentRelated.lastChild;
    let target = dragObject.target;

    // 当不存在拖拽目标对象时, 保存当前关联对象的子对象到拖拽目标对象
    if ((typeof target) !== 'object') {
      dragObject.target = currentPutTarget;
    }

    // 若存在值, 则写入到拖拽目标对象的显示内容
    currentPutTarget.innerText = dragObject.getValue(currentPutTarget.getAttribute('id')) ?? '';
    // 设置当前子对象的显示内容为拖拽标签的显示内容
    currentPutTarget.innerText = e.dragged.innerText;
    // 设置当前子对象的宽度为拖拽标签的宽度
    currentPutTarget.style.width = dragObject.items.width(e.dragged.innerText);
    currentPutTarget.style.backgroundColor = '#eee';
    currentPutTarget.style.color = '#000';

    // 设置选中样式
    currentPutTarget.classList.add('target');
    // 判断当前对象是否等于拖拽目标对象
    if (currentPutTarget !== target) {
      dragObject.removeTargetStyle();
    }
    // 设置拖拽目标宽度
    let value = dragObject.getValue(currentPutTarget.getAttribute('id'));
    if (value) {
      currentPutTarget.style.width = dragObject.items.width(value);
    }
    // 更新拖拽目标对象
    dragObject.target = currentPutTarget;
  },

  // 拖拽事件结束触发
  onEnd(e) {
    // 判断当前拖拽区域是否与目标区域相同
    if (e.from === e.to) {
      dragObject.removeTargetStyle(true);
      dragObject.reset();
      return false;
    }

    // 取回当前拖拽对象ID并删除对象
    let { newIndex } = e;
    dragObject.data.to.splice(newIndex, 1);

    // 取回当前拖拽对象放置目标与其ID
    let target = dragObject.target;
    let lastId = target.getAttribute('id');
    // 设置放置目标的宽度与显示文本
    target.style.width = dragObject.items.width(target.innerText);
    dragObject.data.to[lastId]['value'] = e.item.innerText;
    target.innerText = e.item.innerText;
    target.classList.remove('target');
    // 重置放置目标
    dragObject.reset();
  },

  checkAnswer(questionId) {
    let answer = '<br/>';
    let checked = false;
    let tmp = { title: '', icon: '' };

    dragObject.data.to.forEach((option) => {
      if ((option.value === undefined) || (option.value === null)) {
        tmp.title = '未完成做题!';
        tmp.text = '请检查题目是否还有未完成的选项!';
        tmp.icon = 'error';
        global.show(tmp)
        checked = false;
      } else {
        answer += option.description + ': ' + option.value + '<br/>';
        checked = true;
      }
      if (!checked) {
        return false;
      }
    });

    // 提交前拦截: 检查选项是否完整
    if (!checked) {
      return;
    }

    let confirmSubmit = () => {
      tmp.text = '';
      global.submit(global.questionQueryUrl + questionId, { data: dragObject.data.to, type: 'verify' }, (data) => {
        data = JSON.parse(data);
        data.message.forEach((v, k) => {
          global.highlight(k, !v ? 'red' : 'green', 'white');
        });
        let toAlert = false;
        switch (data.correct) {
          case 'wrong':
            tmp.title = '答案有误! 请仔细检查!';
            tmp.icon = 'error';
            toAlert = true;
            break;

          case 'success':
            tmp.title = '恭喜, 回答正确!';
            tmp.icon = 'success';
            toAlert = true;
            break;

          default:
            tmp.title = '[Dx0002] 未知错误! 请联系站点管理员检查该问题.';
            tmp.icon = 'error';
            toAlert = true;
            break;
        }

        if (toAlert) {
          global.show(tmp)
          return;
        }
      });
    };

    tmp.title = '确定要提交吗?';
    tmp.text = '提交做题后不可更改!';
    if (!global.isMobile) {
      Swal.fire({
        title: tmp.title,
        text: tmp.text,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      }).then((result) => {
        if (result.isConfirmed) {
          confirmSubmit();
        }
      });
    } else {
      if (confirm(tmp.title + "\n" + tmp.text)) {
        confirmSubmit();
      }
    }
  }
}