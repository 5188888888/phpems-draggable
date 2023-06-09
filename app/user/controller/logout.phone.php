<?php

class action extends app
{
    public function display()
    {
        $action = $this->ev->url(3);
        if (!method_exists($this, $action)) {
            $action = 'index';
        }
        $this->$action();
        exit;
    }

    private function index()
    {
        $_SESSION['openid'] = null;
        $this->session->clearSessionUser();
        $message = [
            'statusCode'   => 201,
            'message'      => '操作成功',
            'callbackType' => 'forward',
            'forwardUrl'   => 'index.php?'.$this->G->defaultApp,
        ];
        $this->G->R($message);
    }
}
