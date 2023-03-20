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
        echo 'Permission Denied';
    }

    private function query()
    {
        $data = $_POST['data'] ?? null;
        $type = strtolower($_POST['type'] ?? '');
        $questionid = $this->ev->get('questionid');
        if (!is_null($data) && (strtolower($_SERVER['REQUEST_METHOD']) === 'post')) {
            $args['questionanswer'] = $data;
            switch ($type) {
                case 'modify':
                    $this->exam->modifyQuestions($questionid, $args);
                    echo 'ok';
                break;

                case 'verify':
                case 'onlyquestion':
                    $question = $this->exam->getQuestionByArgs([['AND', 'questionid = :questionid', 'questionid', $questionid]]);

                    if ($type === 'onlyquestion') {
                        if ($question['questiontype'] !== '7') {
                            $result = ['message' => 'QuestionId 类型错误', 'status' => false];
                        } else {
                            $q = json_decode($question['questionanswer'], true);
                            foreach($q['to'] as $k => $item) {
                                $q['to'][$k]['value'] = null;
                            }
                            $result = ['message' => 'success', 'question' => $q, 'status' => true];
                        }
                    } else {
                        $answer = json_decode($question['questionanswer'] ?? '', true);
                        if (!is_null($answer)) {
                            $answer = $answer['to'];
                            $verified = [];
                            $correct = null;
                            foreach ($data as $item) {
                                $id = $item['id'];
                                $verified[$id] = ($item['value'] === $answer[$id]['value']);
                                $correct = ($correct === null) ? $verified[$id] : ($correct && $verified[$id]);
                            }
                            $result = ['message' => $verified, 'correct' => ($correct ? 'success' : 'wrong'), 'status' => true];
                        } else {
                            $result = ['message' => '数据为空, 无法校验', 'status' => false];
                        }
                    }
                    echo json_encode($result ?? ['message' => '无效的问题ID', 'status' => false], JSON_UNESCAPED_UNICODE);
                break;
                
                default:
                    echo 'Error';
                break;
            }
        } else {
            echo '非法请求';
        }
    }
}
