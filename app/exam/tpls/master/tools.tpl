{x2;include:header}
<body>
{x2;include:nav}
<div class="container-fluid">
    <div class="row-fluid">
        <div class="main">
            <div class="col-xs-2 leftmenu">
                {x2;include:menu}
            </div>
            <div id="datacontent">
                <div class="box itembox" style="margin-bottom:0px;border-bottom:1px solid #CCCCCC;">
                    <div class="col-xs-12">
                        <ol class="breadcrumb">
                            <li><a href="index.php?{x2;$_app}-master">{x2;$apps[$_app]['appname']}</a></li>
                            <li class="active">批量删除试题</li>
                        </ol>
                    </div>
                </div>
                <div class="box itembox" style="padding-top:10px;margin-bottom:0px;">
                    <h4 class="title" style="padding:10px;">
                        批量删除普通试题
                    </h4>
                    <form action="index.php?exam-master-tools-clearquestions" method="post" id="qstool">
                        <table class="table form-inline">
                            <tr>
                                <td style="border-top:0px;">
                                    录入时间：
                                </td>
                                <td style="border-top:0px;">
                                    <input class="form-control datetimepicker" data-date="{x2;date:TIME,'Y-m-d'}" data-date-format="yyyy-mm-dd" type="text" name="search[stime]" size="10" id="stime" value="{x2;$search['stime']}"/> - <input class="form-control datetimepicker" data-date="{x2;date:TIME,'Y-m-d'}" data-date-format="yyyy-mm-dd" size="10" type="text" name="search[etime]" id="etime" value="{x2;$search['etime']}"/>
                                </td>
                                <td style="border-top:0px;">
                                    试题类型：
                                </td>
                                <td style="border-top:0px;">
                                    <select name="search[questiontype]" class="form-control">
                                          <option value="0">类型不限</option>
                                          {x2;tree:$questypes,questype,qid}
                                          <option value="{x2;v:questype['questid']}">{x2;v:questype['questype']}</option>
                                          {x2;endtree}
                                      </select>
                                </td>
                                <td style="border-top:0px;">
                                    难度：
                                </td>
                                <td style="border-top:0px;">
                                    <select name="search[questionlevel]" class="form-control">
                                          <option value="0">难度不限</option>
                                        <option value="1"{x2;if:$search['questionlevel'] == 1} checked{x2;endif}>易</option>
                                        <option value="2"{x2;if:$search['questionlevel'] == 2} checked{x2;endif}>中</option>
                                        <option value="3"{x2;if:$search['questionlevel'] == 3} checked{x2;endif}>难</option>
                                      </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    逻辑主线：
                                </td>
                                <td>
                                    <select name="search[questionsubjectid]" class="combox form-control" target="sectionselect" refUrl="?exam-master-questions-ajax-getsectionsbysubjectid&subjectid={value}">
                                        <option value="0">选择逻辑主线</option>
                                          {x2;tree:$subjects,subject,sid}
                                          <option value="{x2;v:subject['subjectid']}"{x2;if:v:subject['subjectid'] == $search['questionsubjectid']} selected{x2;endif}>{x2;v:subject['subject']}</option>
                                          {x2;endtree}
                                      </select>
                                </td>
                                <td>
                                    章节：
                                </td>
                                <td>
                                      <select name="search[questionsectionid]" class="combox form-control" id="sectionselect" target="knowsselect" refUrl="?exam-master-questions-ajax-getknowsbysectionid&sectionid={value}">
                                      <option value="0">选择章节</option>
                                      {x2;if:$sections}
                                      {x2;tree:$sections,section,sid}
                                      <option value="{x2;v:section['sectionid']}"{x2;if:v:section['sectionid'] == $search['questionsectionid']} selected{x2;endif}>{x2;v:section['section']}</option>
                                      {x2;endtree}
                                      {x2;endif}
                                      </select>
                                </td>
                                <td>
                                    知识点：
                                </td>
                                <td>
                                      <select name="search[questionknowsid]" id="knowsselect" class="form-control">
                                          <option value="">选择知识点</option>
                                          {x2;if:$knows}
                                          {x2;tree:$knows,know,kid}
                                          <option value="{x2;v:know['knowsid']}"{x2;if:v:know['knowsid'] == $search['questionknowsid']} selected{x2;endif}>{x2;v:know['knows']}</option>
                                          {x2;endtree}
                                          {x2;endif}
                                      </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    录入人：
                                </td>
                                <td>
                                    <input class="form-control" name="search[username]" size="10" type="text" value="{x2;$search['username']}"/>
                                </td>

                                <td>
                                    <button class="btn btn-primary" type="submit">删除</button>
                                    <input type="hidden" value="1" name="search[argsmodel]" />
                                </td>
                                <td colspan="4"></td>
                            </tr>
                        </table>
                    </form>
                    <h4 class="title" style="padding:10px;">
                        批量删除题冒题
                    </h4>
                    <form action="index.php?exam-master-tools-clearquestionrows" method="post" id="qrtool">
                        <table class="table form-inline">
                            <tr>
                                <td style="border-top:0px;">
                                    录入时间：
                                </td>
                                <td style="border-top:0px;">
                                    <input class="form-control datetimepicker" data-date="{x2;date:TIME,'Y-m-d'}" data-date-format="yyyy-mm-dd" type="text" name="search[stime]" size="10" id="stime" value="{x2;$search['stime']}"/> - <input class="form-control datetimepicker" data-date="{x2;date:TIME,'Y-m-d'}" data-date-format="yyyy-mm-dd" size="10" type="text" name="search[etime]" id="etime" value="{x2;$search['etime']}"/>
                                </td>
                                <td style="border-top:0px;">
                                    试题类型：
                                </td>
                                <td style="border-top:0px;">
                                    <select name="search[questiontype]" class="form-control">
                                          <option value="0">类型不限</option>
                                          {x2;tree:$questypes,questype,qid}
                                          <option value="{x2;v:questype['questid']}">{x2;v:questype['questype']}</option>
                                          {x2;endtree}
                                      </select>
                                </td>
                                <td style="border-top:0px;">
                                    难度：
                                </td>
                                <td style="border-top:0px;">
                                    <select name="search[qrlevel]" class="form-control">
                                          <option value="0">难度不限</option>
                                        <option value="1"{x2;if:$search['qrlevel'] == 1} selected{x2;endif}>易</option>
                                        <option value="2"{x2;if:$search['qrlevel'] == 2} selected{x2;endif}>中</option>
                                        <option value="3"{x2;if:$search['qrlevel'] == 3} selected{x2;endif}>难</option>
                                      </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    逻辑主线：
                                </td>
                                <td>
                                    <select name="search[questionsubjectid]" class="combox form-control" target="qrsectionselect" refUrl="?exam-master-questions-ajax-getsectionsbysubjectid&subjectid={value}">
                                    <option value="0">选择逻辑主线</option>
                                      {x2;tree:$subjects,subject,sid}
                                      <option value="{x2;v:subject['subjectid']}"{x2;if:v:subject['subjectid'] == $search['questionsubjectid']} selected{x2;endif}>{x2;v:subject['subject']}</option>
                                      {x2;endtree}
                                      </select>
                                </td>
                                <td>
                                    章节：
                                </td>
                                <td>
                                      <select name="search[questionsectionid]" class="combox form-control" id="qrsectionselect" target="qrknowsselect" refUrl="?exam-master-questions-ajax-getknowsbysectionid&sectionid={value}">
                                      <option value="0">选择章节</option>
                                      {x2;if:$sections}
                                      {x2;tree:$sections,section,sid}
                                      <option value="{x2;v:section['sectionid']}"{x2;if:v:section['sectionid'] == $search['questionsectionid']} selected{x2;endif}>{x2;v:section['section']}</option>
                                      {x2;endtree}
                                      {x2;endif}
                                      </select>
                                </td>
                                <td>
                                    知识点：
                                </td>
                                <td>
                                      <select name="search[questionknowsid]" id="qrknowsselect" class="form-control">
                                          <option value="">选择知识点</option>
                                          {x2;if:$knows}
                                          {x2;tree:$knows,know,kid}
                                          <option value="{x2;v:know['knowsid']}"{x2;if:v:know['knowsid'] == $search['questionknowsid']} selected{x2;endif}>{x2;v:know['knows']}</option>
                                          {x2;endtree}
                                          {x2;endif}
                                      </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    录入人：
                                </td>
                                <td>
                                    <input class="form-control" name="search[username]" size="10" type="text" value="{x2;$search['username']}"/>
                                </td>
                                <td>
                                    <button class="btn btn-primary" type="submit">删除</button>
                                    <input type="hidden" value="1" name="search[argsmodel]" />
                                </td>
                                <td colspan="4"></td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
