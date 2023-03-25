{x2;if:!$userhash}
{x2;include:header}
<body>
<div class="pages">
    {x2;endif}
    <div class="page-tabs">
        <div class="page-header">
            <div class="col-1" onclick="javascript:history.back();"><span class="iconfont icon-left"></span></div>
            <div class="col-8">{x2;$sessionvars['examsession']}</div>
            <div class="col-1"><span class="iconfont icon-menu hide"></span></div>
        </div>
        <div class="page-content header footer" style="height: 100%;overflow: hidden">
            <form class="list-box bg" style="height: 100%;" id="exampaper">
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        {x2;eval: v:oid = 0}
                        {x2;eval: v:qcid = 0}
                        {x2;tree:$questype,quest,qid}
                        {x2;if:v:quest}
                        {x2;eval: v:quest = v:quest['questid']}
                        {x2;if:$sessionvars['examsessionquestion']['questions'][v:quest] || $sessionvars['examsessionquestion']['questionrows'][v:quest]}
                        {x2;eval: v:oid++}
                        {x2;eval: v:tid = 0}
                        {x2;tree:$sessionvars['examsessionquestion']['questions'][v:quest],question,qnid}
                        {x2;eval: v:tid++}
                        {x2;eval: v:qcid++}
                        {x2;if:$sessionvars['examsessionscorelist'][v:question['questionid']] && $sessionvars['examsessionscorelist'][v:question['questionid']] == $sessionvars['examsessionsetting']['examsetting']['questype'][v:quest]['score']}
                        {x2;else}
                        <div class="swiper-slide" style="overflow-y: scroll">
                            <ol>
                                <li class="unstyled">
                                    <h4 class="title">
                                        第 {x2;v:qcid} 题 【 {x2;$questype[v:quest]['questype']} 】
                                    </h4>
                                </li>
                                <li class="unstyled">
                                    <div class="rows">
                                        <p>{x2;realhtml:v:question['question']}</p>
                                    </div>
                                </li>
                                <li class="unstyled">
                                    <div class="rows">
                                        <p>{x2;realhtml:v:question['questionselect']}</p>
                                    </div>
                                </li>
                                {x2;if:$questype[v:quest]['questchoice'] == 7}
                                <li class="border morepadding">
                                    <div class="desc">
                                        <!--生成拖放题区域-[START]-->
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
                                                  <draggable class="drag-area" :list="data.from" animation="300" item-key="id"
                                                      :group="{ name: 'dataType{x2;v:question[questionid]}', pull: 'clone', put: false }" @start="eM.onStart($event)" @move="eM.onMove($event)" @end="eM.onEnd($event, {x2;v:question[questionid]})"
                                                      :sort="false" ghost-class="ghost" chosen-class="chosenClass">
                                                      <template #item="{ element }">
                                                          <div class="item">{{ element.name }}</div>
                                                      </template>
                                                  </draggable>
                                                  <div class="submit-area">
                                                      <button class="btn btn-primary badge" @click="question.checkAnswer(currentId)">答题完毕</button>
                                                  </div>
                                              </div>
                                          </div>
                                        </div>
                                        <input type="hidden" class="draggable-question" id="draggableQuestion{x2;v:question['questionid']}" value="{x2;$sessionvars['examsessionuseranswer'][v:question['questionid']]}" rel="{x2;v:question['questionid']}" />
                                        <!--生成拖放题区域-[END]-->
                                    </div>
                                </li>
                                {x2;else}
                                {x2;if:$questype[v:quest]['questsort']}
                                <li class="unstyled">
                                    <textarea rows="4" id="editor{x2;v:question['questionid']}" name="question[{x2;v:question['questionid']}]" rel="{x2;v:question['questionid']}">{x2;realhtml:$sessionvars['examsessionuseranswer'][v:question['questionid']]}</textarea>
                                </li>
                                <li class="unstyled text-center">
                                    <button class="primary badge" onclick="javascript:$(this).parents('li').hide().parents('.list-box').find('.rightanswer').removeClass('hide');">查看答案</button>
                                </li>
                                {x2;else}
                                <li class="unstyled">
                                    <div class="rows">
                                        {x2;if:$questype[v:quest]['questchoice'] == 1 || $questype[v:quest]['questchoice'] == 4}
                                        {x2;tree:$selectorder,so,sid}
                                        {x2;if:v:key == v:question['questionselectnumber']}
                                        {x2;eval: break;}
                                        {x2;endif}
                                        <label class="inline"><input type="radio" name="question[{x2;v:question['questionid']}]" rel="{x2;v:question['questionid']}" value="{x2;v:so}" {x2;if:v:so == $sessionvars['examsessionuseranswer'][v:question['questionid']]}checked{x2;endif}/><span class="selector">{x2;v:so}</span> </label>
                                        {x2;endtree}
                                        {x2;elseif:$questype[v:quest]['questchoice'] == 5}
                                        <input type="text" name="question[{x2;v:question['questionid']}]" placeholder="点击此处填写答案" value="{x2;$sessionvars['examsessionuseranswer'][v:question['questionid']]}" rel="{x2;v:question['questionid']}"/>
                                        <label class="inline pull-right"><button class="btn btn-primary badge finish fill" rel="{x2;v:question['questionid']}">答题完毕</button></label>
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
                                {x2;if:$questype[v:quest]['questchoice'] == 2 || $questype[v:quest]['questchoice'] == 3}
                                <li class="unstyled text-center">
                                    <button class="primary badge finish" rel="{x2;v:question['questionid']}">答题完毕</button>
                                </li>
                                {x2;endif}
                                {x2;endif}
                                {x2;endif}
                                <li class="unstyled rightanswer hide">
                                    <div class="rows">
                                        {x2;if:$questype[v:quest]['questsort']}
                                        <div class="intro">
                                            <span class="badge">正确答案</span>
                                        </div>
                                        <div class="intro">
                                            {x2;realhtml:v:question['questionanswer']}
                                        </div>
                                        {x2;else}
                                        <div class="col-4x intro">
                                            <span class="badge">正确答案</span>
                                        </div>
                                        <div class="col-4l intro">
                                            <b id="rightanswer_{x2;v:question['questionid']}">{x2;v:question['questionanswer']}</b>
                                        </div>
                                        {x2;endif}
                                    </div>
                                </li>
                                <li class="unstyled rightanswer hide">
                                    <div class="rows">
                                        {x2;if:strlen(v:question['questiondescribe']) >= 10}
                                        <div class="intro">
                                            <span class="badge">试题解析</span>
                                        </div>
                                        <div class="intro">
                                            {x2;realhtml:v:question['questiondescribe']}
                                        </div>
                                        {x2;else}
                                        <div class="col-4x">
                                            <span class="badge">试题解析</span>
                                        </div>
                                        <div class="col-4l intro">
                                            {x2;realhtml:v:question['questiondescribe']}
                                        </div>
                                        {x2;endif}
                                    </div>
                                </li>
                            </ol>
                        </div>
                        {x2;endif}
                        {x2;endtree}
                        {x2;tree:$sessionvars['examsessionquestion']['questionrows'][v:quest],questionrow,qrid}
                        {x2;eval: v:tid++}
                        {x2;tree:v:questionrow['data'],question,qid}
                        {x2;eval: v:qcid++}
                        {x2;if:$sessionvars['examsessionscorelist'][v:question['questionid']] && $sessionvars['examsessionscorelist'][v:question['questionid']] == $sessionvars['examsessionsetting']['examsetting']['questype'][v:quest]['score']}
                        {x2;else}
                        <div class="swiper-slide" style="overflow-y: scroll">
                            <ol>
                                <li class="unstyled">
                                    <h4 class="title">
                                        第 {x2;v:qcid} 题
                                    </h4>
                                </li>
                                <li class="unstyled">
                                    <div class="rows">
                                        <p>{x2;realhtml:v:questionrow['qrquestion']}</p>
                                    </div>
                                </li>
                                <li class="unstyled">
                                    <div class="rows">
                                        <p>{x2;realhtml:v:question['question']}</p>
                                    </div>
                                </li>
                                <li class="unstyled">
                                    <div class="rows">
                                        <p>{x2;realhtml:v:question['questionselect']}</p>
                                    </div>
                                </li>
                                {x2;if:$questype[v:quest]['questchoice'] == 7}
                                <li class="border morepadding">
                                    <div class="desc">
                                        <!--生成拖放题区域-[START]-->
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
                                                  <draggable class="drag-area" :list="data.from" animation="300" item-key="id"
                                                      :group="{ name: 'dataType{x2;v:question[questionid]}', pull: 'clone', put: false }" @start="eM.onStart($event)" @move="eM.onMove($event)" @end="eM.onEnd($event, {x2;v:question[questionid]})"
                                                      :sort="false" ghost-class="ghost" chosen-class="chosenClass">
                                                      <template #item="{ element }">
                                                          <div class="item">{{ element.name }}</div>
                                                      </template>
                                                  </draggable>
                                                  <div class="submit-area">
                                                      <button class="btn btn-primary badge" @click="question.checkAnswer(currentId)">答题完毕</button>
                                                  </div>
                                              </div>
                                          </div>
                                        </div>
                                        <input type="hidden" class="draggable-question" id="draggableQuestion{x2;v:question['questionid']}" value="{x2;$sessionvars['examsessionuseranswer'][v:question['questionid']]}" rel="{x2;v:question['questionid']}" />
                                        <!--生成拖放题区域-[END]-->
                                    </div>
                                </li>
                                {x2;else}
                                {x2;if:$questype[v:question['questiontype']]['questsort']}
                                <li class="unstyled">
                                    <textarea rows="4" id="editor{x2;v:question['questionid']}" name="question[{x2;v:question['questionid']}]" rel="{x2;v:question['questionid']}">{x2;realhtml:$sessionvars['examsessionuseranswer'][v:question['questionid']]}</textarea>
                                </li>
                                <li class="unstyled text-center">
                                    <button class="primary badge" onclick="javascript:$(this).parents('li').hide().parents('.list-box').find('.rightanswer').removeClass('hide');">查看答案</button>
                                </li>
                                {x2;else}
                                <li class="unstyled">
                                    <div class="rows">
                                        {x2;if:$questype[v:question['questiontype']]['questchoice'] == 1 || $questype[v:question['questiontype']]['questchoice'] == 4}
                                        {x2;tree:$selectorder,so,sid}
                                        {x2;if:v:key == v:question['questionselectnumber']}
                                        {x2;eval: break;}
                                        {x2;endif}
                                        <label class="inline"><input type="radio" name="question[{x2;v:question['questionid']}]" rel="{x2;v:question['questionid']}" value="{x2;v:so}" {x2;if:v:so == $sessionvars['examsessionuseranswer'][v:question['questionid']]}checked{x2;endif}/><span class="selector">{x2;v:so}</span> </label>
                                        {x2;endtree}
                                        {x2;elseif:$questype[v:question['questiontype']]['questchoice'] == 5}
                                        <input type="text" name="question[{x2;v:question['questionid']}]" placeholder="点击此处填写答案" value="{x2;$sessionvars['examsessionuseranswer'][v:question['questionid']]}" rel="{x2;v:question['questionid']}"/>
                                        <label class="inline pull-right"><button class="btn btn-primary badge finish fill" rel="{x2;v:question['questionid']}">答题完毕</button></label>
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
                                {x2;if:$questype[v:question['questiontype']]['questchoice'] == 2 || $questype[v:question['questiontype']]['questchoice'] == 3}
                                <li class="unstyled text-center">
                                    <button class="primary badge finish" rel="{x2;v:question['questionid']}">答题完毕</button>
                                </li>
                                {x2;endif}
                                {x2;endif}
                                {x2;endif}
                                <li class="unstyled rightanswer hide">
                                    <div class="rows">
                                        {x2;if:$questype[v:question['questiontype']]['questsort']}
                                        <div class="intro">
                                            <span class="badge">正确答案</span>
                                        </div>
                                        <div class="intro">
                                            {x2;realhtml:v:question['questionanswer']}
                                        </div>
                                        {x2;else}
                                        <div class="col-4x intro">
                                            <span class="badge">正确答案</span>
                                        </div>
                                        <div class="col-4l intro">
                                            <b id="rightanswer_{x2;v:question['questionid']}">{x2;v:question['questionanswer']}</b>
                                        </div>
                                        {x2;endif}
                                    </div>
                                </li>
                                <li class="unstyled rightanswer hide">
                                    <div class="rows">
                                        {x2;if:strlen(v:question['questiondescribe']) >= 10}
                                        <div class="intro">
                                            <span class="badge">试题解析</span>
                                        </div>
                                        <div class="intro">
                                            {x2;realhtml:v:question['questiondescribe']}
                                        </div>
                                        {x2;else}
                                        <div class="col-4x">
                                            <span class="badge">试题解析</span>
                                        </div>
                                        <div class="col-4l intro">
                                            {x2;realhtml:v:question['questiondescribe']}
                                        </div>
                                        {x2;endif}
                                    </div>
                                </li>
                            </ol>
                        </div>
                        {x2;endif}
                        {x2;endtree}
                        {x2;endtree}
                        {x2;endif}
                        {x2;endif}
                        {x2;endtree}
                    </div>
                </div>
            </form>
        </div>
        <div class="page-content header footer hide">
            <div class="list-box bg">
                <ol>
                    {x2;eval: v:oid = 0}
                    {x2;eval: v:qmid = 0}
                    {x2;tree:$sessionvars['examsessionsetting']['examsetting']['questypelite'],lite,qid}
                    {x2;if:v:lite}
                    {x2;eval: v:quest = v:key}
                    {x2;if:$sessionvars['examsessionquestion']['questions'][v:quest] || $sessionvars['examsessionquestion']['questionrows'][v:quest]}
                    {x2;eval: v:oid++}
                    <li class="unstyled">
                        <div class="rows">
                            <h4 class="title text-center">{x2;$questype[v:quest]['questype']}</h4>
                            {x2;eval: v:tid = 0}
                            {x2;tree:$sessionvars['examsessionquestion']['questions'][v:quest],question,qnid}
                            {x2;eval: v:tid++}
                            {x2;eval: v:qmid++}
                            {x2;if:$sessionvars['examsessionscorelist'][v:question['questionid']] && $sessionvars['examsessionscorelist'][v:question['questionid']] == $sessionvars['examsessionsetting']['examsetting']['questype'][v:quest]['score']}
                            {x2;else}
                            <div class="col-2">
                                <a data-index="{x2;v:qmid}" data-questionid="{x2;v:question['questionid']}" id="sign_{x2;v:question['questionid']}" class="btn order{x2;if:!$eh['ehscorelist'][v:question['questionid']]} danger{x2;endif}">{x2;v:tid}</a>
                            </div>
                            {x2;endif}
                            {x2;endtree}
                            {x2;tree:$sessionvars['examsessionquestion']['questionrows'][v:quest],questionrow,qrid}
                            {x2;eval: v:tid++}
                            {x2;tree:v:questionrow['data'],question,did}
                            {x2;eval: v:qmid++}
                            {x2;if:$sessionvars['examsessionscorelist'][v:question['questionid']] && $sessionvars['examsessionscorelist'][v:question['questionid']] == $sessionvars['examsessionsetting']['examsetting']['questype'][v:quest]['score']}
                            {x2;else}
                            <div class="col-2">
                                <a data-index="{x2;v:qmid}" data-questionid="{x2;v:question['questionid']}" id="sign_{x2;v:question['questionid']}" class="btn order{x2;if:!$eh['ehscorelist'][v:question['questionid']]} danger{x2;endif}">{x2;v:tid}-{x2;v:did}</a>
                            </div>
                            {x2;endif}
                            {x2;endtree}
                            {x2;endtree}
                        </div>
                    </li>
                    {x2;endif}
                    {x2;endif}
                    {x2;endtree}
                </ol>
            </div>
        </div>
        <div class="page-footer">
            <div class="col-3x iconmenu" id="favor">
                <span class="iconfont icon-star"></span><br />收藏
            </div>
            <div class="col-3x iconmenu" id="card">
                <span class="iconfont icon-detail"></span><br />题卡
            </div>
            <div class="col-3x iconmenu" id="error">
                <span class="iconfont icon-wrench"></span><br />纠错
            </div>
        </div>
        <script>
            $(function(){
                var mySwiper = new Swiper ('.swiper-container',{});
                $('#card').on('click',function(){
                    $('.page-content').toggleClass('hide');
                    $(this).toggleClass('active');
                });
                $('.order').on('click',function(){
                    $('.page-content').toggleClass('hide');
                    $('#card').toggleClass('active');
                    mySwiper.slideTo($(this).attr('data-index')-1);
                });
                $('#favor').on('click',function(){
                    favorquestion($('.order').eq(mySwiper.activeIndex).attr('data-questionid'));
                });
                $('#error').on('click',function(){
                    errorport($('.order').eq(mySwiper.activeIndex).attr('data-questionid'));
                });
                var sumquestion = function(value,qid,obj){
                    obj.parents('ol:first').find('.rightanswer').removeClass('hide');
                    if(value == $("#rightanswer_"+qid).html())
                    {
                        pep.mask.show('ajaxOK',{message:'回答正确'});
                        $("#rightanswer_"+qid).attr('class','text-success');
                    }
                    else
                    {
                        pep.mask.show('ajax',{message:'回答错误'});
                        $("#rightanswer_"+qid).attr('class','text-danger');
                    }
                    setTimeout(pep.mask.hide,1000);
                }
                $("input:radio").click(function(){
                    var _this = $(this);
                    var qid = _this.attr('rel');
                    sumquestion(_this.val(),qid,_this);
                });
                $(".finish").click(function(){
                    var _this = $(this);
                    var qid = _this.attr('rel');
                    var parent = _this.parents("ol:first");
                    var value = '';
                    if(_this.hasClass('fill')){
                        value = parent.find("input").val();
                    }
                    else{
                        parent.find("input:checked").each(function(){
                            value += $(this).val().toUpperCase();
                        });
                    }
                    if(value == '')
                    {
                        pep.mask.show('ajax',{message:'请先答题'});
                        return;
                    }
                    sumquestion(value,qid,_this);
                });
            });
        </script>
    </div>
    {x2;if:!$userhash}
</div>
</body>
</html>
{x2;endif}
