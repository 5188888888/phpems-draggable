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

    private function lists()
    {
        $catids = [];
        $catids = $this->category->getCategoriesByArgs([['AND', "catinmenu = '0'"], ['AND', "catapp = 'course'"], ['AND', 'catparent = 0']]);
        $contents = [];
        if ($catids) {
            foreach ($catids as $p) {
                $catstring = $this->category->getChildCategoryString($p['catid']);
                $contents[$p['catid']] = $this->course->getCourseList([['AND', 'find_in_set(cscatid,:catstring)', 'catstring', $catstring]], 1, $p['catindex'] ? $p['catindex'] : 6);
            }
        }
        $coursesubjects = \Model\Coursesubject::inRandomOrder()->limit(6)->get()->toArray();
        $this->tpl->assign('news', $coursesubjects);
        $this->tpl->assign('catids', $catids);
        $this->tpl->assign('categories', $this->category->categories);
        $this->tpl->assign('contents', $contents);
        $this->tpl->display('index_lists');
    }

    private function index()
    {
        $page = $this->ev->get('page');
        $contents = $this->course->getOpenCourseListByUserid($this->_user['sessionuserid'], $page);
        $coursesubjects = \Model\Coursesubject::orderBy('csid', 'desc')->limit(5)->get()->toArray();
        $news = $this->course->getCourseList([], 1, 5);
        $this->tpl->assign('news', $news['data']);
        $this->tpl->assign('contents', $contents);
        $this->tpl->assign('news', $coursesubjects);
        $this->tpl->assign('page', $page);
        $this->tpl->display('index');
    }
}
