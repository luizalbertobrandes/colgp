-- =====================================================
-- BANCO DE DADOS - ANÁLISE DE CARGOS
-- Plataforma Educacional para Análise e Descrição de Cargos
-- =====================================================

-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABELA: profiles (perfis de usuários)
-- =====================================================
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABELA: companies (empresas)
-- =====================================================
CREATE TABLE companies (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  cnpj TEXT,
  segment TEXT,
  address TEXT,
  city TEXT,
  state TEXT,
  responsible_name TEXT,
  responsible_position TEXT,
  phone TEXT,
  email TEXT,
  observations TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABELA: positions (cargos)
-- =====================================================
CREATE TABLE positions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  code TEXT,
  sector TEXT,
  department TEXT,
  immediate_superior TEXT,
  num_occupants INTEGER DEFAULT 1,
  work_location TEXT,
  work_schedule TEXT,
  work_hours TEXT,
  bond_type TEXT,
  salary_range TEXT,
  minimum_education TEXT,
  required_experience TEXT,
  objective TEXT,
  main_responsibilities TEXT,
  activities TEXT,
  technical_competencies TEXT,
  behavioral_competencies TEXT,
  required_knowledge TEXT,
  required_skills TEXT,
  expected_attitudes TEXT,
  equipment_used TEXT,
  systems_used TEXT,
  occupational_risks TEXT,
  ppe_used TEXT,
  observations TEXT,
  status TEXT DEFAULT 'Não iniciada',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABELA: interviews (entrevistas)
-- =====================================================
CREATE TABLE interviews (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  position_id UUID REFERENCES positions(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  interview_date DATE,
  interviewee_name TEXT,
  interviewee_position TEXT,
  interviewer_name TEXT,
  time_at_company TEXT,
  interview_objective TEXT,
  interview_location TEXT,
  general_observations TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABELA: interview_questions (perguntas da entrevista)
-- =====================================================
CREATE TABLE interview_questions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  interview_id UUID REFERENCES interviews(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  question_text TEXT NOT NULL,
  answer_text TEXT,
  is_default BOOLEAN DEFAULT false,
  question_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABELA: questionnaires (questionários)
-- =====================================================
CREATE TABLE questionnaires (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  position_id UUID REFERENCES positions(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  questionnaire_date DATE,
  respondent_name TEXT,
  respondent_position TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABELA: questionnaire_questions (perguntas do questionário)
-- =====================================================
CREATE TABLE questionnaire_questions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  questionnaire_id UUID REFERENCES questionnaires(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  question_text TEXT NOT NULL,
  question_type TEXT NOT NULL DEFAULT 'text',
  options JSONB,
  answer_value TEXT,
  is_default BOOLEAN DEFAULT false,
  question_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABELA: observations (observações)
-- =====================================================
CREATE TABLE observations (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  position_id UUID REFERENCES positions(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  observation_date DATE,
  start_time TIME,
  end_time TIME,
  observer_name TEXT,
  observation_location TEXT,
  observed_activity TEXT,
  activity_frequency TEXT,
  approximate_duration TEXT,
  equipment_used TEXT,
  systems_used TEXT,
  people_involved TEXT,
  necessary_communication TEXT,
  movements_performed TEXT,
  environmental_conditions TEXT,
  identified_risks TEXT,
  ppe_used TEXT,
  observed_difficulties TEXT,
  observed_behaviors TEXT,
  activity_result TEXT,
  general_observations TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABELA: observation_activities (atividades observadas)
-- =====================================================
CREATE TABLE observation_activities (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  observation_id UUID REFERENCES observations(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  activity_name TEXT NOT NULL,
  frequency TEXT,
  duration TEXT,
  complexity_level TEXT,
  equipment_used TEXT,
  system_used TEXT,
  expected_result TEXT,
  observations TEXT,
  activity_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABELA: position_consolidations (consolidação dos métodos)
-- =====================================================
CREATE TABLE position_consolidations (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  position_id UUID REFERENCES positions(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  category TEXT NOT NULL,
  interview_data TEXT,
  questionnaire_data TEXT,
  observation_data TEXT,
  conclusion TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABELA: position_final_descriptions (descrição final)
-- =====================================================
CREATE TABLE position_final_descriptions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  position_id UUID REFERENCES positions(id) ON DELETE CASCADE UNIQUE NOT NULL,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  mission TEXT,
  responsibilities TEXT,
  main_activities TEXT,
  requirements TEXT,
  competencies TEXT,
  working_conditions TEXT,
  equipment TEXT,
  systems TEXT,
  risks TEXT,
  expected_results TEXT,
  relationships TEXT,
  final_observations TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- ÍNDICES
-- =====================================================
CREATE INDEX idx_companies_user_id ON companies(user_id);
CREATE INDEX idx_positions_company_id ON positions(company_id);
CREATE INDEX idx_positions_user_id ON positions(user_id);
CREATE INDEX idx_interviews_position_id ON interviews(position_id);
CREATE INDEX idx_interviews_user_id ON interviews(user_id);
CREATE INDEX idx_interview_questions_interview_id ON interview_questions(interview_id);
CREATE INDEX idx_questionnaires_position_id ON questionnaires(position_id);
CREATE INDEX idx_questionnaires_user_id ON questionnaires(user_id);
CREATE INDEX idx_questionnaire_questions_questionnaire_id ON questionnaire_questions(questionnaire_id);
CREATE INDEX idx_observations_position_id ON observations(position_id);
CREATE INDEX idx_observations_user_id ON observations(user_id);
CREATE INDEX idx_observation_activities_observation_id ON observation_activities(observation_id);
CREATE INDEX idx_position_consolidations_position_id ON position_consolidations(position_id);
CREATE INDEX idx_position_final_descriptions_position_id ON position_final_descriptions(position_id);

-- =====================================================
-- FUNÇÃO: Atualizar updated_at automaticamente
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- =====================================================
-- TRIGGERS: Atualizar updated_at
-- =====================================================
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_companies_updated_at BEFORE UPDATE ON companies FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_positions_updated_at BEFORE UPDATE ON positions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_interviews_updated_at BEFORE UPDATE ON interviews FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_interview_questions_updated_at BEFORE UPDATE ON interview_questions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_questionnaires_updated_at BEFORE UPDATE ON questionnaires FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_questionnaire_questions_updated_at BEFORE UPDATE ON questionnaire_questions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_observations_updated_at BEFORE UPDATE ON observations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_observation_activities_updated_at BEFORE UPDATE ON observation_activities FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_position_consolidations_updated_at BEFORE UPDATE ON position_consolidations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_position_final_descriptions_updated_at BEFORE UPDATE ON position_final_descriptions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- FUNÇÃO: Criar perfil automaticamente após registro
-- =====================================================
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, full_name, email)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.email);
  RETURN NEW;
END;
$$ language 'plpgsql' SECURITY DEFINER;

-- =====================================================
-- TRIGGER: Criar perfil após signup
-- =====================================================
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- =====================================================
-- RLS - ROW LEVEL SECURITY
-- =====================================================

-- Habilitar RLS em todas as tabelas
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE positions ENABLE ROW LEVEL SECURITY;
ALTER TABLE interviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE interview_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE questionnaires ENABLE ROW LEVEL SECURITY;
ALTER TABLE questionnaire_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE observations ENABLE ROW LEVEL SECURITY;
ALTER TABLE observation_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE position_consolidations ENABLE ROW LEVEL SECURITY;
ALTER TABLE position_final_descriptions ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- POLICIES: profiles
-- =====================================================
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- =====================================================
-- POLICIES: companies
-- =====================================================
CREATE POLICY "Users can view own companies" ON companies
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own companies" ON companies
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own companies" ON companies
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own companies" ON companies
  FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- POLICIES: positions
-- =====================================================
CREATE POLICY "Users can view own positions" ON positions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own positions" ON positions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own positions" ON positions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own positions" ON positions
  FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- POLICIES: interviews
-- =====================================================
CREATE POLICY "Users can view own interviews" ON interviews
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own interviews" ON interviews
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own interviews" ON interviews
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own interviews" ON interviews
  FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- POLICIES: interview_questions
-- =====================================================
CREATE POLICY "Users can view own interview_questions" ON interview_questions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own interview_questions" ON interview_questions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own interview_questions" ON interview_questions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own interview_questions" ON interview_questions
  FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- POLICIES: questionnaires
-- =====================================================
CREATE POLICY "Users can view own questionnaires" ON questionnaires
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own questionnaires" ON questionnaires
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own questionnaires" ON questionnaires
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own questionnaires" ON questionnaires
  FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- POLICIES: questionnaire_questions
-- =====================================================
CREATE POLICY "Users can view own questionnaire_questions" ON questionnaire_questions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own questionnaire_questions" ON questionnaire_questions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own questionnaire_questions" ON questionnaire_questions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own questionnaire_questions" ON questionnaire_questions
  FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- POLICIES: observations
-- =====================================================
CREATE POLICY "Users can view own observations" ON observations
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own observations" ON observations
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own observations" ON observations
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own observations" ON observations
  FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- POLICIES: observation_activities
-- =====================================================
CREATE POLICY "Users can view own observation_activities" ON observation_activities
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own observation_activities" ON observation_activities
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own observation_activities" ON observation_activities
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own observation_activities" ON observation_activities
  FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- POLICIES: position_consolidations
-- =====================================================
CREATE POLICY "Users can view own position_consolidations" ON position_consolidations
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own position_consolidations" ON position_consolidations
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own position_consolidations" ON position_consolidations
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own position_consolidations" ON position_consolidations
  FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- POLICIES: position_final_descriptions
-- =====================================================
CREATE POLICY "Users can view own position_final_descriptions" ON position_final_descriptions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own position_final_descriptions" ON position_final_descriptions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own position_final_descriptions" ON position_final_descriptions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own position_final_descriptions" ON position_final_descriptions
  FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================
