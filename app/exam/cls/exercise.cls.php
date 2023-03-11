<?php

class exercise_exam
{
    public $G;

    public function __construct(&$G)
    {
        $this->G = $G;
        $this->pdosql = $this->G->make('pdosql');
        $this->db = $this->G->make('pepdo');
        $this->ev = $this->G->make('ev');
    }

    //根据参数查询
    public function getExerciseProcessByUser($userid, $basicid, $knowsid = null)
    {
        if ($knowsid) {
            $data = [false, 'exercise', [['AND', 'exeruserid = :exeruserid', 'exeruserid', $userid], ['AND', 'exerbasicid = :exerbasicid', 'exerbasicid', $basicid], ['AND', 'exerknowsid = :exerknowsid', 'exerknowsid', $knowsid]]];
            $sql = $this->pdosql->makeSelect($data);

            return $this->db->fetch($sql);
        }

        $data = [false, 'exercise', [['AND', 'exeruserid = :exeruserid', 'exeruserid', $userid], ['AND', 'exerbasicid = :exerbasicid', 'exerbasicid', $basicid]], false, false, false];
        $sql = $this->pdosql->makeSelect($data);

        return $this->db->fetchAll($sql, 'exerknowsid');
    }

    public function setExercise($args)
    {
        $userid = $args['exeruserid'];
        $basicid = $args['exerbasicid'];
        $knowsid = $args['exerknowsid'];
        $r = $this->getExerciseProcessByUser($userid, $basicid, $knowsid);
        if ($r) {
            $data = ['exercise', $args, [['AND', 'exerid = :exerid', 'exerid', $r['exerid']]]];
            $sql = $this->pdosql->makeUpdate($data);
            $this->db->exec($sql);
        } else {
            $data = ['exercise', $args];
            $sql = $this->pdosql->makeInsert($data);
            $this->db->exec($sql);
        }

        return true;
    }
}
