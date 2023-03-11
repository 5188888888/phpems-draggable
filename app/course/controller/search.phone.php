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
        $contents = $this->course->getCourseList([['AND', 'cstitle LIKE :cstitle', 'cstitle', "%{$keyword}%"]], $page);
        $this->tpl->assign('contents', $contents);
        $this->tpl->display('search_default');
    }
}
