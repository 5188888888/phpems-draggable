{x2;if:!$userhash}
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
{x2;endif}
                <div class="box itembox" style="margin-bottom:0px;border-bottom:1px solid #CCCCCC;">
                        <div class="col-xs-12">
                            <ol class="breadcrumb">
                                <li><a href="index.php?{x2;$_app}-master">{x2;$apps[$_app]['appname']}</a></li>
                                <li class="active">模型管理</li>
                            </ol>
                        </div>
                    </div>
                    <div class="box itembox" style="padding-top:10px;margin-bottom:0px;">
                        <h4 class="title" style="padding:10px;">
                            模型列表
                            <a class="pull-right btn btn-primary" href="index.php?{x2;$_app}-master-module-add">添加模型</a>
                        </h4>
                        <table class="table table-hover table-bordered">
                            <thead>
                                <tr class="info">
                                    <th>ID</th>
                                    <th>模型名称</th>
                                    <th>模型代码</th>
                                    <th>模型描述</th>
                                    <th width="180">操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                {x2;tree:$modules,module,mid}
                                <tr>
                                    <td>{x2;v:module['moduleid']}</td>
                                    <td>{x2;v:module['modulename']}</td>
                                    <td>{x2;v:module['modulecode']}</td>
                                    <td>{x2;v:module['moduledescribe']}</td>
                                    <td>
                                        <div class="btn-group">
                                            <a class="btn" href="index.php?{x2;$_app}-master-module-preview&moduleid={x2;v:module['moduleid']}&page={x2;$page}{x2;$u}" title="预览"><em class="glyphicon glyphicon-search"></em></a>
                                            <a class="btn" href="index.php?{x2;$_app}-master-module-fields&moduleid={x2;v:module['moduleid']}&page={x2;$page}{x2;$u}" title="字段管理"><em class="glyphicon glyphicon-cog"></em></a>
                                            <a class="btn" href="index.php?{x2;$_app}-master-module-modify&moduleid={x2;v:module['moduleid']}&page={x2;$page}{x2;$u}" title="修改模型信息"><em class="glyphicon glyphicon-edit"></em></a>
                                            <a class="btn ajax" href="index.php?{x2;$_app}-master-module-del&moduleid={x2;v:module['moduleid']}&page={x2;$page}{x2;$u}" title="删除模型"><em class="glyphicon glyphicon-remove"></em></a>
                                        </div>
                                    </td>
                                </tr>
                                {x2;endtree}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
{x2;if:!$userhash}
        </div>
    </div>
</div>
{x2;include:footer}
</body>
</html>
{x2;endif}
