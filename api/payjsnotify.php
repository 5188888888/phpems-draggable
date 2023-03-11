<?php

define('PEPATH', dirname(dirname(__FILE__)));
class app
{
    public $G;

    public function __construct(&$G)
    {
        $this->G = $G;
    }

    public function run()
    {
        //使用通用通知接口
        $this->G->make('payjs')->notify();
    }
}
include PEPATH.'/lib/init.cls.php';
$app = new app(new ginkgo());
$app->run();
