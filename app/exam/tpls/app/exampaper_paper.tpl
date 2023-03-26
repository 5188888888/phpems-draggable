{x2;include:header}
<body>
<div class="container-fluid">
    <div class="row-fluid">
        <div class="pages">
            <div class="header navbar-fixed-top">
                <div class="nav">
                    <div class="col-xs-9">
                        <ul class="list-unstyled list-inline">
                            <li>
                                <h3 class="logo">{x2;$sessionvars['examsession']}</h3>
                            </li>
                        </ul>
                    </div>
                    <div class="col-xs-3">
                        <ul class="list-unstyled list-inline">
                            <li>
                                <h3 class="logo"><span id="timer_h">00</span>：<span id="timer_m">00</span>：<span id="timer_s">00</span></h3>
                            </li>
                            <li class="pull-right">
                                <a href="javascript:;" onclick="javascript:$('#submodal').modal();" class="menu">
                                    <span class="glyphicon glyphicon-print"></span> 交卷
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="content fixtop">
                <div class="col-xs-3">
                    <div class="content-box padding" id="questionindex" data-spy="affix">
                        {x2;eval: v:oid = 0}
                        {x2;eval: v:qmid = 0}
                        {x2;tree:$sessionvars['examsessionsetting']['examsetting']['questypelite'],lite,qid}
                        {x2;if:v:lite}
                        {x2;eval: v:quest = v:key}
                        {x2;if:$sessionvars['examsessionquestion']['questions'][v:quest] || $sessionvars['examsessionquestion']['questionrows'][v:quest]}
                        {x2;if:$data['currentbasic']['basicexam']['changesequence']}
                        {x2;eval: shuffle($sessionvars['examsessionquestion']['questions'][v:quest]);}
                        {x2;eval: shuffle($sessionvars['examsessionquestion']['questionrows'][v:quest]);}
                        {x2;endif}
                        {x2;eval: v:oid++}
                        <h3 class="title">
                            {x2;$ols[v:oid]}、{x2;$questype[v:quest]['questype']}
                            <a class="badge pull-right resize"><em class="glyphicon glyphicon-resize-full"></em></a>
                        </h3>
                        <ul class="list-unstyled list-img">
                            <li id="qt_{x2;v:quest}">
                                {x2;eval: v:tid = 0}
                                {x2;tree:$sessionvars['examsessionquestion']['questions'][v:quest],question,qnid}
                                {x2;eval: v:tid++}
                                {x2;eval: v:qmid++}
                                <a id="sign_{x2;v:question['questionid']}" href="#q_{x2;v:question['questionid']}" class="btn btn-default qindex{x2;if:$sessionvars['examsessionsign'][v:question['questionid']]} btn-danger{x2;endif}">{x2;v:tid}</a>
                                {x2;endtree}
                                {x2;tree:$sessionvars['examsessionquestion']['questionrows'][v:quest],questionrow,qrid}
                                {x2;tree:v:questionrow['data'],question,did}
                                {x2;eval: v:tid++}
                                {x2;eval: v:qmid++}
                                <a id="sign_{x2;v:question['questionid']}" href="#q_{x2;v:question['questionid']}" class="btn btn-default qindex{x2;if:$sessionvars['examsessionsign'][v:question['questionid']]} btn-danger{x2;endif}">{x2;v:tid}</a>
                                {x2;endtree}
                                {x2;endtree}
                            </li>
                        </ul>
                        {x2;endif}
                        {x2;endif}
                        {x2;endtree}
                    </div>
                </div>
                <form class="col-xs-9 nopadding" id="paper" action="index.php?exam-app-exampaper-score">
                    {x2;eval: v:oid = 0}
                    {x2;eval: v:qcid = 0}
                    {x2;tree:$sessionvars['examsessionsetting']['examsetting']['questypelite'],lite,qid}
                    {x2;if:v:lite}
                    {x2;eval: v:quest = v:key}
                    {x2;if:$sessionvars['examsessionquestion']['questions'][v:quest] || $sessionvars['examsessionquestion']['questionrows'][v:quest]}
                    {x2;eval: v:oid++}
                    {x2;eval: v:tid = 0}
                    {x2;tree:$sessionvars['examsessionquestion']['questions'][v:quest],question,qnid}
                    {x2;eval: v:tid++}
                    {x2;eval: v:qcid++}
                    <div class="content-box padding">
                        <h2 class="title">
                            <a id="q_{x2;v:question['questionid']}"></a>
                            第 {x2;v:tid} 题 【 {x2;$questype[v:quest]['questype']}{x2;$sessionvars['examsessionsetting']['examsetting']['questype'][v:quest]['describe']} 】
                            <a class="badge pull-right favor" data-questionid="{x2;v:question['questionid']}">收藏</a>
                            <a class="badge pull-right" href="javascript:;" onclick="javascript:signQuestion('{x2;v:question['questionid']}',this);">{x2;if:$sessionvars['examsessionsign'][v:question['questionid']]}取消{x2;else}标记{x2;endif}</a>
                            <input id="time_{x2;v:question['questionid']}" type="hidden" name="time[{x2;v:question['questionid']}]"/>
                        </h2>
                        <ul class="list-unstyled list-img">
                            <li class="border morepadding">
                                <div class="desc">
                                    <p>{x2;realhtml:v:question['question']}</p>
                                </div>
                            </li>
                            {x2;if:$questype[v:quest]['questsort']}
                            <li class="border morepadding">
                                <textarea class="jckeditor" etype="simple" id="editor{x2;v:question['questionid']}" name="question[{x2;v:question['questionid']}]" rel="{x2;v:question['questionid']}">{x2;realhtml:$sessionvars['examsessionuseranswer'][v:question['questionid']]}</textarea>
                            </li>
                            {x2;else}
                            {x2;if:$questype[v:quest]['questchoice'] == 7}
                            <li class="border morepadding">
                                <div class="desc">
                                    <!--生成拖放题区域-[START]-->
                                    <div id="app{x2;v:question[questionid]}">
                                      <div class="card">
                                          <div class="card-body">
                                              <div class="text-area">
                                                  <ul>
                                                      <draggable :list="data.to" animation="300" item-key="id" group="dataType{x2;v:question[questionid]}" :sort="false" filter=".list">
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
                                                  :group="{ name: 'dataType{x2;v:question[questionid]}', pull: 'clone', put: false }" @start="eM.onStart($event)" @move="eM.onMove($event)" @end="eM.onEnd($event, {x2;v:question[questionid]})"
                                                  :sort="false" ghost-class="ghost" chosen-class="chosenClass">
                                                  <template #item="{ element }">
                                                      <div class="item">{{ element.name }}</div>
                                                  </template>
                                              </draggable>
                                          </div>
                                      </div>
                                    </div>
                                    <script type="application/javascript">
                                    examMode = true;
                                    currentId = '{x2;v:question[questionid]}';
                                    global = new Global;
                                    questionCache = localStorage.getItem('questions');
                                    questionCache = ((questionCache !== null) && (questionCache.length > 0)) ? (JSON.parse(questionCache)[currentId]?.value || []) : [];
                                    question = global.ajaxGetQuestion(currentId);
                                    if  (Object.keys(question).length > 0) {
                                        if(/\[\{(.*)\}\]/i.test(questionCache)) {
                                            question.to = JSON.parse(questionCache);
                                            document.querySelector(`#draggableQuestion${currentId}`).value = questionCache;
                                        }
                                    }
                                    question = question || { from: [], to: [] };
                                    // 打乱顺序
                                    question.from = global.getRandomArr(question.from, Object.keys(question.from).length);
                                    // 更新数据
                                    examObjList[currentId] = new DragObject;
                                    examObjList[currentId].data = reactive(question);
                                    eM = new EventManager(examObjList[currentId]);
                                    questionManager = new QuestionManager(examObjList[currentId], currentId);
                                    
                                    
                                    createApp({
                                      components: {
                                        'draggable': window.vuedraggable,
                                        'eM': eM,
                                        'question': question
                                      },
                                      data() {
                                        return {
                                          data: examObjList[currentId].data,
                                          eM: eM,
                                          question: questionManager
                                        }
                                      },
                                      methods: {
                                      }
                                    }).mount('#app' + currentId);
                                    global.markQuestion(currentId);
                                    </script>
                                    <input type="hidden" class="draggable-question" name="question[{x2;v:question['questionid']}]" id="draggableQuestion{x2;v:question['questionid']}" value="{x2;$sessionvars['examsessionuseranswer'][v:question['questionid']]}" rel="{x2;v:question['questionid']}" />
                                    <!--生成拖放题区域-[END]-->
                                </div>
                            </li>
                            {x2;else}
                            {x2;if:$questype[v:quest]['questchoice'] != 5}
                            <li class="border morepadding">
                                <div class="desc">
                                    <p>{x2;realhtml:v:question['questionselect']}</p>
                                </div>
                            </li>
                            {x2;endif}
                            <li class="border morepadding">
                                <div class="nopadding desc">
                                    {x2;if:$questype[v:quest]['questchoice'] == 1 || $questype[v:quest]['questchoice'] == 4}
                                    {x2;tree:$selectorder,so,sid}
                                    {x2;if:v:key == v:question['questionselectnumber']}
                                    {x2;eval: break;}
                                    {x2;endif}
                                    <label class="inline"><input type="radio" name="question[{x2;v:question['questionid']}]" rel="{x2;v:question['questionid']}" value="{x2;v:so}" {x2;if:v:so == $sessionvars['examsessionuseranswer'][v:question['questionid']]}checked{x2;endif}/><span class="selector">{x2;v:so}</span> </label>
                                    {x2;endtree}
                                    {x2;elseif:$questype[v:quest]['questchoice'] == 5}
                                    <input type="text" name="question[{x2;v:question['questionid']}]" placeholder="点击此处填写答案" value="{x2;$sessionvars['examsessionuseranswer'][v:question['questionid']]}" rel="{x2;v:question['questionid']}"/>
                                    {x2;else}
                                    {x2;tree:$selectorder,so,sid}
                                    {x2;if:v:key >= v:question['questionselectnumber']}
                                    {x2;eval: break;}
                                    {x2;endif}
                                    <label class="inline"><input type="checkbox" name="question[{x2;v:question['questionid']}][{x2;v:key}]" rel="{x2;v:question['questionid']}" value="{x2;v:so}" {x2;if:in_array(v:so,$sessionvars['examsessionuseranswer'][v:question['questionid']])}checked{x2;endif}/><span class="selector">{x2;v:so}</span> </label>
                                    {x2;endtree}
                                    {x2;endif}
                                </div>
                            </li>
                            {x2;endif}
                            {x2;endif}
                        </ul>
                    </div>
                    {x2;endtree}
                    {x2;tree:$sessionvars['examsessionquestion']['questionrows'][v:quest],questionrow,qnid}
                    {x2;tree:v:questionrow['data'],question,did}
                    {x2;eval: v:tid++}
                    {x2;eval: v:qcid++}
                    <div class="content-box padding">
                        <h2 class="title">
                            <a id="q_{x2;v:question['questionid']}"></a>
                            第 {x2;v:tid} 题 【 {x2;$questype[v:quest]['questype']}{x2;$sessionvars['examsessionsetting']['examsetting']['questype'][v:quest]['describe']} 】
                            <a class="badge pull-right favor" data-questionid="{x2;v:question['questionid']}">收藏</a>
                            <a class="badge pull-right" href="javascript:;" onclick="javascript:signQuestion('{x2;v:question['questionid']}',this);">{x2;if:$sessionvars['examsessionsign'][v:question['questionid']]}取消{x2;else}标记{x2;endif}</a>
                            <input id="time_{x2;v:question['questionid']}" type="hidden" name="time[{x2;v:question['questionid']}]"/>
                        </h2>
                        <ul class="list-unstyled list-img">
                            {x2;if:v:did == 1}
                            <li class="border morepadding">
                                <div class="desc">
                                    <p>{x2;realhtml:v:questionrow['qrquestion']}</p>
                                </div>
                            </li>
                            {x2;endif}
                            <li class="border morepadding">
                                <div class="desc">
                                    <p>{x2;realhtml:v:question['question']}</p>
                                </div>
                            </li>
                            {x2;if:$questype[v:quest]['questchoice'] == 7}
                            <li class="border morepadding">
                                <div class="desc">
                                    <!--生成拖放题区域-[START]-->
                                    <div id="app{x2;v:question[questionid]}">
                                      <div class="card">
                                          <div class="card-body">
                                              <div class="text-area">
                                                  <ul>
                                                      <draggable :list="data.to" animation="300" item-key="id" group="dataType{x2;v:question[questionid]}" :sort="false" filter=".list">
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
                                                  :group="{ name: 'dataType{x2;v:question[questionid]}', pull: 'clone', put: false }" @start="eM.onStart($event)" @move="eM.onMove($event)" @end="eM.onEnd($event, {x2;v:question[questionid]})"
                                                  :sort="false" ghost-class="ghost" chosen-class="chosenClass">
                                                  <template #item="{ element }">
                                                      <div class="item">{{ element.name }}</div>
                                                  </template>
                                              </draggable>
                                          </div>
                                      </div>
                                    </div>
                                    <script type="application/javascript">
                                    examMode = true;
                                    currentId = '{x2;v:question[questionid]}';
                                    global = new Global;
                                    questionCache = localStorage.getItem('questions');
                                    questionCache = ((questionCache !== null) && (questionCache.length > 0)) ? (JSON.parse(questionCache)[currentId]?.value || []) : [];
                                    question = global.ajaxGetQuestion(currentId);
                                    if  (Object.keys(question).length > 0) {
                                        if(/\[\{(.*)\}\]/i.test(questionCache)) {
                                            question.to = JSON.parse(questionCache);
                                            document.querySelector(`#draggableQuestion${currentId}`).value = questionCache;
                                        }
                                    }
                                    question = question || { from: [], to: [] };
                                    // 打乱顺序
                                    question.from = global.getRandomArr(question.from, Object.keys(question.from).length);
                                    // 更新数据
                                    examObjList[currentId] = new DragObject;
                                    examObjList[currentId].data = reactive(question);
                                    eM = new EventManager(examObjList[currentId]);
                                    questionManager = new QuestionManager(examObjList[currentId], currentId);
                                    
                                    
                                    createApp({
                                      components: {
                                        'draggable': window.vuedraggable,
                                        'eM': eM,
                                        'question': question
                                      },
                                      data() {
                                        return {
                                          data: examObjList[currentId].data,
                                          eM: eM,
                                          question: questionManager
                                        }
                                      },
                                      methods: {
                                      }
                                    }).mount('#app' + currentId);
                                    global.markQuestion(currentId);
                                    </script>
                                    <input type="hidden" class="draggable-question" name="question[{x2;v:question['questionid']}]" id="draggableQuestion{x2;v:question['questionid']}" value="{x2;$sessionvars['examsessionuseranswer'][v:question['questionid']]}" rel="{x2;v:question['questionid']}" />
                                    <!--生成拖放题区域-[END]-->
                                </div>
                            </li>
                            {x2;else}
                            {x2;if:$questype[v:question['questiontype']]['questsort']}
                            <li class="border morepadding">
                                <textarea class="jckeditor" etype="simple" id="editor{x2;v:question['questionid']}" name="question[{x2;v:question['questionid']}]" rel="{x2;v:question['questionid']}">{x2;realhtml:$sessionvars['examsessionuseranswer'][v:question['questionid']]}</textarea>
                            </li>
                            {x2;else}
                            {x2;if:$questype[v:question['questiontype']]['questchoice'] != 5}
                            <li class="border morepadding">
                                <div class="desc">
                                    <p>{x2;realhtml:v:question['questionselect']}</p>
                                </div>
                            </li>
                            {x2;endif}
                            <li class="border morepadding">
                                <div class="nopadding desc">
                                    {x2;if:$questype[v:question['questiontype']]['questchoice'] == 1 || $questype[v:question['questiontype']]['questchoice'] == 4}
                                    {x2;tree:$selectorder,so,sid}
                                    {x2;if:v:key == v:question['questionselectnumber']}
                                    {x2;eval: break;}
                                    {x2;endif}
                                    <label class="inline"><input type="radio" name="question[{x2;v:question['questionid']}]" rel="{x2;v:question['questionid']}" value="{x2;v:so}" {x2;if:v:so == $sessionvars['examsessionuseranswer'][v:question['questionid']]}checked{x2;endif}/><span class="selector">{x2;v:so}</span> </label>
                                    {x2;endtree}
                                    {x2;elseif:$questype[v:question['questiontype']]['questchoice'] == 5}
                                    <input type="text" name="question[{x2;v:question['questionid']}]" placeholder="点击此处填写答案" value="{x2;$sessionvars['examsessionuseranswer'][v:question['questionid']]}" rel="{x2;v:question['questionid']}"/>
                                    {x2;else}
                                    {x2;tree:$selectorder,so,sid}
                                    {x2;if:v:key >= v:question['questionselectnumber']}
                                    {x2;eval: break;}
                                    {x2;endif}
                                    <label class="inline"><input type="checkbox" name="question[{x2;v:question['questionid']}][{x2;v:key}]" rel="{x2;v:question['questionid']}" value="{x2;v:so}" {x2;if:in_array(v:so,$sessionvars['examsessionuseranswer'][v:question['questionid']])}checked{x2;endif}/><span class="selector">{x2;v:so}</span> </label>
                                    {x2;endtree}
                                    {x2;endif}
                                </div>
                            </li>
                            {x2;endif}
                            {x2;endif}
                        </ul>
                    </div>
                    {x2;endtree}
                    {x2;endtree}
                    {x2;endif}
                    {x2;endif}
                    {x2;endtree}
                    <input type="hidden" name="insertscore" value="1"/>
                    <input type="hidden" name="token" value="{x2;$sessionvars['examsessiontoken']}"/>
                </form>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="submodal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">交卷</h4>
            </div>
            <div class="modal-body">
                <p>共有试题 <span class="allquestionnumber">50</span> 题，已做 <span class="yesdonumber">0</span> 题。您确认要交卷吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" onclick="javascript:submitPaper();" class="btn btn-primary">确定交卷</button>
                <button aria-hidden="true" class="btn" type="button" data-dismiss="modal">再检查一下</button>
            </div>
        </div>
    </div>
</div>
<script>
    $(function(){
        $.get('index.php?exam-app-index-ajax-lefttime&rand'+Math.random(),function(data){
            var setting = {
                time:{x2;eval: echo intval($sessionvars['examsessiontime'])},
                hbox:$("#timer_h"),
                mbox:$("#timer_m"),
                sbox:$("#timer_s"),
                finish:function(){
                    submitPaper();
                }
            }
            setting.lefttime = parseInt(data);
            countdown(setting);
        });
        setInterval(saveanswer,120000);
    });
</script>
{x2;include:paper_footer}
</body>
</html>
