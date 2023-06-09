<?php

class action extends app
{
    public function display()
    {
        if ($this->ev->isMobile()) {
            header('location:index.php?content-phone');
            exit;
        }
        $this->position = $this->G->make('position', 'content');
        $action = $this->ev->url(3);
        if (!method_exists($this, $action)) {
            $action = 'index';
        }
        $this->$action();
        exit;
    }

    private function index()
    {
        $catids = $this->category->getCategoriesByArgs([['AND', 'catinmenu = 0'], ['AND', "catapp = 'content'"], ['AND', 'catparent = 0']]);
        $contents = [];
        if ($catids) {
            foreach ($catids as $p) {
                if ($p['catindex']) {
                    $catstring = $this->category->getChildCategoryString($p['catid']);
                    $contents[$p['catid']] = $this->content->getContentList([['AND', 'find_in_set(contentcatid,:catstring)', 'catstring', $catstring]], 1, $p['catindex'] ? $p['catindex'] : 10);
                }
            }
        }
        $topseminars = $this->position->getPosSeminarList([['AND', 'pcposid = 3']], 1, 10);
        $this->tpl->assign('topseminars', $topseminars);
        $this->tpl->assign('categories', $this->category->categories);
        $this->tpl->assign('contents', $contents);
        $this->tpl->assign('catids', $catids);
        $this->tpl->display('index');
    }
}
