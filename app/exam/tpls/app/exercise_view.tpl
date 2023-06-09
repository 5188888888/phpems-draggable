{x2;include:header}
<body>
<script src="app/exam/styles/js/plugin.js"></script>
{x2;include:nav}
<div class="row-fluid">
    <div class="container-fluid examcontent">
        <div class="exambox" id="datacontent">
            <div class="examform" style="position:relative;">
                <div class="scoreArea">{x2;$sessionvars['examsessionscore']}</div>
                <ul class="breadcrumb">
                    <li>
                        <span class="icon-home"></span> <a href="index.php?exam">考场选择</a> <span class="divider">/</span>
                    </li>
                    <li>
                        <a href="index.php?exam-app-basics">{x2;$data['currentbasic']['basic']}</a> <span class="divider">/</span>
                    </li>
                    <li>
                        <a href="index.php?exam-app-exercise">强化训练</a> <span class="divider">/</span>
                    </li>
                    <li class="active">
                        答案与解析
                    </li>
                </ul>
                <h3 class="text-center">{x2;$sessionvars['examsession']}</h3>
                {x2;eval: v:oid = 0}
                {x2;tree:$questype,quest,qid}
                {x2;if:$sessionvars['examsessionquestion']['questions'][v:quest['questid']] || $sessionvars['examsessionquestion']['questionrows'][v:quest['questid']]}
                {x2;eval: v:oid++}
                <div id="panel-type{x2;v:quest['questid']}" class="tab-pane{x2;if:(!$ctype && v:qid == 1) || ($ctype == v:quest['questid'])} active{x2;endif}">
                    <ul class="breadcrumb">
                        <li>
                            <h5>{x2;v:oid}、{x2;v:quest['questype']}</h5>
                        </li>
                    </ul>
                    {x2;eval: v:tid = 0}
                    {x2;tree:$sessionvars['examsessionquestion']['questions'][v:quest['questid']],question,qnid}
                    {x2;eval: v:tid++}
                    <div id="question_{x2;v:question['questionid']}" class="paperexamcontent decidediv">
                        {x2;if:$sessionvars['examsessionscorelist'][v:question['questionid']] && $sessionvars['examsessionscorelist'][v:question['questionid']] == 1}<div class="right"></div>{x2;else}<div class="wrong"></div>{x2;endif}
                        <div class="media well">
                            <ul class="nav nav-tabs">
                                <li class="active">
                                    <span class="badge badge-info questionindex">{x2;v:tid}</span>
                                </li>
                                <li class="btn-group pull-right">
                                    <button class="btn" type="button" onclick="javascript:favorquestion('{x2;v:question['questionid']}');"><em class="icon-heart" title="收藏"></em></button>
                                </li>
                            </ul>
                            <div class="media-body well text-warning">
                                <a name="question_{x2;v:question['questionid']}"></a>{x2;realhtml:v:question['question']}
                            </div>
                            {x2;if:!v:quest['questsort']}
                            <div class="media-body well">
                                {x2;realhtml:v:question['questionselect']}
                            </div>
                            {x2;endif}
                            <div class="media-body well">
                                  <p class="text-error">本题得分：{x2;$sessionvars['examsessionscorelist'][v:question['questionid']]}分</p>
                              </div>
                            <div class="media-body well">
                                <ul class="unstyled">
                                    <li class="text-error">正确答案：</li>
                                    {x2;if:$questype[v:quest]['questchoice'] == 7}
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
                                                                <div :id="currentId + '_' + element.id" class="gap">{{ element.value ?? '' }}</div>
                                                            </li>
                                                        </template>
                                                    </draggable>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    </div>
                                    <script type="application/javascript">
                                    currentId = '{x2;v:question[questionid]}';
                                    global = new Global;
                                    questionCache = localStorage.getItem('questions');
                                    questionCache = ((questionCache !== null) && (questionCache.length > 0)) ? (JSON.parse(questionCache)[currentId]?.value || []) : [];
                                    question = global.ajaxGetQuestion(currentId);
                                    if  (Object.keys(question).length > 0) {
                                        if(/\[\{(.*)\}\]/i.test(questionCache)) {
                                            question.to = JSON.parse(questionCache);
                                        }
                                    }
                                    question = question || { to: [] };

                                    delete question.from;
                                    // 更新数据
                                    examObjList[currentId] = new DragObject;
                                    examObjList[currentId].data = reactive(question);
                                    eM = new EventManager(examObjList[currentId]);
                                    questionManager = new QuestionManager(examObjList[currentId], currentId);
                                    questionManager.silenceCheckAnswer(currentId);
                                    createApp({
                                    components: {
                                        'draggable': window.vuedraggable,
                                        'eM': eM,
                                        'question': questionManager
                                    },
                                    data() {
                                        return {
                                        data: examObjList[currentId].data,
                                        eM: eM,
                                        question: questionManager,
                                        currentId: currentId
                                        }
                                    },
                                    methods: {
                                    }
                                    }).mount('#app' + currentId);
                                    </script>
                                    <!--生成拖放题区域-[END]-->
                                    {x2;else}
                                    <li class="text-success">{x2;realhtml:v:question['questionanswer']}</li>
                                    <li class="text-info">您的答案：</li>
                                    <li class="text-success">{x2;if:is_array($sessionvars['examsessionuseranswer'][v:question['questionid']])}{x2;eval: echo implode('',$sessionvars['examsessionuseranswer'][v:question['questionid']])}{x2;else}{x2;realhtml:$sessionvars['examsessionuseranswer'][v:question['questionid']]}{x2;endif}</li>
                                    
                                    {x2;endif}
                                    <li><span class="text-info">所在章：</span>{x2;tree:v:question['questionknowsid'],knowsid,kid}&nbsp;&nbsp;{x2;$globalsections[$globalknows[v:knowsid['knowsid']]['knowssectionid']]['section']}&nbsp;{x2;endtree}</li>
                                    <li class="text-success"><span class="text-info">知识点：</span>{x2;tree:v:question['questionknowsid'],knowsid,kid}&nbsp;&nbsp;{x2;$globalknows[v:knowsid['knowsid']]['knows']}&nbsp;{x2;endtree}</li>
                                    <li class="text-info">答案解析：</li>
                                    <li class="text-success">{x2;realhtml:v:question['questiondescribe']}</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    {x2;endtree}
                    {x2;tree:$sessionvars['examsessionquestion']['questionrows'][v:quest['questid']],questionrow,qrid}
                    {x2;eval: v:tid++}
                    <div id="questionrow_{x2;v:questionrow['qrid']}">
                        <div class="media well">
                            <ul class="nav nav-tabs">
                                <li class="active">
                                    <span class="badge badge-info questionindex">{x2;v:tid}</span>
                                </li>
                            </ul>
                            <div class="media-body well">
                                {x2;realhtml:v:questionrow['qrquestion']}
                            </div>
                            {x2;tree:v:questionrow['data'],data,did}
                            <div class="paperexamcontent decidediv">
                                {x2;if:$sessionvars['examsessionscorelist'][v:data['questionid']] && $sessionvars['examsessionscorelist'][v:data['questionid']] == 1}<div class="right"></div>{x2;else}<div class="wrong"></div>{x2;endif}
                                <ul class="nav nav-tabs">
                                    <li class="active">
                                        <span class="badge questionindex">{x2;v:did}</span>
                                    </li>
                                    <li class="btn-group pull-right">
                                        <button class="btn" type="button" onclick="javascript:favorquestion('{x2;v:data['questionid']}');"><em class="icon-heart" title="收藏"></em></button>
                                    </li>
                                </ul>
                                <div class="media-body well text-warning">
                                    <a name="question_{x2;v:data['questionid']}"></a>{x2;realhtml:v:data['question']}
                                </div>
                                {x2;if:!v:quest['questsort']}
                                <div class="media-body well">
                                    {x2;realhtml:v:data['questionselect']}
                                </div>
                                {x2;endif}
                                <div class="media-body well">
                                      <p class="text-error">本题得分：{x2;$sessionvars['examsessionscorelist'][v:data['questionid']]}分</p>
                                  </div>
                                <div class="media-body well">
                                    <ul class="unstyled">
                                        <li class="text-error">正确答案：</li>
                                        {x2;if:$questype[v:quest]['questchoice'] == 7}<!--生成拖放题区域-[START]-->
                                        <div id="app{x2;v:question[questionid]}">
                                        <div class="card">
                                            <div class="card-body">
                                                <div class="text-area">
                                                    <ul>
                                                        <draggable :list="data.to" animation="300" item-key="id" group="dataType{x2;v:question[questionid]}" :sort="false" filter=".list">
                                                            <template #item="{ element }">
                                                                <li class="list">
                                                                    <span>{{ element.description }}</span>
                                                                    <div :id="currentId + '_' + element.id" class="gap">{{ element.value ?? '' }}</div>
                                                                </li>
                                                            </template>
                                                        </draggable>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                        </div>
                                        <script type="application/javascript">
                                        currentId = '{x2;v:question[questionid]}';
                                        global = new Global;
                                        questionCache = localStorage.getItem('questions');
                                        questionCache = ((questionCache !== null) && (questionCache.length > 0)) ? (JSON.parse(questionCache)[currentId]?.value || []) : [];
                                        question = global.ajaxGetQuestion(currentId);
                                        if  (Object.keys(question).length > 0) {
                                            if(/\[\{(.*)\}\]/i.test(questionCache)) {
                                                question.to = JSON.parse(questionCache);
                                            }
                                        }
                                        question = question || { to: [] };
    
                                        delete question.from;
                                        // 更新数据
                                        examObjList[currentId] = new DragObject;
                                        examObjList[currentId].data = reactive(question);
                                        eM = new EventManager(examObjList[currentId]);
                                        questionManager = new QuestionManager(examObjList[currentId], currentId);
                                        questionManager.silenceCheckAnswer(currentId);
                                        createApp({
                                        components: {
                                            'draggable': window.vuedraggable,
                                            'eM': eM,
                                            'question': questionManager
                                        },
                                        data() {
                                            return {
                                            data: examObjList[currentId].data,
                                            eM: eM,
                                            question: questionManager,
                                            currentId: currentId
                                            }
                                        },
                                        methods: {
                                        }
                                        }).mount('#app' + currentId);
                                        </script>
                                        <!--生成拖放题区域-[END]-->
                                        {x2;else}
                                        <li class="text-success">{x2;realhtml:v:data['questionanswer']}</li>
                                        <li class="text-info">您的答案：</li>
                                        <li class="text-success">{x2;if:is_array($sessionvars['examsessionuseranswer'][v:data['questionid']])}{x2;eval: echo implode('',$sessionvars['examsessionuseranswer'][v:data['questionid']])}{x2;else}{x2;realhtml:$sessionvars['examsessionuseranswer'][v:data['questionid']]}{x2;endif}</li>
                                        {x2;endif}
                                        <li><span class="text-info">所在章：</span>{x2;tree:v:questionrow['qrknowsid'],knowsid,kid}&nbsp;&nbsp;{x2;$globalsections[$globalknows[v:knowsid['knowsid']]['knowssectionid']]['section']}&nbsp;{x2;endtree}</li>
                                        <li><span class="text-info">知识点：</span>{x2;tree:v:questionrow['qrknowsid'],knowsid,kid}&nbsp;&nbsp;{x2;$globalknows[v:knowsid['knowsid']]['knows']}&nbsp;{x2;endtree}</li>
                                        <li class="text-info">答案解析：</li>
                                        <li class="text-success">{x2;realhtml:v:data['questiondescribe']}</li>
                                    </ul>
                                </div>
                            </div>
                            {x2;endtree}
                        </div>
                    </div>
                    {x2;endtree}
                </div>
                {x2;endif}
                {x2;endtree}
            </div>
        </div>
    </div>
</div>
{x2;include:foot}
</body>
</html>
