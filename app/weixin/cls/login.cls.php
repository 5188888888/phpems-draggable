<?php

class login_weixin
{
    public $G;

    public function __construct(&$G)
    {
        $this->G = $G;
    }

    public function _init()
    {
        $this->pdosql = $this->G->make('pdosql');
        $this->db = $this->G->make('pepdo');
    }

    public function addLogin($args)
    {
        return $this->db->insertElement(['table' => 'wxlogin', 'query' => $args]);
    }

    public function delLogin($wxsid)
    {
        return $this->db->delElement(['table' => 'wxlogin', 'query' => [['AND', 'wxsid = :wxsid', 'wxsid', $wxsid]]]);
    }

    public function getLogin($wxsid)
    {
        $data = [false, 'wxlogin', [['AND', 'wxsid = :wxsid', 'wxsid', $wxsid]]];
        $sql = $this->pdosql->makeSelect($data);

        return $this->db->fetch($sql, 'wxinfo');
    }
}
