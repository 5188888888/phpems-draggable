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
        $ordersn = $this->ev->get('ordersn');
        $this->order = $this->G->make('orders', 'bank');
        $order = $this->order->getOrderById($ordersn);
        $this->tpl->assign('order', $order);
        $this->tpl->display('payfor_status');
    }
}
