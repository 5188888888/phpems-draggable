<div class="topbar">
    <div class="topbar-box">
        <div class="col-xs-4">
            <ul class="list-unstyled list-inline"><li class="menu">在线考试系统</li></ul>
        </div>
        <div class="col-xs-8">
            <ul class="list-unstyled list-inline text-right">
                {x2;if:$_user['userid']}
                <li>
                    <span class="menu">欢迎您，{x2;$_user['username']}</span>
                </li>
                <li>|</li>
                <li>
                    <a href="index.php?user-center" class="menu">
                        个人中心
                    </a>
                </li>
                <li>|</li>
                <li>
                    <a href="index.php?user-app-logout" class="menu ajax">
                        退出
                    </a>
                </li>
                {x2;else}
                <li>
                    <a href="javascript:;" onclick="javascript:$.loginbox.show();" class="menu">
                        登陆
                    </a>
                </li>
                <li>|</li>
                <li>
                    <a href="index.php?user-app-register" class="menu">
                        注册
                    </a>
                </li>
                <li>|</li>
                <li>
                    <a href="index.php?user-app-register-findpassword" class="menu">
                        忘记密码
                    </a>
                </li>
                {x2;endif}
            </ul>
        </div>
    </div>
</div>
<div class="header">
    <div class="nav">
        <div class="col-xs-3">
            <h1 class="logo"></h1>
        </div>
        <div class="col-xs-9">
            <ul class="list-unstyled list-inline">
                <li>
                    <a href="index.php" class="menu">
                        首页
                    </a>
                </li>
                <li>
                    <a href="index.php?content" class="menu">
                        新闻
                    </a>
                </li>
                <li>
                    <a href="index.php?seminar" class="menu">
                        专题
                    </a>
                </li>
                <li>
                    <a href="index.php?course" class="menu">
                        课程
                    </a>
                </li>
                <li>
                    <a href="index.php?exam" class="menu">
                        考试
                    </a>
                </li>
                <li>
                    <a href="index.php?docs" class="menu">
                        文档
                    </a>
                </li>
            </ul>
        </div>
    </div>
</div>
