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

    public function index()
    {
        $page = $this->ev->get('page');
        $keyword = $this->ev->get('keyword');
        $contents = $this->content->getContentList([['AND', 'contenttitle LIKE :contenttitle', 'contenttitle', "%{$keyword}%"]], $page);
        $this->tpl->assign('page', $page);
        $this->tpl->assign('contents', $contents);
        $this->tpl->display('search_default');
    }
}
