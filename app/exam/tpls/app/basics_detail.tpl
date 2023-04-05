{x2;include:header}
<body>
<div class="container-fluid">
    <div class="row-fluid">
        <div class="pages">
            {x2;include:nav}
            <div class="content">
                <div class="col-xs-9">
                    <div class="content-box padding">
                        <h2 class="title">开通考场</h2>
                        <ul class="list-img list-unstyled">
                            <li class="border morepadding">
                                <h4 class="shorttitle">{x2;$basic['basic']}</h4>
                                <div class="intro">
                                    <div class="col-xs-3 img">
                                        <img src="{x2;if:$basic['basicthumb']}{x2;$basic['basicthumb']}{x2;else}app/exam/styles/image/paper.png{x2;endif}" />
                                    </div>
                                    <div class="desc">
                                        <p>{x2;$basic['basicdescribe']}</p>
                                        <div class="toolbar">
                                            {x2;if:$isopen}
                                            <a class="btn btn-info pull-right more ajax" href="index.php?exam-app-index-setCurrentBasic&basicid={x2;$basic['basicid']}">进入考场</a>
                                            {x2;else}
                                            {x2;if:$allowopen}
                                            {x2;if:$basic['basicdemo']}
                                            <a class="btn btn-info pull-right more confirm" msg="确定要开通吗？" href="index.php?exam-app-basics-openit&basicid={x2;$basic['basicid']}">免费开通</a>
                                            {x2;else}
                                            {x2;if:$price}
                                            选择要开通的时长
                                            <div class="more">
                                                {x2;tree:$price,p,pid}
                                                <a class="btn btn-primary confirm" msg="确定要开通吗？" href="index.php?exam-app-basics-openit&basicid={x2;$basic['basicid']}&opentype={x2;v:key}">{x2;v:p['price']}积分兑换{x2;v:p['time']}天</a>
                                                {x2;endtree}
                                            </div>
                                                {x2;else}
                                                <a class="btn btn-default pull-right more" href="javascript:;">请管理员设置考场价格</a>
                                                {x2;endif}
                                            {x2;endif}
                                            {x2;else}
                                            <a class="btn btn-default pull-right more" href="javascript:;">您所在的用户组不能开通本考场</a>
                                            {x2;endif}
                                            {x2;endif}
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="col-xs-3 nopadding">
                    <div class="content-box padding">
                        <h2 class="title">最新考场<a href="index.php?exam-app-basics-open" class="badge pull-right">更多 <em class="glyphicon glyphicon-plus"></em> </a> </h2>
                        <ul class="list-unstyled list-img">
                            {x2;tree:$news,basic,bid}
                            <li class="border padding">
                                <a href="index.php?{x2;$_app}-app-index-setCurrentBasic&basicid={x2;v:basic['basicid']}" class="ajax">
                                    <div class="intro">
                                        <div class="col-xs-5 img noleftpadding">
                                            <img src="{x2;if:v:basic['basicthumb']}{x2;v:basic['basicthumb']}{x2;else}app/core/styles/img/item.jpg{x2;endif}" />
                                        </div>
                                        <div class="desc">
                                            <p>{x2;v:basic['basic']}</p>
                                        </div>
                                    </div>
                                </a>
                            </li>
                            {x2;endtree}
                        </ul>
                    </div>
                </div>
            </div>
            
        </div>
    </div>
</div>
</body>
</html>
