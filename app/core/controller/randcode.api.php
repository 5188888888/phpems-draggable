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
        header('Content-type: image/png');
        $rand = $this->session->setRandCode($rand);
        echo $this->files->createRandImage($rand, 100, 42);
    }
}
