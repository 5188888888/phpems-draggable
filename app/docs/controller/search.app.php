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
        $page = $this->ev->get('page');
        $keyword = $this->ev->get('keyword');
        $docs = $this->doc->getDocList([['AND', 'doctitle LIKE :doctitle', 'doctitle', "%{$keyword}%"]], $page);
        $this->tpl->assign('page', $page);
        $this->tpl->assign('docs', $docs);
        $this->tpl->display('search_default');
    }
}
