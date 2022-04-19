-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 19-Abr-2022 às 22:46
-- Versão do servidor: 10.4.16-MariaDB
-- versão do PHP: 7.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `grupo08_condominios`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `selectAllCondominio` ()  BEGIN
       SELECT * FROM condominio;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `selectTipoAndTamanho` (IN `cTipo` VARCHAR(255), IN `cTamanho` INT)  BEGIN
       SELECT * FROM propriedade WHERE tipo = cTipo and tamanho_m2 = cTamanho;
  END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `administradora`
--

CREATE TABLE `administradora` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cidade` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `administradora`
--

INSERT INTO `administradora` (`id`, `nome`, `cidade`) VALUES
(2, 'Alberto Junior', 'cachoeirinha');

-- --------------------------------------------------------

--
-- Estrutura da tabela `condominio`
--

CREATE TABLE `condominio` (
  `condominio_id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cidade` varchar(50) NOT NULL,
  `administradora_id` int(11) NOT NULL,
  `quantidade_disponiveis` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `condominio`
--

INSERT INTO `condominio` (`condominio_id`, `nome`, `cidade`, `administradora_id`, `quantidade_disponiveis`) VALUES
(3, 'Valle ville', 'canoas', 2, 17),
(4, 'Valle do silicio', 'Gravatai', 2, 14);

-- --------------------------------------------------------

--
-- Estrutura da tabela `propriedade`
--

CREATE TABLE `propriedade` (
  `propriedade_id` int(11) NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `tamanho_m2` int(11) NOT NULL,
  `valor` float NOT NULL,
  `quartos` int(11) NOT NULL,
  `banheiros` int(11) NOT NULL,
  `condominio_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `propriedade`
--

INSERT INTO `propriedade` (`propriedade_id`, `tipo`, `tamanho_m2`, `valor`, `quartos`, `banheiros`, `condominio_id`) VALUES
(1, 'Casa', 30, 25000, 2, 1, 3),
(2, 'Casa', 40, 50000, 3, 2, 4);

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE `usuario` (
  `usuario_id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `sobrenome` varchar(50) NOT NULL,
  `condominio_id` int(11) NOT NULL,
  `propriedade_id` int(11) NOT NULL,
  `quantidade_propriedade` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Acionadores `usuario`
--
DELIMITER $$
CREATE TRIGGER `Trg_Qtd_propriedade` AFTER INSERT ON `usuario` FOR EACH ROW BEGIN
UPDATE condominio 
SET quantidade_disponiveis = quantidade_disponiveis - NEW.quantidade_propriedade
WHERE condominio_id = NEW.condominio_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Trg_Qtd_propriedade_Delete` AFTER DELETE ON `usuario` FOR EACH ROW BEGIN
UPDATE condominio 
SET quantidade_disponiveis = quantidade_disponiveis + OLD.quantidade_propriedade
WHERE condominio_id = OLD.condominio_id;
END
$$
DELIMITER ;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `administradora`
--
ALTER TABLE `administradora`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `condominio`
--
ALTER TABLE `condominio`
  ADD PRIMARY KEY (`condominio_id`),
  ADD KEY `FK_Administradora_Id` (`administradora_id`);

--
-- Índices para tabela `propriedade`
--
ALTER TABLE `propriedade`
  ADD PRIMARY KEY (`propriedade_id`),
  ADD KEY `FK_CondominioID` (`condominio_id`);

--
-- Índices para tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`usuario_id`),
  ADD KEY `FK_condominio_id` (`condominio_id`),
  ADD KEY `FK_Propriedade_id` (`propriedade_id`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `administradora`
--
ALTER TABLE `administradora`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `condominio`
--
ALTER TABLE `condominio`
  MODIFY `condominio_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `propriedade`
--
ALTER TABLE `propriedade`
  MODIFY `propriedade_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `usuario_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `condominio`
--
ALTER TABLE `condominio`
  ADD CONSTRAINT `FK_Administradora_Id` FOREIGN KEY (`administradora_id`) REFERENCES `administradora` (`id`);

--
-- Limitadores para a tabela `propriedade`
--
ALTER TABLE `propriedade`
  ADD CONSTRAINT `FK_CondominioID` FOREIGN KEY (`condominio_id`) REFERENCES `condominio` (`condominio_id`);

--
-- Limitadores para a tabela `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `FK_Propriedade_id` FOREIGN KEY (`propriedade_id`) REFERENCES `propriedade` (`propriedade_id`),
  ADD CONSTRAINT `FK_condominio_id` FOREIGN KEY (`condominio_id`) REFERENCES `condominio` (`condominio_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
