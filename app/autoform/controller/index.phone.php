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

    private function test()
    {
        $this->tpl->display('test');
    }

    private function index()
    {
        $catids = [];
        $catids['index'] = $this->category->getCategoriesByArgs([['AND', 'catindex > 0']]);
        $contents = [];
        if ($catids['index']) {
            foreach ($catids['index'] as $p) {
                $catstring = $this->category->getChildCategoryString($p['catid']);
                $contents[$p['catid']] = $this->content->getContentList([['AND', 'find_in_set(contentcatid,:catstring)', 'catstring', $catstring]], 1, $p['catindex'] ? $p['catindex'] : 10);
            }
        }
        $this->category->app = 'course';
        $coursecats = $this->category->getCategoriesByArgs([['AND', "catparent = '0'"]]);
        $topcourse = [];
        foreach ($coursecats as $cat) {
            $catstring = $this->category->getChildCategoryString($cat['catid']);
            $topcourse[$cat['catid']] = $this->course->getCourseList([['AND', 'find_in_set(cscatid,:cscatid)', 'cscatid', $catstring]], 1, 6);
        }
        $this->tpl->assign('topcourse', $topcourse);
        $courses = $this->course->getCourseList(1, 1, 8);
        $basic = $this->G->make('basic', 'exam');
        $basics = $basic->getBestBasics();
        $this->tpl->assign('coursecats', $coursecats);
        $this->tpl->assign('courses', $courses);
        $this->tpl->assign('basics', $basics);
        $this->tpl->assign('contents', $contents);
        $this->tpl->display('index');
    }
}
