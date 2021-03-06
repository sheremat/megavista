# phpMyAdmin MySQL-Dump
# version 2.2.4-rc1
# http://phpwizard.net/phpMyAdmin/
# http://phpmyadmin.sourceforge.net/ (download page)
#
# Host: localhost
# Generation Time: Apr 23, 2004 at 01:46 PM
# Server version: 4.00.16
# PHP Version: 4.1.2
# Database : `mrDataDB`
# --------------------------------------------------------

#
# Table structure for table `analyses`
#

DROP TABLE IF EXISTS analyses;
CREATE TABLE analyses (
  id int(10) unsigned NOT NULL auto_increment,
  analyzerID int(10) unsigned default NULL,
  notes varchar(255) default NULL,
  date date default NULL,
  summaryResult varchar(255) default NULL,
  figures blob,
  PRIMARY KEY  (id),
  FULLTEXT KEY textSearch (notes,summaryResult)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `dataFiles`
#

DROP TABLE IF EXISTS dataFiles;
CREATE TABLE dataFiles (
  id int(10) unsigned NOT NULL auto_increment,
  scanID int(10) unsigned NOT NULL default '0',
  path varchar(255) default NULL,
  backupLocation varchar(255) default NULL,
  ownerID int(10) unsigned default NULL,
  access enum('public','local','group','owner') NOT NULL default 'group',
  dataType enum('raw','derived','project','mrSESSION','other') NOT NULL default 'derived',
  fileSize int(11) default NULL,
  createdOn datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (id),
  FULLTEXT KEY textSearch (path,backupLocation)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `displayCalibration`
#

DROP TABLE IF EXISTS displayCalibration;
CREATE TABLE displayCalibration (
  id int(10) unsigned NOT NULL auto_increment,
  displayID int(10) unsigned NOT NULL default '0',
  measuredOn date default NULL,
  measuredBy int(10) unsigned default NULL,
  computer varchar(100) NOT NULL default '',
  videoCard varchar(50) default NULL,
  notes varchar(255) default NULL,
  gammaMat blob,
  spectraMat blob,
  PRIMARY KEY  (id),
  FULLTEXT KEY textSearch (computer,videoCard,notes)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `displays`
#

DROP TABLE IF EXISTS displays;
CREATE TABLE displays (
  id int(10) unsigned NOT NULL auto_increment,
  location varchar(50) default NULL,
  description varchar(100) default NULL,
  PRIMARY KEY  (id),
  FULLTEXT KEY textSearch (location,description)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `grants`
#

DROP TABLE IF EXISTS grants;
CREATE TABLE grants (
  id int(10) unsigned NOT NULL auto_increment,
  agency varchar(60) default NULL,
  lucasCode varchar(6) default NULL,
  principalID int(10) unsigned default NULL,
  start date default NULL,
  end date default NULL,
  amountRemaining decimal(12,2) default NULL,
  notes varchar(255) default NULL,
  PRIMARY KEY  (id),
  FULLTEXT KEY textSearch (agency,lucasCode,notes)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `protocols`
#

DROP TABLE IF EXISTS protocols;
CREATE TABLE protocols (
  id int(10) unsigned NOT NULL auto_increment,
  sedesc varchar(32) default NULL,
  protocolName varchar(32) NOT NULL default '',
  contactId int(10) unsigned default '0',
  creatorId int(10) unsigned default '0',
  entry enum('Head First','Feet First') default NULL,
  position enum('Supine','Prone','Decusp Left','Decusp Right') default NULL,
  coil varchar(32) default NULL,
  pseq enum('SPGR','Gradient Echo','Spin Echo','Localizer','Other') default NULL,
  plane enum('SAGITTAL','CORONAL','AXIAL','OBLIQUE') default NULL,
  imode enum('2D','3D') default NULL,
  iopt varchar(255) default NULL,
  psdname varchar(16) default NULL,
  te varchar(16) default NULL,
  tr decimal(8,1) default NULL,
  ti decimal(8,1) default NULL,
  flipang smallint(6) default NULL,
  numShots tinyint(4) default NULL,
  rbw decimal(10,0) default NULL,
  fov smallint(6) default NULL,
  slthick decimal(4,1) default NULL,
  spc varchar(16) default NULL,
  noslc smallint(6) default NULL,
  matrixx smallint(6) default NULL,
  matrixy smallint(6) default NULL,
  nex decimal(4,2) default NULL,
  phasefov decimal(4,2) default NULL,
  swappf enum('Unswap','S/I','R/L','A/P') default NULL,
  saturation varchar(32) default NULL,
  autocf enum('None','Water','Fat') default NULL,
  contrast varchar(16) default NULL,
  contam varchar(16) default NULL,
  usercv0 decimal(12,4) default NULL,
  usercv1 decimal(12,4) default NULL,
  usercv2 decimal(12,4) default NULL,
  usercv3 decimal(12,4) default NULL,
  usercv4 decimal(12,4) default NULL,
  usercv5 decimal(12,4) default NULL,
  usercv6 decimal(12,4) default NULL,
  usercv7 decimal(12,4) default NULL,
  usercv8 decimal(12,4) default NULL,
  usercv9 decimal(12,4) default NULL,
  usercv10 decimal(12,4) default NULL,
  usercv11 decimal(12,4) default NULL,
  usercv12 decimal(12,4) default NULL,
  usercv13 decimal(12,4) default NULL,
  usercv14 decimal(12,4) default NULL,
  usercv15 decimal(12,4) default NULL,
  usercv16 decimal(12,4) default NULL,
  PRIMARY KEY  (id),
  KEY name (sedesc,protocolName),
  FULLTEXT KEY textSearch (sedesc,protocolName,coil,iopt,psdname,te,spc,saturation,contrast,contam)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `rois`
#

DROP TABLE IF EXISTS rois;
CREATE TABLE rois (
  id int(10) unsigned NOT NULL auto_increment,
  ROIdata blob,
  ROIname varchar(250) default NULL,
  subjectId int(10) unsigned default NULL,
  viewType enum('Gray','Flat','Talairach') default NULL,
  sessionid int(10) unsigned default NULL,
  authorid int(10) unsigned default NULL,
  PRIMARY KEY  (id),
  FULLTEXT KEY textSearch (ROIname)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `scans`
#

DROP TABLE IF EXISTS scans;
CREATE TABLE scans (
  id int(10) unsigned NOT NULL auto_increment,
  scanCode varchar(27) default NULL,
  scanNumber tinyint(4) default NULL,
  stimulusID int(10) unsigned default NULL,
  stimulusType int(10) unsigned default NULL,
  notes text,
  scanParams text,
  sessionID int(10) unsigned NOT NULL default '0',
  primaryStudyID int(10) unsigned default NULL,
  scanType enum('Anatomy','DTI','Retinotopy','Reference','Other','Localizer') default NULL,
  Pfile varchar(32) default NULL,
  behavData blob,
  parfile varchar(128) default NULL,
  script text,
  matlabCode text,
  PRIMARY KEY  (id),
  UNIQUE KEY scanCode (scanCode),
  FULLTEXT KEY textSearch (scanCode,notes,scanParams),
  FULLTEXT KEY parfile (parfile)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `sessions`
#

DROP TABLE IF EXISTS sessions;
CREATE TABLE sessions (
  id int(10) unsigned NOT NULL auto_increment,
  sessionCode varchar(25) default NULL,
  start datetime default NULL,
  end datetime default NULL,
  examNumber int(5) unsigned default NULL,
  primaryStudyID int(10) unsigned default NULL,
  subjectID int(10) unsigned default NULL,
  operatorID int(10) unsigned default NULL,
  displayID int(10) unsigned default NULL,
  readme text,
  notes text,
  fundedBy int(10) unsigned default NULL,
  whoReserved int(10) unsigned default NULL,
  scanner enum('Lucas 1.5T','Lucas 3T') NOT NULL default 'Lucas 3T',
  dataSubDirectory varchar(40) default NULL,
  matlabCode longtext,
  parFiles longtext,
  prtFiles longtext,
  scriptFiles longtext,
  matlabData blob,
  alignment text,
  estMotion mediumtext,
  PRIMARY KEY  (id),
  UNIQUE KEY start (start,end,scanner),
  FULLTEXT KEY textSearch (sessionCode,readme,notes,dataSubDirectory)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `stimuli`
#

DROP TABLE IF EXISTS stimuli;
CREATE TABLE stimuli (
  id int(10) unsigned NOT NULL auto_increment,
  name varchar(32) NOT NULL default '',
  description text,
  code text,
  PRIMARY KEY  (id),
  UNIQUE KEY name (name),
  FULLTEXT KEY textSearch (name,description,code)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `studies`
#

DROP TABLE IF EXISTS studies;
CREATE TABLE studies (
  id int(10) unsigned NOT NULL auto_increment,
  studyCode varchar(16) default NULL,
  title varchar(128) default NULL,
  contactID int(10) unsigned default NULL,
  startDate date default NULL,
  endDate date default NULL,
  purpose text,
  notes text,
  dataDirectory varchar(255) default '/biac1/wandell/data/',
  PRIMARY KEY  (id),
  UNIQUE KEY studyCode (studyCode),
  FULLTEXT KEY textSearch (studyCode,title,purpose,notes,dataDirectory)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `subjectTypes`
#

DROP TABLE IF EXISTS subjectTypes;
CREATE TABLE subjectTypes (
  id int(10) unsigned NOT NULL auto_increment,
  name varchar(64) default NULL,
  description text,
  PRIMARY KEY  (id),
  UNIQUE KEY name (name),
  FULLTEXT KEY textSearch (name,description)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `subjects`
#

DROP TABLE IF EXISTS subjects;
CREATE TABLE subjects (
  id int(10) unsigned NOT NULL auto_increment,
  firstName varchar(30) default NULL,
  lastName varchar(30) default NULL,
  species enum('human','macaque') NOT NULL default 'human',
  address varchar(60) default NULL,
  email varchar(40) NOT NULL default '',
  dob date default NULL,
  subjectConsentDate date default NULL,
  subjectTypeId int(10) unsigned default NULL,
  notes varchar(255) default NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY name (firstName,lastName),
  FULLTEXT KEY textSearch (firstName,lastName,address,email,notes)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `users`
#

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id int(10) unsigned NOT NULL auto_increment,
  firstName varchar(30) default NULL,
  lastName varchar(30) default NULL,
  organization varchar(60) default NULL,
  email varchar(40) NOT NULL default '',
  username varchar(20) default NULL,
  password varchar(16) default NULL,
  dob date default NULL,
  notes varchar(255) default NULL,
  scannerCertified enum('no','yes') NOT NULL default 'no',
  PRIMARY KEY  (id),
  UNIQUE KEY name (firstName,lastName),
  UNIQUE KEY username (username),
  FULLTEXT KEY textSearch (firstName,lastName,organization,email,username,notes)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `xAnalysesDataFiles`
#

DROP TABLE IF EXISTS xAnalysesDataFiles;
CREATE TABLE xAnalysesDataFiles (
  analysisID int(10) unsigned NOT NULL default '0',
  dataFileID int(10) unsigned NOT NULL default '0',
  UNIQUE KEY id (analysisID,dataFileID)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `xAnalysesScans`
#

DROP TABLE IF EXISTS xAnalysesScans;
CREATE TABLE xAnalysesScans (
  analysisID int(10) unsigned NOT NULL default '0',
  scanID int(10) unsigned NOT NULL default '0',
  UNIQUE KEY id (analysisID,scanID)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `xLinks`
#

DROP TABLE IF EXISTS xLinks;
CREATE TABLE xLinks (
  fromTable char(20) default NULL,
  fromColumn char(20) default NULL,
  toTable char(20) default NULL,
  toColumn char(20) default NULL
) TYPE=MyISAM;
INSERT INTO xLinks VALUES ('dataFiles', 'scanID', 'scans', 'id');
INSERT INTO xLinks VALUES ('dataFiles', 'ownerID', 'users', 'id');
INSERT INTO xLinks VALUES ('displayCalibration', 'displayID', 'displays', 'id');
INSERT INTO xLinks VALUES ('displayCalibration', 'measuredBy', 'users', 'id');
INSERT INTO xLinks VALUES ('grants', 'principalID', 'users', 'id');
INSERT INTO xLinks VALUES ('scans', 'sessionID', 'sessions', 'id');
INSERT INTO xLinks VALUES ('sessions', 'displayID', 'displays', 'id');
INSERT INTO xLinks VALUES ('sessions', 'subjectID', 'subjects', 'id');
INSERT INTO xLinks VALUES ('sessions', 'operatorID', 'users', 'id');
INSERT INTO xLinks VALUES ('analyses', 'analyzerID', 'users', 'id');
INSERT INTO xLinks VALUES ('xAnalysesScans', 'analysisID', 'analyses', 'id');
INSERT INTO xLinks VALUES ('xAnalysesScans', 'scanID', 'scans', 'id');
INSERT INTO xLinks VALUES ('xAnalysesDataFiles', 'analysisID', 'analyses', 'id');
INSERT INTO xLinks VALUES ('xAnalysesDataFiles', 'dataFileID', 'dataFiles', 'id');
INSERT INTO xLinks VALUES ('studies', 'contactID', 'users', 'id');
INSERT INTO xLinks VALUES ('xStudiesAnalyses', 'studyID', 'studies', 'id');
INSERT INTO xLinks VALUES ('xStudiesAnalyses', 'analysisID', 'analyses', 'id');
INSERT INTO xLinks VALUES ('scans', 'primaryStudyID', 'studies', 'id');
INSERT INTO xLinks VALUES ('sessions', 'whoReserved', 'users', 'id');
INSERT INTO xLinks VALUES ('sessions', 'fundedBy', 'grants', 'id');
INSERT INTO xLinks VALUES ('sessions', 'primaryStudyID', 'studies', 'id');
INSERT INTO xLinks VALUES ('protocols', 'contactId', 'users', 'id');
INSERT INTO xLinks VALUES ('protocols', 'creatorId', 'users', 'id');
INSERT INTO xLinks VALUES ('rois', 'sessionid', 'sessions', 'id');
INSERT INTO xLinks VALUES ('rois', 'authorid', 'users', 'id');
INSERT INTO xLinks VALUES ('scans', 'stimulusID', 'stimuli', 'id');
INSERT INTO xLinks VALUES ('subjects', 'subjectTypeId', 'subjectTypes', 'id');
INSERT INTO xLinks VALUES ('rois', 'subjectId', 'subjects', 'id');

# --------------------------------------------------------

#
# Table structure for table `xStudiesAnalyses`
#

DROP TABLE IF EXISTS xStudiesAnalyses;
CREATE TABLE xStudiesAnalyses (
  studyID int(10) unsigned NOT NULL default '0',
  analysisID int(10) unsigned NOT NULL default '0',
  UNIQUE KEY id (studyID,analysisID)
) TYPE=MyISAM;

