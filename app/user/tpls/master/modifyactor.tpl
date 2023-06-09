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
                            <li><a href="index.php?user-master-actor">用户组管理</a></li>
                            <li class="active">修改用户组</li>
                        </ol>
                    </div>
                </div>
                <div class="box itembox" style="padding-top:10px;margin-bottom:0px;">
                    <h4 class="title" style="padding:10px;">
                        修改用户组
                        <a class="pull-right btn btn-primary" href="index.php?user-master-actor">用户组列表</a>
                    </h4>
                    <form action="index.php?user-master-actor-modifyactor" method="post" class="form-horizontal">
                        <fieldset>
                            <div class="form-group">
                            </div>
                            <div class="form-group">
                                <label for="groupname" class="control-label col-sm-2">用户组名</label>
                                <div class="col-sm-6">
                                    <input class="form-control" name="args[groupname]" type="text" value="{x2;$group['groupname']}" id="groupname" size="25" needle="needle" maxlength="40" msg="请输入用户组名称" />
                                    <span class="help-block">请输入用户组名称</span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="groupdescribe" class="control-label col-sm-2">用户组描述</label>
                                <div class="col-sm-9">
                                    <textarea class="form-control" rows="7" id="groupdescribe" name="args[groupdescribe]">{x2;$group['groupdescribe']}</textarea>
                                    <span class="help-block">对这个用户组进行描述</span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-2"></label>
                                <div class="col-sm-8">
                                    <button class="btn btn-primary" type="submit">提交</button>
                                    <input type="hidden" name="groupid" value="{x2;$group['groupid']}"/>
                                    <input type="hidden" name="modifyactor" value="1"/>
                                    <input type="hidden" name="page" value="{x2;$page}"/>
                                    {x2;if:is_array($search)}{x2;tree:$search,arg,aid}
                                    <input type="hidden" name="search[{x2;v:key}]" value="{x2;v:arg}"/>
                                    {x2;endtree}{x2;endif}
                            </div>
                        </fieldset>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
