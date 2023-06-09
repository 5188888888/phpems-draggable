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

    private function clearexamsession()
    {
        $sessionvars = $this->exam->getExamSessionByUserid($this->_user['sessionuserid'], $this->data['currentbasic']['basicid']);
        $this->exam->delExamSession($sessionvars['examsessionid']);
        $message = [
            'statusCode'   => 200,
            'message'      => '操作成功，正在刷新考试页面',
            'callbackType' => 'forward',
            'forwardUrl'   => 'reload',
        ];
        $this->G->R($message);
    }

    private function index()
    {
        $sessionvars = $this->exam->getExamSessionByUserid($this->_user['sessionuserid'], $this->data['currentbasic']['basicid']);
        if ($sessionvars && $sessionvars['examsessionbasic'] == $this->_user['sessioncurrent'] && $sessionvars['examsessionstatus'] < 2 && 2 == $sessionvars['examsessiontype'] && ($sessionvars['examsessionstarttime'] + $sessionvars['examsessiontime'] * 60 - TIME)) {
            if ($sessionvars['examsessionid'] != $this->_user['sessionid']) {
                $this->exam->delExamSession();
                $this->exam->modifyExamSession(['examsessionid' => $this->_user['sessionid']], $sessionvars['examsessionid']);
            }
            $message = [
                'statusCode'   => 200,
                'message'      => '恢复成功，正在转向考试页面',
                'callbackType' => 'forward',
                'forwardUrl'   => 'index.php?exam-app-exam-paper',
            ];
        } else {
            $message = [
                'statusCode' => 300,
                'message'    => '恢复失败，考试已经结束',
            ];
        }
        $this->G->R($message);
    }
}
