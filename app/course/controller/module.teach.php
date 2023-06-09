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

    private function moduleforms()
    {
        $moduleid = $this->ev->get('moduleid');
        $fields = $this->module->getMoudleFields($moduleid, -1);
        $forms = $this->html->buildHtml($fields);
        $this->tpl->assign('fields', $fields);
        $this->tpl->assign('forms', $forms);
        $this->tpl->display('preview_ajax');
    }

    private function index()
    {
    }
}
