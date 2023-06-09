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
                            <li><a href="index.php?core-master">全局</a></li>
                            <li class="active">模块管理</li>
                        </ol>
                    </div>
                </div>
                <div class="box itembox" style="padding-top:20px;margin-bottom:0px;">
                    <h4 class="title">
                        模块管理
                    </h4>
                    <table class="table table-bordered table-hover">
                        <thead>
                            <tr class="info">
                                <th>
                                    模块标识
                                </th>
                                <th>
                                    模块名称
                                </th>
                                <th>
                                    状态
                                </th>
                                <th width="80">
                                    操作
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            {x2;tree:$localapps['dir'],lapp,aid}
                            <tr>
                                <td>{x2;v:lapp['name']}</td>
                                <td>
                                    {x2;if:$apps[v:lapp['name']]}{x2;$apps[v:lapp['name']]['appname']}{x2;else}未设置{x2;endif}
                                </td>
                                <td>
                                    {x2;if:$apps[v:lapp['name']]['appstatus']}正常{x2;else}禁用{x2;endif}
                                </td>
                                <td class="text-center">
                                    <a class="btn" href="index.php?core-master-apps-config&appid={x2;v:lapp['name']}"><em class="glyphicon glyphicon-cog"></em></a>
                                </td>
                            </tr>
                            {x2;endtree}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
