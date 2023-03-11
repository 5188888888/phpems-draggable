{x2;if:!$userhash}
{x2;include:header}
<body>
<div class="pages">
    {x2;endif}
    <div class="page-tabs">
        <div class="page-header">
            <div class="col-1" onclick="javascript:history.back();"><span class="iconfont icon-left"></span></div>
            <div class="col-8">视频课程</div>
            <div class="col-1">
                <span class="iconfont icon-menu"></span>
            </div>
        </div>
        <div class="page-content header">
            {x2;tree:$catids,cat,cid}
            <div class="list-box bg">
                <ol>
                    <li class="unstyled">
                        <a href="index.php?course-phone-category&catid={x2;v:cat['catid']}" class="ajax">
                            <h4 class="bigtitle">
                                {x2;v:cat['catname']}
                                <span class="pull-right iconfont icon-right"></span>
                            </h4>
                        </a>
                    </li>
                    {x2;tree:$contents[v:cat['catid']]['data'],content,cid}
                    <li class="unstyled">
                        <div class="col-4x">
                            <div class="rows illus">
                                <a href="index.php?{x2;$_app}-phone-course&csid={x2;v:content['csid']}" class="ajax">
                                    <img src="{x2;if:v:content['csthumb']}{x2;v:content['csthumb']}{x2;else}files/public/img/paper.jpg{x2;endif}">
                                </a>
                            </div>
                        </div>
                        <div class="col-4l">
                            <a href="index.php?{x2;$_app}-phone-course&csid={x2;v:content['csid']}" class="ajax">
                                <div class="rows info">
                                    <h5 class="title">{x2;v:content['cstitle']}</h5>
                                    <p class="intro">{x2;substring:v:content['csdescribe'],42}</p>
                                </div>
                            </a>
                        </div>
                    </li>
                    {x2;endtree}
                </ol>
            </div>
            {x2;endtree}
        </div>
    </div>
    {x2;if:!$userhash}
</div>
</body>
</html>
{x2;endif}
