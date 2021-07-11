# frozen_string_literal: true
# 科目
subjects = [
  { name: '国語', classification: Subject::Classification::JUNIOR_HIGH_SCHOOL },
  { name: '数学', classification: Subject::Classification::JUNIOR_HIGH_SCHOOL },
  { name: '英語', classification: Subject::Classification::JUNIOR_HIGH_SCHOOL },
  { name: '理科', classification: Subject::Classification::JUNIOR_HIGH_SCHOOL },
  { name: '社会', classification: Subject::Classification::JUNIOR_HIGH_SCHOOL },
  { name: '音楽', classification: Subject::Classification::JUNIOR_HIGH_SCHOOL },
  { name: '美術', classification: Subject::Classification::JUNIOR_HIGH_SCHOOL },
  { name: '保健体育', classification: Subject::Classification::JUNIOR_HIGH_SCHOOL },
  { name: '技術家庭', classification: Subject::Classification::JUNIOR_HIGH_SCHOOL },
  { name: '現代文', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '古典', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '国語総合', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '数学I・A', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '数学II・B', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '数学III・C', classification: Subject::Classification::HIGH_SCHOOL },
  { name: 'コミュニケーション英語', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '英語表現', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '日本史', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '世界史', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '地理', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '現代社会', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '倫理', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '政治・経済', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '物理', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '化学', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '生物', classification: Subject::Classification::HIGH_SCHOOL },
  { name: '地学', classification: Subject::Classification::HIGH_SCHOOL }
]

subjects.each do |**args|
  Subject.find_or_create_by(args)
end
