<?php

class action extends app
{
    public function display()
    {
        if (!$this->_user['sessionuserid']) {
            if ($this->ev->get('userhash')) {
                exit(json_encode([
                    'statusCode'   => 301,
                    'message'      => '请您重新登录',
                    'callbackType' => 'forward',
                    'forwardUrl'   => 'index.php?user-phone-login',
                ]));
            }

            header('location:index.php?user-phone-login');
            exit;
        }
        $action = $this->ev->url(3);
        if (!method_exists($this, $action)) {
            $action = 'index';
        }
        $this->$action();
        exit;
    }

    private function index()
    {
        $this->tpl->display('index');
    }
}
