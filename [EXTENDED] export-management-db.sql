/* crearea tabelelor */

CREATE TABLE iordan_produse
(ID_produs NUMBER(6) CONSTRAINT Pkey_produse PRIMARY KEY,
denumire VARCHAR2(30),
categorie VARCHAR2(20),
pret NUMBER(8,2) NOT NULL,
discount NUMBER(3,1),
stoc NUMBER(6));

CREATE TABLE iordan_regiuni
(ID_regiune NUMBER(1) CONSTRAINT PK_regiuni PRIMARY KEY,
denumire VARCHAR2(20) NOT NULL);

CREATE TABLE iordan_tari
(ID_tara NUMBER(3) CONSTRAINT PK_tari PRIMARY KEY,
nume VARCHAR2(20) NOT NULL,
ID_regiune NUMBER(1),
CONSTRAINT FK_tari FOREIGN KEY(ID_regiune) REFERENCES iordan_regiuni(ID_regiune));

CREATE TABLE iordan_parteneri_comerciali 
(ID_partener NUMBER(6) CONSTRAINT Pkey_parteneri PRIMARY KEY,
nume VARCHAR2(20),
email VARCHAR2(35),
telefon VARCHAR2(15),
adresa VARCHAR2(40),
oras VARCHAR2(20),
ID_tara NUMBER(3),
CONSTRAINT FK_parteneri FOREIGN KEY(ID_tara) REFERENCES iordan_tari(ID_tara));

CREATE TABLE iordan_comenzi
(ID_comanda NUMBER(7) CONSTRAINT PK_comenzi PRIMARY KEY,
data_comenzii DATE NOT NULL,
stare_comanda VARCHAR2(25),
ID_partener NUMBER(6),
CONSTRAINT FK_comenzi FOREIGN KEY(ID_partener) REFERENCES iordan_parteneri_comerciali(ID_partener));

CREATE TABLE iordan_transport
(ID_transport NUMBER(5) CONSTRAINT PK_transport PRIMARY KEY,
data_expedierii DATE,
modalitate VARCHAR2(15),
cost_total NUMBER(6,2) NOT NULL,
durata NUMBER(3),
AWB VARCHAR2(11) UNIQUE,
status VARCHAR2(15),
ID_comanda NUMBER(7),
CONSTRAINT FK_transport FOREIGN KEY(ID_comanda) REFERENCES iordan_comenzi(ID_comanda));

CREATE TABLE iordan_sedii
(ID_sediu NUMBER(3) CONSTRAINT PK_sedii PRIMARY KEY,
oras VARCHAR2(20),
adresa VARCHAR2(40),
cod_postal VARCHAR2(10),
telefon VARCHAR2(15),
data_infiintarii DATE,
statut VARCHAR2(10),
ID_tara NUMBER(3),
CONSTRAINT FK_sedii FOREIGN KEY(ID_tara) REFERENCES iordan_tari(ID_tara),
ID_sediu_parinte NUMBER(3),
CONSTRAINT FK_sediu_parinte FOREIGN KEY(ID_sediu_parinte) REFERENCES iordan_sedii(ID_sediu));

CREATE TABLE iordan_puncte_frontiera
(ID_punct NUMBER(3) CONSTRAINT PK_puncte PRIMARY KEY,
oras VARCHAR2(15),
ID_tara NUMBER(3), 
CONSTRAINT FK_puncte FOREIGN KEY(ID_tara) REFERENCES iordan_tari(ID_tara),
tip VARCHAR2(15));

CREATE TABLE iordan_exporturi
(ID_export NUMBER(6) CONSTRAINT PK_export PRIMARY KEY,
ID_sediu NUMBER(3), CONSTRAINT FK_exp_sediu FOREIGN KEY(ID_sediu) REFERENCES iordan_sedii(ID_sediu),
ID_comanda NUMBER(5), CONSTRAINT FK_exp_comanda FOREIGN KEY(ID_comanda) REFERENCES iordan_comenzi(ID_comanda),
ID_produs NUMBER(6), CONSTRAINT FK_exp_produs FOREIGN KEY(ID_produs) REFERENCES iordan_produse(ID_produs),
ID_transport NUMBER(5), CONSTRAINT FK_exp_transport FOREIGN KEY(ID_transport) REFERENCES iordan_transport(ID_transport),
ID_punct NUMBER(3), CONSTRAINT FK_exp_frontiera FOREIGN KEY(ID_punct) REFERENCES iordan_puncte_frontiera(ID_punct),
pret NUMBER(8,2) NOT NULL,
cantitate NUMBER(5) NOT NULL);

CREATE TABLE iordan_documente
(numar_document NUMBER(5) CONSTRAINT PK_documente PRIMARY KEY,
tip_document VARCHAR2(25), 
data DATE NOT NULL,
ID_export NUMBER(6), CONSTRAINT FK_documente FOREIGN KEY(ID_export) REFERENCES iordan_exporturi(ID_export));

/* crearea unei tabele pe baza altei tabele */
CREATE TABLE iordan_fosti_clienti AS SELECT ID_partener, nume, adresa, oras FROM iordan_parteneri_comerciali;

/* modificarea structurilor tabelelor prin comanda ALTER */

ALTER TABLE iordan_fosti_clienti RENAME TO iordan_fosti_parteneri;

ALTER TABLE iordan_fosti_parteneri
ADD (data_ultimei_comenzi DATE);

ALTER TABLE iordan_produse
MODIFY (denumire VARCHAR2(100));

ALTER TABLE iordan_transport
MODIFY (cost_total NUMBER(8,2));

ALTER TABLE iordan_documente
MODIFY (ID_export NUMBER(6) NOT NULL);

ALTER TABLE iordan_fosti_parteneri
DROP COLUMN adresa;

ALTER TABLE iordan_fosti_parteneri
SET UNUSED COLUMN oras;

ALTER TABLE iordan_fosti_parteneri
DROP UNUSED COLUMN;

ALTER TABLE iordan_transport
DROP COLUMN status;

ALTER TABLE iordan_regiuni
ADD CONSTRAINT check_denumire CHECK (denumire IN ('Europa', 'Asia', 'Africa', 'America de Nord', 'America de Sud','Oceania'));

ALTER TABLE iordan_parteneri_comerciali
ADD CONSTRAINT telefon_unic UNIQUE(telefon);

ALTER TABLE iordan_puncte_frontiera
ADD CONSTRAINT check_frontiera CHECK (tip IN ('terestru', 'aerian', 'maritim'));

ALTER TABLE iordan_sedii
ADD CONSTRAINT check_statut CHECK (statut IN ('activ', 'inactiv'));

ALTER TABLE iordan_produse
ADD CONSTRAINT ck_stoc CHECK ( stoc > 0);

ALTER TABLE iordan_parteneri_comerciali
DISABLE CONSTRAINT telefon_unic;

ALTER TABLE iordan_parteneri_comerciali
DROP CONSTRAINT telefon_unic;

CREATE TABLE iordan_comenzi_anulate AS SELECT ID_comanda, data_comenzii, ID_partener
FROM iordan_comenzi;

DROP TABLE iordan_comenzi_anulate CASCADE CONSTRAINTS;
FLASHBACK TABLE iordan_comenzi_anulate TO BEFORE DROP; 
DROP TABLE iordan_comenzi_anulate PURGE;

/* popularea tabelelor */

INSERT INTO iordan_regiuni (ID_regiune, denumire) VALUES (1, 'Europa');
INSERT INTO iordan_regiuni VALUES (2, 'Asia');
INSERT INTO iordan_regiuni VALUES (3, 'Africa');
INSERT INTO iordan_regiuni VALUES (4, 'America de Nord');
INSERT INTO iordan_regiuni VALUES (5, 'America de Sud');
INSERT INTO iordan_regiuni VALUES (6, 'Oceania');


INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (10, 'Franta', 1);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (20, 'Germania', 1);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (30, 'Marea Britanie', 1);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (40, 'Ungaria', 1);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (50, 'Italia', 1);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (60, 'Serbia', 1);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (70, 'Grecia', 1);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (80, 'Estonia', 1);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (90, 'Danemarca', 1);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (100, 'Croatia', 1);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (110, 'Spania', 1);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (120, 'Cehia', 1);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (130, 'Turcia', 2);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (140, 'China', 2);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (150, 'Singapore', 2);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (160, 'India', 2);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (170, 'Taiwan', 2);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (180, 'Africa de Sud', 3);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (190, 'Nigeria', 3);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (200, 'Algeria', 3);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (210, 'Egipt', 3);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (220, 'Maroc', 3);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (230, 'SUA', 4);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (240, 'Canada', 4);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (250, 'Brazilia', 5);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (260, 'Argentina', 5);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (270, 'Chile', 5);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (280, 'Columbia', 5);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (290, 'Australia', 6);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (300, 'Noua Zeelanda', 6);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (310, 'Japonia', 2);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (320, 'Indonezia', 2);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (330, 'Vietnam', 2);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (340, 'Kenya', 3);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (350, 'Ghana', 3);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (360, 'Peru', 5);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (370, 'Uruguay', 5);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (380, 'Ecuador', 5);
INSERT INTO iordan_tari (ID_tara, nume, ID_regiune) VALUES (390, 'Mexic', 4);


INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (100, 'LDLC', 'contact@ldlc.fr', '+330427466000',' 2 Rue des Érables', 'Limonest',10); 
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (200, 'Darty','contact@dartygroup.com','+33172042218', '9 Rue des Bateaux - Lavoirs', 'Ivry-sur-Seine',10);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (300, 'CDiscount', 'cdiscount@gmail.com', '+332166400', '13 Place de Vénétie', 'Paris', 10);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (400, 'Micromania-Zing', 'contact.micromania@gmail.com','+33492943600','955 Rte des Lucioles', 'Valbonne',10);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (500, 'Cybertek', 'bordeaux-lac@cybertek.fr', '+33556698459', '32 Rue de Cléry', 'Paris', 10);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (600, 'Argos', 'argosclearance@sainsburys.co.uk', '+443456004408', '19 Central Square', 'Wembley', 30);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (700, 'Overclockers UK', 'customerservice@overclockers.uk', '+441782444455', 'Shelton Blvd', 'Stoke-on-Trent', 30); 
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (800, 'Richer Sounds', 'customerservices@richersounds.com', '+441642483658', '29 Bloomsbury Way', 'London', 30);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (900, 'Euronics', 'customerservice@euronics.it', '+398966336614', '6 Via Montefeltro', 'Milano', 50);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (1000, 'Unieuro', 'info@unieuro.com.', '+390543776411', 'Via Virginio Giovanni Schiaparelli, 31', 'Forli FC', 50);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (1100, 'Trony', 'office@trony.com', '+39941918048', 'Viale Cassala, 28', 'Milano', 50);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (1200, 'Monclick', 'info@monclick.it', '+390269496949', 'Via Marghera, 28', 'Milano', 50);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (1300, 'WinWin', 'contact@winwin.rs', '+381700330330', '78g Bulevar Oslobodilaca ?a?ka', 'Cacak', 60);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (1400, 'Mikro princ', 'office@mikroprinc.com', '+381520334335', '	Kralja Milutina 31', 'Belgrad', 60);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (1500, 'Plaisio', 'info@plaisio.gr', '+301102892000', '5 Favierou Street', 'Patra Achaea', 70);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (1600, 'Best price', 'plugins@bestprice.gr', '+302892027800', '76 25th Martiou', 'Moires', 70);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (1700, 'Multirama', 'sales@vrgroup.gr', '+302251037600 ', 'Makri 5', 'Agrinio', 70);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (1800, 'Gamestar', 'info@gamestar.ee', '+37253076779', 'Mustamäe tee 44', 'Tallinn', 80);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (1900, 'Komplett', 'komplett@komplett.dk', '+4570701919', '9 Kay Fiskers Plads 4', 'Copenhagen', 90);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (2000, 'Proshop', 'support@proshop.dk', '+4570205080', 'Slet Mollevej 17', 'Aarhus', 90);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (2100, 'Links', 'contact@links.hr', '+38514569222', 'Ljubljanska 2 A Str.Sveta Nedelja', 'Zagreb', 100);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (2200, 'Futura', 'info@futura-it.hr', '+38514444501', 'Mihanovi?eva ulica 34', 'Zagreb', 100);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (2300, 'Alza', 'alzabox@alza.cz', '+420225340111', 'Jankovcova 1522/53', 'Praga', 120);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (2400, 'Datart', 'infolinka@datart.cz', '+420225991111',  'Národní 28', 'Praga', 120);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (2500, 'Sleviste', 'info@slevise.cz', '+420326541124', 'Pavlovova 3048/40', 'Ostrava', 120);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (2600, 'Teknosa', 'info@teknosa.com', ' +902164683636', 'Tugay Yolu Cd. 67', 'Istanbul', 130); 
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (2700, 'Vatan Bilgisayar', 'info@vatanbilgisayar.com', '+905022256546', 'Merkezefendi Mh. Mevlana Cd. 140', 'Istanbul', 130);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (2800, 'Morhipo', 'iletisim@morhipo.com', '+902123358300', 'Büyükdere Cad. No 237', 'Istanbul', 130);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (2900, 'Croma', 'customersupport@croma.com', '+9187007841025', 'Elphistone Building 10 Veer Nariman Road', 'Mumbai', 160);  
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (3000, 'Reliance Digital', 'support@reliancedigital.com', '+9118008891055', 'Court House, Lokmanya Tilak Marg', 'Mumbai' , 160); 
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (3100, 'PC Studio', 'info@pcstudio.tw', '+886227118838', '7F.,No.260, Sec. 2, Bade Rd.', 'Taipei', 170);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (3200, 'Yodobashi Camera', 'info@yodobashi.com', '0333461010', '1-11-1, Nishishinjuku', 'Shinjuku', 310);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (3300, 'Sofmap', 'info@sofmap.com', '0332533030', 'Building 1-16-9 Sotokanda Chiyoda-Ku', 'Tokyo', 310);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (3400, 'Electronic City', 'customer@electronic-city.co.id', '0211500032',  'Jl Jend Sudirman Kav-52-53 Lot 22', 'Jakarta', 320);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (3500, 'Lazada Vietnam', 'contact@lazada.vn', '+840839421188', '67 d. Le Loi Ben Nghe', 'Ho Chi Minh', 330);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (3600, 'Condor Electronics', 'info@condor.com', '+213021507676', '21 Av. Mustapha Khalef', 'El Biar', 200); 
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (3700, 'Radio Shack Egipt', 'support@radioshack.eg', '+20237480790', '79 Mosadk street ,Dokki', 'Giza', 210); 
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (3800, 'Mega Electro', 'contact@megaelectro.ma', '0635953373', 'Q53P+MRW Rue 18',  'Tanger', 220);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (3900, 'Phone Place', ' info@phoneplacekenya.com', '0726526375', 'Moi Avenue bazaar Mezzanine 1', 'Nairobi', 340); 
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (4000, 'Compu-Ghana', 'customersupport@compughana.com', '0302752020',  'Mac Coffie House, Oxford Street, Osu', 'Accra', 350);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (4100, 'Gabarino', 'contact@gabarino.ar', '+548108887110', 'Guevara 533', 'Buenos Aires', 260);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (4200, 'Compumundo', 'info@compumundo.ar', '+5493342120', 'Av. Escalada 4201', 'Buenos Aires', 260);  
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (4300, 'Hiraoka', 'info@hiraoka.com', '+5141603829655', 'Av. la Marina 2650', 'San Miguel', 360);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (4400, 'PC Shop', 'ventas@pcstore.com.uy', '+59825104655', 'Av. Gral Rivera 6730', 'Montevideo', 370);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (4500, 'Radio Shack Ecuador', 'support@radioshack.ec', '+593966306331', 'C.C. Riocentro Norte 2do piso, local 139', 'Guayaquil', 380);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (4600, 'Radio Shack Mexico', 'support@radioshack.mx', '+528883503669', 'Avenida Pablo Livas 7601, Santa María', 'Guandalupe', 390);  
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (4700, 'Cyberpuerta', 'info@cyberpuerta.mx', '+523347371360', 'Álamo Business Park, El Álamo', 'Guadalajara', 390);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (4800, 'Canada Computers', 'support@canadacomputers.com', '+16135550111', ' 75 West Wilmot Street, Richmond Hill', 'Ontario', 240); 
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (4900, 'The Source', 'contact@thesource.com', '+16135550184', '220 Yonge Street. Unit 1114', 'Toronto', 240);
INSERT INTO iordan_parteneri_comerciali (ID_partener, nume, email, telefon, adresa, oras, ID_tara) VALUES (5000, 'Newegg', 'customerservice@newegg.com', '+16135550190', '55 East Beaver Creek Rd E, Richmond Hill', 'Ontario', 240);


INSERT INTO iordan_sedii (ID_sediu, oras, adresa, cod_postal, telefon, data_infiintarii, statut, ID_tara, ID_sediu_parinte) VALUES (10, 'Boston', '3907 Lynn Street', '02210', '+12025550114', TO_DATE('15-04-1995', 'DD-MM-YYYY'), 'activ', 230, null);
INSERT INTO iordan_sedii (ID_sediu, oras, adresa, cod_postal, telefon, data_infiintarii, statut, ID_tara, ID_sediu_parinte) VALUES (20, 'Berlin', '9 Am Schlangengraben', '13597', '+4930640657983', TO_DATE('20-01-2000', 'DD-MM-YYYY'), 'activ', 20, 10);
INSERT INTO iordan_sedii (ID_sediu, oras, adresa, cod_postal, telefon, data_infiintarii, statut, ID_tara, ID_sediu_parinte) VALUES (30, 'Budapesta', '9 Mádi köz', '1105', '+3655311272', TO_DATE('05-06-2002', 'DD-MM-YYYY'), 'inactiv', 40, 20);
INSERT INTO iordan_sedii (ID_sediu, oras, adresa, cod_postal, telefon, data_infiintarii, statut, ID_tara, ID_sediu_parinte) VALUES (40, 'Madrid', 'Fco. Munoz, 4', '28200', '+34189472641', TO_DATE('02-10-2003', 'DD-MM-YYYY'), 'activ', 110, 20);
INSERT INTO iordan_sedii (ID_sediu, oras, adresa, cod_postal, telefon, data_infiintarii, statut, ID_tara, ID_sediu_parinte) VALUES (50, 'Beijing', '	122 Guihua South Rd', '00853', '+865918870904', TO_DATE('22-03-2005', 'DD-MM-YYYY'), 'activ', 140, 10);
INSERT INTO iordan_sedii (ID_sediu, oras, adresa, cod_postal, telefon, data_infiintarii, statut, ID_tara, ID_sediu_parinte) VALUES (60, 'Singapore', '1202 East Coast Parkway', '449881', '+6561936511', TO_DATE('01-12-2010', 'DD-MM-YYYY'),'activ', 150, 50);
INSERT INTO iordan_sedii (ID_sediu, oras, adresa, cod_postal, telefon, data_infiintarii, statut, ID_tara, ID_sediu_parinte) VALUES (70, 'Cape Town', 'Western Cape, 72, Roeland Street', '8000', '+27810703832', TO_DATE('16-09-2007','DD-MM-YYYY'), 'activ', 180, 10);
INSERT INTO iordan_sedii (ID_sediu, oras, adresa, cod_postal, telefon, data_infiintarii, statut, ID_tara, ID_sediu_parinte) VALUES (80, 'Lagos', '306-308 Murtala Muhammed Way', '101245', '+2347060596365', TO_DATE('27-08-2012','DD-MM-YYYY'), 'activ', 190, 70);
INSERT INTO iordan_sedii (ID_sediu, oras, adresa, cod_postal, telefon, data_infiintarii, statut, ID_tara, ID_sediu_parinte) VALUES (90, 'Sao Paulo', 'Rua Vinte e Sete 1790', '13181416', '+559557024114', TO_DATE('05-05-2015','DD-MM-YYYY'), 'activ', 250, 10);
INSERT INTO iordan_sedii (ID_sediu, oras, adresa, cod_postal, telefon, data_infiintarii, statut, ID_tara, ID_sediu_parinte) VALUES (100, 'Santiago', 'Av. Balmaceda 750', '9760502', '+56617381211', TO_DATE('10-11-2017','DD-MM-YYYY'), 'activ', 270, 90);
INSERT INTO iordan_sedii (ID_sediu, oras, adresa, cod_postal, telefon, data_infiintarii, statut, ID_tara, ID_sediu_parinte) VALUES (110, 'Bogota', 'Cra. 7 #115-60 Usaquén', '110111', '+573508159518', TO_DATE('09-02-2018','DD-MM-YYYY'),'activ', 280, 90);
INSERT INTO iordan_sedii (ID_sediu, oras, adresa, cod_postal, telefon, data_infiintarii, statut, ID_tara, ID_sediu_parinte) VALUES (120, 'Sydney', '43 Hollinsworth RD, Marsden Park', '2765', '+610048491379', TO_DATE('25-07-2020', 'DD-MM-YYYY'), 'activ', 290, 10);
INSERT INTO iordan_sedii (ID_sediu, oras, adresa, cod_postal, telefon, data_infiintarii, statut, ID_tara, ID_sediu_parinte) VALUES (130, 'Wellington', '147 Karaori Road', '6012', '+6434726391', TO_DATE('12-10-2021','DD-MM-YYYY'), 'inactiv', 300, 120);


INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (100, 'Iordan Maria', TO_DATE('03-05-2015', 'DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (200, 'Dixons Carphone', TO_DATE('14-02-2011', 'DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (300, 'Power.dk', TO_DATE('08-10-2003','DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (400, 'Topachat', TO_DATE('29-06-2014', 'DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (500, 'Microchoix', TO_DATE('11-12-2010','DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (600, 'Memory Express', TO_DATE('30-04-2020', 'DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (700, 'Pycca', TO_DATE('17-01-2000', 'DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (800, 'NOVA', TO_DATE('10-10-2013','DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (900, 'Steren', TO_DATE('08-02-2019','DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (1000, 'Alnect Computer', TO_DATE('12-08-2009','DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (1100, 'Electro Universe', TO_DATE('07-12-2010','DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (1200, 'Edion', TO_DATE('24-05-2011','DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (1300, 'CompuMe', TO_DATE('18-07-2002','DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (1400, 'Tradeline Stores', TO_DATE('04-03-1998','DD-MM-YYYY'));
INSERT INTO iordan_fosti_parteneri (ID_partener, nume, data_ultimei_comenzi) VALUES (1500, 'B.Tech', TO_DATE('12-08-2001', 'DD-MM-YYYY'));


INSERT INTO iordan_produse (ID_produs, denumire, categorie, pret, discount, stoc) VALUES (001, 'Laptop Apple MacBook Air 13-inch cu procesor Apple M2', 'laptopuri', 5799.99, null, 3000);
INSERT INTO iordan_produse VALUES (002, 'Laptop Acer Aspire 5 A514-56 cu procesor Intel® Core™ i5-1335U pana la 4.6 GHz, 14"', 'laptopuri', 2500, null, 5000); 
INSERT INTO iordan_produse VALUES (003, 'Laptop Gaming Lenovo IdeaPad 3 15IHU6 cu procesor Intel® Core™ i5-11320H pana la 4.50 GHz, 15.6"', 'laptopuri', 2810, 5, 2500);
INSERT INTO iordan_produse VALUES (004, 'Laptop Allview Allbook J cu procesor Intel® Celeron™ J4125 pana la 2.70 GHz, 15.6"', 'laptopuri', 829.99, 2, 7500);
INSERT INTO iordan_produse VALUES (005, 'Geanta laptop ASUS Nereus, 16", Black', 'accesorii laptop', 67.99, null, 10000);
INSERT INTO iordan_produse VALUES (006, 'Geanta laptop portabila Timebox, 13'', 14'', 15'', 16'' inch, captusit interior cu microfibra', 'accesorii laptop', 158.99, null, 9000); 
INSERT INTO iordan_produse VALUES (007, 'Cooler laptop Tellur Basic, 17", 5 ventilatoare, LED, 2xUSB, Negru', 'accesorii laptop', 70, 5, 25000);
INSERT INTO iordan_produse VALUES (008, 'HDD Laptop Seagate BarraCuda® 1TB, 5400rpm, 128MB cache, SATA III', 'accesorii laptop', 260, 2, 20000);
INSERT INTO iordan_produse VALUES (009, 'HDD Laptop Seagate BarraCuda® 2TB, 5400rpm, 128MB cache, SATA III', 'accesorii laptop', 430.71, null, 6000);
INSERT INTO iordan_produse VALUES (010, 'Telefon mobil Apple iPhone 15, 128GB, 5G, Black', 'telefoane', 4619.95, 5, 12000);
INSERT INTO iordan_produse VALUES (011, 'Telefon mobil Apple iPhone 13, 128GB, 5G, Pink', 'telefoane', 3299.99, 2, 8000);
INSERT INTO iordan_produse VALUES (012, 'Telefon mobil Samsung Galaxy S23 Ultra, Dual SIM, 8GB RAM, 256GB, 5G, Green', 'telefoane', 5200, null, 30000);
INSERT INTO iordan_produse VALUES (013, 'Telefon mobil Samsung Galaxy S22, Dual SIM, 8GB RAM, 128GB, 5G, Bora Purple', 'telefoane', 2970.85, 5, 20000);
INSERT INTO iordan_produse VALUES (014, 'Telefon mobil Samsung Galaxy A14, Dual SIM, 4GB RAM, 64GB, 4G, Silver', 'telefoane', '700.10', null, 5000);
INSERT INTO iordan_produse VALUES (015, 'Telefon mobil Xiaomi Redmi Note 12 Pro+, 8GB RAM, 256GB, 5G Midnight Black', 'telefoane', 1699.99, 2, 7500);
INSERT INTO iordan_produse VALUES (016, 'Telefon mobil Motorola Moto g13, Dual SIM, 128GB, 4GB RAM, Matte Charcoal', 'telefoane', 533.99, null, null);
INSERT INTO iordan_produse VALUES (017, 'Telefon mobil Motorola Edge 40 Neo, Dual SIM, 256GB, 12GB RAM, 5G, Caneel Bay', 'telefoane', 1599.99, null, 8500);
INSERT INTO iordan_produse VALUES (018, 'Husa de Protectie, Compatibila Apple iPhone 15, Doctor Shield Fantom, MagSafe - Negru', 'accesorii telefoane', 59.99, null, 25000);
INSERT INTO iordan_produse VALUES (019, 'Husa magnetica, Vaxiuja, Compatibila cu iPhone 13, 1 husa telefon, 2 Protectie Ecran', 'accesorii telefoane', 60, 10, 20000);
INSERT INTO iordan_produse VALUES (020, 'Husa de protectie Apple Clear Case with MagSafe pentru iPhone 14 Plus, Transparent', 'accesorii telefoane', 187.99, 5, 10000);
INSERT INTO iordan_produse VALUES (021, 'Folie de protectie din sticla premium pentru iPhone 14/13/13pro', 'accesorii telefoane', 35.70, null, 9000);
INSERT INTO iordan_produse VALUES (022, 'Set 2 Folii sticla compatibil cu iPhone 15, 6.1", DefenSlim, protectie telefon', 'accesorii telefoane', 79.96, 2, 5000);
INSERT INTO iordan_produse VALUES (023, 'Folie protectie Privacy Premium iPhone 13 Pro Max, Full Cover Black 6D, Full Glue', 'accesorii telefoane', 14.30, null, 15000);
INSERT INTO iordan_produse VALUES (024, 'Incarcator retea Apple, USB Type C, 20W, White', 'accesorii telefoane', 103.86, 15, 35000);
INSERT INTO iordan_produse VALUES (025, 'Incarcator pentru Samsung Super Fast Charging (Max. 25W), C to C Cable, Black', 'accesorii telefoane', 62.92, 5, 20000); 
INSERT INTO iordan_produse VALUES (026, 'Incarcator Wireless Qeno® Statie Incarcare 3 In 1 Qi Fast Charger 15W Incarcare Rapida', 'accesorii telefoane', 278.98, 20, 8900);
INSERT INTO iordan_produse VALUES (027, 'Statie de Incarcare Wireless 3 in 1 Tip Ceas/Alarma, Multifunctionala, Lampa', 'accesorii telefoane', 300, 10, 6750);
INSERT INTO iordan_produse VALUES (028, 'Casti Apple EarPods, USB-C, White', 'accesorii telefoane', 89.99, 2, 50000);
INSERT INTO iordan_produse VALUES (029, 'Casti in-ear Samsung, Type-C, Black', 'accesorii telefoane', 65.28, null, 24000);
INSERT INTO iordan_produse VALUES (030, 'Casti Audio In Ear JBL Tune 110, Cu fir, Negru', 'accesorii telefoane', 49.99, 5, 12000);
INSERT INTO iordan_produse VALUES (031, 'Apple Watch SE (2023), GPS, Carcasa Starlight Aluminium 40mm , Starlight Sport Band - S/M', 'gadgeturi', 1349.99, 15, 15000);
INSERT INTO iordan_produse VALUES (032, 'Apple Watch 8, GPS, Carcasa Starlight Aluminium 45mm, Starlight Sport Band', 'gadgeturi', 1849.99, 10, 10500);
INSERT INTO iordan_produse VALUES (033, 'Samsung Galaxy Watch6 Classic, 43mm, BT, Black', 'gadgeturi', 1499.69, null, 9750);
INSERT INTO iordan_produse VALUES (034, 'Bratara fitness Huawei Band 8, Midnight Black', 'gadgeturi', 208, null, 5000);
INSERT INTO iordan_produse VALUES (035, 'Bratara fitness, Olivfant, Unisex, Multifunctional, Roz', 'gadgeturi', 178.50, 5, 7600);
INSERT INTO iordan_produse VALUES (036, 'Placa video Gigabyte GeForce RTX 4060 EAGLE OC, 8GB GDDR6, 128bit', 'componente PC', 1933.67, 20, 11000);
INSERT INTO iordan_produse VALUES (037, 'Placa video INNO3D GeForce RTX 3060 Twin X2, 12GB GDDR6, 192-bit', 'componente PC', 1499.99, null, 12500);
INSERT INTO iordan_produse VALUES (038, 'Placa de baza Gigabyte B550M DS3H, Socket AM4', 'componente PC', 459.99, null, 10450);
INSERT INTO iordan_produse VALUES (039, 'Placa de sunet CREATIVE Sound Blaster Audigy FX v2 - Hi-res 5.1, PCIe', 'componente PC', 269.23, 5, 9980);
INSERT INTO iordan_produse VALUES (040, 'Memorie Corsair Vengeance LPX Black 16GB, DDR4, 3200MHz, CL16, Dual Channel Kit', 'componente PC', 209.99, null, 2500);
INSERT INTO iordan_produse VALUES (041, 'Memorie Exceleram 8GB, DDR3, 1600Mhz', 'componente PC', 100.74, 5, 13000);
INSERT INTO iordan_produse VALUES (042, 'Procesor AMD Ryzen™ 7 5800X3D, 4.5GHz, 100MB, socket AM4, Box', 'componente PC', 1639.99, 15, 8520);
INSERT INTO iordan_produse VALUES (043, 'Procesor Intel® Core™ i5-13400, 2.5GHz, 20MB, LGA1700 Box', 'componente PC', 1269.99, 5, 10300);
INSERT INTO iordan_produse VALUES (044, 'HDD Toshiba HDWD110 1TB, 7200rpm, 64MB buffer, SATA III', 'componente PC', 227.99, null, 13450);
INSERT INTO iordan_produse VALUES (045, 'HDD Seagate® SkyHawk™, 4TB, 64MB cache, SATA-III', 'componente PC', 453.25, 25, 12000);
INSERT INTO iordan_produse VALUES (046, 'Carcasa SPACER RAINBOW, Mid-Tower, fara sursa, ATX, Black', 'componente PC', 281.99, 15, 15000);
INSERT INTO iordan_produse VALUES (047, 'Carcasa Aerocool Prime ARGB, Mid-Tower, fara sursa, ATX, Black', 'componente PC', 176.99, null, null);
INSERT INTO iordan_produse VALUES (048, 'Carcasa AQIRYS Procyon, Mid-Tower, fara sursa, ATX, Black', 'componente PC', 748.53, 25, 9600);
INSERT INTO iordan_produse VALUES (049, 'Cooler Procesor ARCTIC Freezer 34 eSports DUO Grey, compatibil AMD/Intel', 'componente PC', 241.68, 10, 14900);
INSERT INTO iordan_produse VALUES (050, 'Cooler Procesor Noctua NH-D9L, Compatibil Intel / AMD', 'componente PC', 319.77, null, 11000);
INSERT INTO iordan_produse VALUES (051, 'Laptop Gaming ASUS ROG Strix G18 G814JV cu procesor Intel® Core™', 'laptopuri', 9499.99, 25, 7800);
INSERT INTO iordan_produse VALUES (052, 'Mouse Gaming profesional Runmus® CW902, 6500 DPI 6 trepte', 'periferice', 95.20, 5, 13500);
INSERT INTO iordan_produse VALUES (053, 'Mouse gaming Razer DeathAdder Essential 2021, Negru', 'periferice', 115.08, 10, 12600);
INSERT INTO iordan_produse VALUES (054, 'Kit Gaming A+ HL1, 4 in 1,Tastatura, Mouse, Casti, Mousepad', 'periferice', 129.99, null, 20000);
INSERT INTO iordan_produse VALUES (055, 'Tastatura Mecanica Wireless/ Fir ZENKABEAT, Cablu, Bluetooth, 2.4Ghz, RGB, 68 Taste', 'periferice', 399, 15, 15300);
INSERT INTO iordan_produse VALUES (056, 'Tastatura mecanica gaming Redragon Fizz Pro K616 TKL RGB, alb/gri, red switches', 'periferice', 209.99, 5, 9975);
INSERT INTO iordan_produse VALUES (057, 'Tastatura gaming KINSI, Buton de volum independent, RGB LED, Alb', 'periferice', 139.99, null, 24000); 
INSERT INTO iordan_produse VALUES (058, 'HDD extern Seagate Expansion Portable 4TB, USB 3.0, Negru', 'periferice', 539.99, 25, 7800);
INSERT INTO iordan_produse VALUES (059, 'HDD Extern WD Elements Desktop 10TB, 3.5", USB 3.0, Negru', 'periferice', 1277.08, 30, 1725);
INSERT INTO iordan_produse VALUES (060, 'Boxe gaming 2.0 Serioux Blys X167, Iluminare RGB, Bluetooth', 'periferice', 89.76, null, 4600);
INSERT INTO iordan_produse VALUES (061, 'Soundbar gaming, Bluetooth 5.0, RGB, 6W, USB, Jack 3.5mm, Negru', 'periferice', 108, 5, 12600);
INSERT INTO iordan_produse VALUES (062, 'Boxe gaming A+ Kogaion, 2.0, Iluminare RGB', 'periferice', 47.99, null, 21000);
INSERT INTO iordan_produse VALUES (063, 'Boxe Creative Pebble v3, 2.0 Bluetooth 5.0, USB-C, Negru', 'periferice', 204.99, 5, 4900);
INSERT INTO iordan_produse VALUES (064, 'Boxe PC 2.0 Redragon Waltz GS510 RGB, control tactil al luminozitatii, jack 3.5 mm', 'periferice', 76.99, 10, 11230);
INSERT INTO iordan_produse VALUES (065, 'Casti gaming HyperX Cloud II Black-Red, surround 7.1 virtual, USB/jack 3,5mm', 'periferice', 409.99, 25, 9750);
INSERT INTO iordan_produse VALUES (066, 'Casti gaming profesionale Runmus® K2Pro, cu microfon, 7.1 surround HD', 'periferice', 79.73, 5, 10000);
INSERT INTO iordan_produse VALUES (067, 'Casti gaming cu microfon HAVIT H763d, difuzoare 40mm, control volum', 'periferice', 28.99, null, 16800);
INSERT INTO iordan_produse VALUES (068, 'Casti gaming ASUS ROG Cetra True Wireless, bluetooth 5.0', 'periferice', 631.41, 30, 8450);
INSERT INTO iordan_produse VALUES (069, 'Casti audio wireless copii DinoPlay DP10, microfon, Bluetooth 5.0', 'periferice', 119, 15, 23000);
INSERT INTO iordan_produse VALUES (070, 'Multifunctionala CISS InkJet color HP Smart Tank 580 All-in-One, Wi-Fi', 'imprimante', 729.99, 25, 15900);
INSERT INTO iordan_produse VALUES (071, 'Mini imprimanta termica GALAXIA®, cu 10 role hartie termica, Bluetooth', 'imprimante', 114.99, 10, 10560);
INSERT INTO iordan_produse VALUES (072, 'Imprimanta laser monocrom Xerox Phaser 3020, Wireless, A4', 'imprimanta', 479.99, 15, 9750);
INSERT INTO iordan_produse VALUES (073, 'Multifunctional inkjet Canon Pixma TS3350, wifi, negru', 'imprimante', 214.89, 25, 13200);
INSERT INTO iordan_produse VALUES (074, 'Multifunctional inkjet color HP OfficeJet PRO 9010E, Retea, Wireless, Duplex', 'imprimante', 970.52, 30, 12500);
INSERT INTO iordan_produse VALUES (075, 'Imprimanta laser monocrom Brother HL1110E, A4', 'imprimante', 429.99, 15, 7800);
INSERT INTO iordan_produse VALUES (076, 'Multifunctional color inkjet Brother DCP-T220 InkBenefit Plus, A4', 'imprimante', 819.99, 10, 12000);
INSERT INTO iordan_produse VALUES (077, 'Multifunctional laser color Xerox C315DN, Retea, Wireless, Duplex, ADF, A4', 'imprimante', 3074.99, 15, 11000);
INSERT INTO iordan_produse VALUES (078, 'Imprimanta termica, Vaxiuja, Multifunctionala, Bluetooth, Mini, Termica', 'imprimante', 161.35, 10, 9900);
INSERT INTO iordan_produse VALUES (079, 'Multifunctional laser monocrom Brother MFC-B7715DW, Duplex, Wireless', 'imprimante', 1299.99, 25, 12450);
INSERT INTO iordan_produse VALUES (080, 'Telefon mobil Apple iPhone 14, 128GB, 5G, Starlight', 'telefoane', 3799.99, 15, 6800);
INSERT INTO iordan_produse VALUES (081, 'Telefon mobil Samsung Galaxy A54, Dual SIM, 8GB RAM, 128GB, 5G, Awesome Lime', 'telefoane', 1671.12, 10, 12500);
INSERT INTO iordan_produse VALUES (082, 'Telefon mobil Apple iPhone 13, 128GB, 5G, Green', 'telefoane', 3249.99, 30, 2500);
INSERT INTO iordan_produse VALUES (083, 'Telefon mobil Samsung Galaxy S22, Dual SIM, 256GB, 8GB RAM, 5G, Phantom Black', 'telefoane', 2897.99, 15, 5700);
INSERT INTO iordan_produse VALUES (084, 'Procesor Intel Core i5-6600 Tray, 3.9 GHz Turbo, Socket 1151, Fara Cooler', 'componente PC', 399.98, null, 9900);
INSERT INTO iordan_produse VALUES (085, 'Mouse gaming + mousepad Trust GXT 781 Rixa , Verde Camo', 'periferice', 41.84, null, 15600);
INSERT INTO iordan_produse VALUES (086, 'Mouse wireless, SDLOGAL, USB, 1000/1200/1600 DPI reglabil', 'periferice', 40.02, 5, 17800);
INSERT INTO iordan_produse VALUES (087, 'Mouse optic ASUS WT465, Wireless, USB, Negru', 'periferice', 53.99, 5, 15400);
INSERT INTO iordan_produse VALUES (088, 'Mouse wireless, Bluetooth, USB, 2.4Ghz, 1600 dpi, LED RGB', 'periferice', 46.99, null, 10299);
INSERT INTO iordan_produse VALUES (089, 'Mouse gaming Trust GXT960 Graphin, ultrausor 74g', 'periferice', 74.99, 5, 16500);
INSERT INTO iordan_produse VALUES (090, 'Placa de baza Gigabyte Z790 UD DDR5, Socket LGA 1700', 'componente PC', 1079.99, 15, 9750);
INSERT INTO iordan_produse VALUES (091, 'Placa de sunet Creative Sound Blaster G3 - USB-C', 'componente PC', 250.70, null, 19000);
INSERT INTO iordan_produse VALUES (092, 'Kit gaming Redragon S107 tastatura, mouse si mousepad', 'periferice', 135.99, 25, 12300);
INSERT INTO iordan_produse VALUES (093, 'Cooler, Enermax, Liqmaxflo, 360 ARGB, 500-1800rpm, 400W', 'componente PC', 570, 15, 9000);
INSERT INTO iordan_produse VALUES (094, 'Folie de protectie A+ pentru Samsung S23 / S22 ', 'accesorii telefoane', 19.99, null, 23000);
INSERT INTO iordan_produse VALUES (095, 'Husa compatibila cu iPhone 11, Anti-Shock, Silicon Transparent', 'accesorii telefoane', 38.50, 5, 18750);
INSERT INTO iordan_produse VALUES (096, 'Laptop Acer Extensa 15 EX215-54 cu procesor Intel® Core™ i5-1135G7', 'laptopuri', 1999.99, 15, 14500);
INSERT INTO iordan_produse VALUES (097, 'Laptop Dell Vostro 3520 cu procesor Intel® Core™ i5-1235U', 'laptopuri', 2699.99, 20, 11200);
INSERT INTO iordan_produse VALUES (098, 'Smartwatch Huawei Watch GT 3 PRO, Leather Strap, Gray', 'gadgeturi', 1199.99, 12, 9345);
INSERT INTO iordan_produse VALUES (099, 'Smartwatch Amazfit Watch T-Rex 2, Wild Green', 'gadgeturi', 799.99, null, 6500);
INSERT INTO iordan_produse VALUES (100, 'Ceas SmartWatch si Bratara Fitness 2in1 WiX™, Carcasa UltraSlim', 'gadgeturi', 219.11, 5, 5800);


INSERT INTO iordan_comenzi (ID_comanda, data_comenzii, stare_comanda, id_partener) VALUES (100, TO_DATE('25-03-2010','DD-MM-YYYY'),'expediata', 300);
INSERT INTO iordan_comenzi VALUES (101, TO_DATE('18-02-2012', 'DD-MM-YYYY'), 'expediata', 700);
INSERT INTO iordan_comenzi VALUES (102, TO_DATE('30-05-2018','DD-MM-YYYY'), 'expediata', 2400);
INSERT INTO iordan_comenzi VALUES (103, TO_DATE('01-08-2020','DD-MM-YYYY'), 'expediata', 4700);
INSERT INTO iordan_comenzi VALUES (104, TO_DATE('14-12-2023','DD-MM-YYYY'), 'expediata', 3400);
INSERT INTO iordan_comenzi VALUES (105, TO_DATE('03-03-2013','DD-MM-YYYY'), 'expediata', 4100 );
INSERT INTO iordan_comenzi VALUES (106, TO_DATE('23-10-2018','DD-MM-YYYY'), 'expediata', 3900);
INSERT INTO iordan_comenzi VALUES (107, TO_DATE('12-03-2019','DD-MM-YYYY'), 'expediata', 3300);
INSERT INTO iordan_comenzi VALUES (108, TO_DATE('25-11-2021','DD-MM-YYYY'), 'expediata', 1800);
INSERT INTO iordan_comenzi VALUES (109, TO_DATE('16-05-2014','DD-MM-YYYY'), 'expediata', 5000);
INSERT INTO iordan_comenzi VALUES (110, TO_DATE('27-01-2016','DD-MM-YYYY'), 'expediata', 3800);
INSERT INTO iordan_comenzi VALUES (111, TO_DATE('21-09-2022','DD-MM-YYYY'), 'expediata', 3600);
INSERT INTO iordan_comenzi VALUES (112, TO_DATE('06-04-2015','DD-MM-YYYY'), 'expediata', 4400);
INSERT INTO iordan_comenzi VALUES (113, TO_DATE('23-07-2021','DD-MM-YYYY'), 'expediata', 4000);
INSERT INTO iordan_comenzi VALUES (114, TO_DATE('26-09-2023','DD-MM-YYYY'), 'expediata', 4500);
INSERT INTO iordan_comenzi VALUES (115, TO_DATE('19-08-2017','DD-MM-YYYY'), 'expediata', 3400);
INSERT INTO iordan_comenzi VALUES (116, TO_DATE('12-02-2016','DD-MM-YYYY'), 'expediata', 3100);
INSERT INTO iordan_comenzi VALUES (117, TO_DATE('05-09-2020','DD-MM-YYYY'), 'expediata', 3500);
INSERT INTO iordan_comenzi VALUES (118, TO_DATE('10-08-2020','DD-MM-YYYY'), 'expediata', 3500);
INSERT INTO iordan_comenzi VALUES (119, TO_dATE('19-04-2011','DD-MM-YYYY'), 'expediata', 4000);
INSERT INTO iordan_comenzi VALUES (120, TO_DATE('12-03-2019','DD-MM-YYYY'), 'expediata', 4300);
INSERT INTO iordan_comenzi VALUES (121, TO_DATE('22-12-2022','DD-MM-YYYY'), 'confirmata', 1900);
INSERT INTO iordan_comenzi VALUES (122, TO_DATE('22-12-2022','DD-MM-YYYY'), 'in procesare', 2100);
INSERT INTO iordan_comenzi VALUES (123, TO_DATE('01-01-2024','DD-MM-YYYY'), 'confirmata', 2900);
INSERT INTO iordan_comenzi VALUES (124, TO_DATE('17-03-2023','DD-MM-YYYY'), 'expediata', 3700);
INSERT INTO iordan_comenzi VALUES (125, TO_DATE('03-01-2024','DD-MM-YYYY'), 'in procesare', 1100);
INSERT INTO iordan_comenzi VALUES (126, TO_DATE('29-05-2014','DD-MM-YYYY'), 'expediata', 1300);
INSERT INTO iordan_comenzi VALUES (127, TO_DATE('20-11-2022','DD-MM-YYYY'), 'expediata', 3900);
INSERT INTO iordan_comenzi VALUES (128, TO_DATE('09-01-2024','DD-MM-YYYY'), 'in procesare', 2500);
INSERT INTO iordan_comenzi VALUES (129, TO_DATE('02-01-2024','DD-MM-YYYY'), 'expediata', 4900);
INSERT INTO iordan_comenzi VALUES (130, TO_DATE('18-12-2023','DD-MM-YYYY'), 'confirmata', 4300);


INSERT INTO iordan_transport (ID_transport, data_expedierii, modalitate, cost_total, durata, awb, id_comanda) VALUES (1000, TO_DATE('27-03-2010','DD-MM-YYYY'), 'rutier', 2500, 24, '25486315294',100);
INSERT INTO iordan_transport VALUES (1001, TO_DATE('21-02-2012', 'DD-MM-YYYY'), 'aerian', 3500, 2, '25436515236', 101);
INSERT INTO iordan_transport VALUES (1002, TO_DATE('31-05-2018','DD-MM-YYYY'), 'rutier', 735, 4, '76935573928', 102);
INSERT INTO iordan_transport VALUES (1003, TO_DATE('03-08-2020','DD-MM-YYYY'), 'rutier', 8800, 45, '42513645892', 103);
INSERT INTO iordan_transport VALUES (1004, TO_DATE('16-12-2023','DD-MM-YYYY'), 'aerian', 50000, 2, '52364238456', 104);
INSERT INTO iordan_transport VALUES (1005, TO_DATE('05-03-2013','DD-MM-YYYY'), 'rutier', 2730, 18, '52143265215', 105);
INSERT INTO iordan_transport VALUES (1006, TO_DATE('26-10-2018','DD-MM-YYYY'), 'rutier', 11490, 80, '12543652891', 106);
INSERT INTO iordan_transport VALUES (1007, TO_DATE('14-03-2019','DD-MM-YYYY'), 'maritim', 13500, 45, '1254352915', 107);
INSERT INTO iordan_transport VALUES (1008, TO_DATE('28-11-2021','DD-MM-YYYY'),'aerian', 75000, 3, '45532156821', 108);
INSERT INTO iordan_transport VALUES (1009, TO_DATE('17-05-2014','DD-MM-YYYY'), 'rutier', 1680, 10, '52146254236', 109);
INSERT INTO iordan_transport VALUES (1010, TO_DATE('29-01-2016','DD-MM-YYYY'),'aerian', 50900, 2, '45216852164', 110);
INSERT INTO iordan_transport VALUES (1011, TO_DATE('24-09-2022','DD-MM-YYYY'), 'rutier', 5450, 45, '78541263951', 111);
INSERT INTO iordan_transport VALUES (1012, TO_DATE('08-04-2015','DD-MM-YYYY'), 'rutier', 3750, 30, '45216358921', 112);
INSERT INTO iordan_transport VALUES (1013, TO_DATE('27-07-2021','DD-MM-YYYY'), 'maritim', 35600, 48, '54256329872', 113);
INSERT INTO iordan_transport VALUES (1014, TO_DATE('27-09-2023','DD-MM-YYYY'), 'aerian', 52000, 2, '84521659453', 114);
INSERT INTO iordan_transport VALUES (1015, TO_DATE('22-08-2017','DD-MM-YYYY'), 'aerian', 75250, 8, '75482163542', 115);
INSERT INTO iordan_transport VALUES (1016, TO_DATE('13-02-2016', 'DD-MM-YYYY'), 'aerian', 67000, 3, '78546295314', 116);
INSERT INTO iordan_transport VALUES (1017, TO_DATE('07-09-2020','DD-MM-YYYY'), 'rutier', 5929, 42, '75426598312', 117);
INSERT INTO iordan_transport VALUES (1018, TO_DATE('12-08-2020','DD-MM-YYYY'), 'aerian', 84500, 5, '36521456985', 118);
INSERT INTO iordan_transport VALUES (1019, TO_DATE('21-04-2011','DD-MM-YYYY'), 'rutier', 1500, 11, '48569521365', 119);
INSERT INTO iordan_transport VALUES (1020, TO_DATE('15-03-2019','DD-MM-YYYY'), 'aerian', 52490, 3, '78594621583', 120);
INSERT INTO iordan_transport VALUES (1021, TO_DATE('02-01-2023','DD-MM-YYYY'), 'aerian', 49000, 1, '45987632154', 121);
INSERT INTO iordan_transport VALUES (1022, null, 'aerian', 68000, 5, null, 122);
INSERT INTO iordan_transport VALUES (1023, TO_DATE('03-01-2024','DD-MM-YYYY'), 'rutier', 14980, 130,'26542315495', 123);
INSERT INTO iordan_transport VALUES (1024, TO_DATE('20-03-2023','DD-MM-YYYY'), 'aerian', 88000, 19, '58746523654', 124);
INSERT INTO iordan_transport VALUES (1025, null, 'rutier', 2200, 12, null, 125);
INSERT INTO iordan_transport VALUES (1026, TO_DATE('31-05-2014','DD-MM-YYYY'), 'rutier', 6300, 30, '65842365192', 126);
INSERT INTO iordan_transport VALUES (1027, TO_DATE('24-11-2022','DD-MM-YYYY'), 'rutier', 12600, 90, '78546213594', 127);
INSERT INTO iordan_transport VALUES (1028, null, 'rutier', 1500, 7, null, 128);
INSERT INTO iordan_transport VALUES (1029,  TO_DATE('05-01-2024','DD-MM-YYYY'), 'rutier', 2000, 9, '54876523694', 129);
INSERT INTO iordan_transport VALUES (1030, TO_DATE('02-01-2024','DD-MM-YYYY'), 'rutier', 6500, 60, '78542654987', 130);


INSERT INTO iordan_puncte_frontiera (ID_punct, oras, ID_tara, tip) VALUES (100, 'Aachen', 20, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (110, 'Berlin', 20, 'aerian');
INSERT INTO iordan_puncte_frontiera VALUES (120, 'Altenberg', 20, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (130, 'Laredo', 230, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (140, 'Singapore', 150, 'aerian');
INSERT INTO iordan_puncte_frontiera VALUES (150, 'Los Andes', 270, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (160, 'Beitbridge', 180, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (170, 'Qinhuangdao', 140, 'maritim');
INSERT INTO iordan_puncte_frontiera VALUES (190, 'Ogdensburg', 230, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (200, 'Madrid', 110, 'aerian');
INSERT INTO iordan_puncte_frontiera VALUES (210, 'Sokoto', 190, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (220, 'SantAna', 250, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (230, 'Santos', 250, 'maritim');
INSERT INTO iordan_puncte_frontiera VALUES (240, 'Bogota', 280, 'aerian');
INSERT INTO iordan_puncte_frontiera VALUES (250, 'Sydney', 290, 'aerian');
INSERT INTO iordan_puncte_frontiera VALUES (260, 'Beijing', 140, 'aerian');
INSERT INTO iordan_puncte_frontiera VALUES (270, 'Singapore', 150, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (290, 'Lagos', 190, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (300, 'Lindau', 20, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (310, 'Girona', 110, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (320, 'Ikom', 190, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (330, 'Forst', 20, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (340, 'Lewiston', 230, 'terestru');
INSERT INTO iordan_puncte_frontiera VALUES (350, 'Gral. Farfán', 280, 'terestru');

INSERT INTO iordan_exporturi (ID_export, ID_sediu, ID_comanda, ID_produs, ID_transport, ID_punct, pret, cantitate) VALUES (1000, 20, 100, 7, 1000, 100, 66.5, 5600); 
INSERT INTO iordan_exporturi VALUES (1001, 20, 101, 4, 1001, 110, 813.39, 2500);
INSERT INTO iordan_exporturi VALUES (1002, 20, 102, 22, 1002, 120, 78.36, 75000);
INSERT INTO iordan_exporturi VALUES (1003, 10, 103, 10, 1003, 130, 4388.95, 500);
INSERT INTO iordan_exporturi VALUES (1004, 60, 104, 51, 1004, 140, 7124.99, 350);
INSERT INTO iordan_exporturi VALUES (1005, 100, 105, 34, 1005, 150, 208, 3500);
INSERT INTO iordan_exporturi VALUES (1006, 70, 106, 41, 1006, 160, 95.70, 9000);
INSERT INTO iordan_exporturi VALUES (1007, 50, 107, 15, 1007, 170, 1665.99, 5000);
INSERT INTO iordan_exporturi VALUES (1008, 20, 108, 54, 1008, 110, 129.99, 15000);
INSERT INTO iordan_exporturi VALUES (1009, 10, 109, 19, 1009, 190, 54, 25000);
INSERT INTO iordan_exporturi VALUES (1010, 40, 110, 37, 1010, 200, 1499.99, 4875);
INSERT INTO iordan_exporturi VALUES (1011, 80, 111, 46, 1011, 210, 239.69, 650);
INSERT INTO iordan_exporturi VALUES (1012, 90, 112, 17, 1012, 220, 1599.99, 6700);
INSERT INTO iordan_exporturi VALUES (1013, 90, 113, 27, 1013, 230, 270, 8950);
INSERT INTO iordan_exporturi VALUES (1014, 110, 114, 14, 1014, 240, 700.1, 5500);
INSERT INTO iordan_exporturi VALUES (1015, 120, 115, 39, 1015, 250, 255.77, 2300);
INSERT INTO iordan_exporturi VALUES (1016, 50, 116, 26, 1016, 260, 223.18, 10000); 
INSERT INTO iordan_exporturi VALUES (1017, 60, 117, 31, 1017, 270, 1147.49, 480);
INSERT INTO iordan_exporturi VALUES (1018, 60, 118, 23, 1018, 140, 14.3, 35000); 
INSERT INTO iordan_exporturi VALUES (1019, 80, 119, 56, 1019, 290, 199.49, 2000);
INSERT INTO iordan_exporturi VALUES (1020, 110, 120, 10, 1020, 240, 4388.95, 850);
INSERT INTO iordan_exporturi VALUES (1021, 20, 121, 38, 1021, 110, 459.99, 1000);
INSERT INTO iordan_exporturi VALUES (1022, 40, 122, 96, 1022, 200, 1699.99, 400);
INSERT INTO iordan_exporturi VALUES (1023, 60, 123, 84, 1023, 270, 399.98, 3000);
INSERT INTO iordan_exporturi VALUES (1024, 40, 124, 66, 1024, 200, 75.74, 10000);
INSERT INTO iordan_exporturi VALUES (1025, 20, 125, 99, 1025, 300, 799.99, 600);
INSERT INTO iordan_exporturi VALUES (1026, 40, 126, 50, 1026, 310, 319.77, 4000);
INSERT INTO iordan_exporturi VALUES (1027, 80, 127, 13, 1027, 320, 2822.31, 250);
INSERT INTO iordan_exporturi VALUES (1028, 20, 128, 93, 1028, 330, 484.50, 7000);
INSERT INTO iordan_exporturi VALUES (1029, 10, 129, 64, 1029, 340, 69.29, 19000);
INSERT INTO iordan_exporturi VALUES (1030, 110, 130, 89, 1030, 350, 71.24, 9800);

INSERT INTO iordan_documente (numar_document, tip_document, data, id_export) VALUES (0001, 'factura', TO_DATE('25-03-2010','DD-MM-YYYY'), 1000);
INSERT INTO iordan_documente VALUES (0002, 'factura', TO_DATE('20-02-2012','DD-MM-YYYY'), 1001);
INSERT INTO iordan_documente VALUES (0003, 'factura', TO_DATE('30-05-2018','DD-MM-YYYY'), 1002);
INSERT INTO iordan_documente VALUES (0004, 'factura', TO_DATE('02-08-2020', 'DD-MM-YYYY'), 1003);
INSERT INTO iordan_documente VALUES (0005, 'factura', TO_DATE('14-12-2023','DD-MM-YYYY'), 1004);
INSERT INTO iordan_documente VALUES (0006, 'asigurare', TO_DATE('16-12-2023','DD-MM-YYYY'), 1004);
INSERT INTO iordan_documente VALUES (0007, 'factura', TO_DATE('05-03-2013','DD-MM-YYYY'), 1005);
INSERT INTO iordan_documente VALUES (0008, 'certificat origine', TO_DATE('04-03-2013','DD-MM-YYYY'), 1005);
INSERT INTO iordan_documente VALUES (0009, 'factura', TO_DATE('26-10-2018','DD-MM-YYYY'), 1006);
INSERT INTO iordan_documente VALUES (0010, 'asigurare', TO_DATE('26-10-2018','DD-MM-YYYY'), 1006);
INSERT INTO iordan_documente VALUES (0011, 'certificat origine', TO_DATE('25-10-2018', 'DD-MM-YYYY'), 1006);
INSERT INTO iordan_documente VALUES (0012, 'factura', TO_DATE('13-03-2019','DD-MM-YYYY'), 1007);
INSERT INTO iordan_documente VALUES (0013, 'certificat origine', TO_DATE('26-11-2021','DD-MM-YYYY'), 1008);
INSERT INTO iordan_documente VALUES (0014, 'factura', TO_DATE('26-11-2021','DD-MM-YYYY'),1008);
INSERT INTO iordan_documente VALUES (0015, 'factura', TO_DATE('17-05-2014','DD-MM-YYYY'), 1009);
INSERT INTO iordan_documente VALUES (0016, 'asigurare', TO_DATE('28-01-2016','DD-MM-YYYY'),1010);
INSERT INTO iordan_documente VALUES (0017, 'factura', TO_DATE('29-01-2016','DD-MM-YYYY'),1010);
INSERT INTO iordan_documente VALUES (0018, 'factura', TO_DATE('23-09-2022','DD-MM-YYYY'), 1011);
INSERT INTO iordan_documente VALUES (0019, 'factura', TO_DATE('08-04-2015','DD-MM-YYYY'),1012);
INSERT INTO iordan_documente VALUES (0020, 'asigurare', TO_DATE('27-07-2021','DD-MM-YYYY'), 1013);
INSERT INTO iordan_documente VALUES (0021, 'factura', TO_DATE('26-07-2021', 'DD-MM-YYYY'),1013);
INSERT INTO iordan_documente VALUES (0022, 'factura', TO_DATE('27-09-2023','DD-MM-YYYY'), 1014);
INSERT INTO iordan_documente VALUES (0023, 'factura', TO_DATE('19-08-2017','DD-MM-YYYY'), 1015);
INSERT INTO iordan_documente VALUES (0024, 'factura', TO_DATE('12-02-2016','DD-MM-YYYY'), 1016);
INSERT INTO iordan_documente VALUES (0025, 'asigurare', TO_DATE('13-02-2016','DD-MM-YYYY'),1016);
INSERT INTO iordan_documente VALUES (0026, 'asigurare', TO_DATE('07-09-2020','DD-MM-YYYY'), 1017);
INSERT INTO iordan_documente VALUES (0027, 'factura', TO_DATE('07-09-2020', 'DD-MM-YYYY'), 1017);
INSERT INTO iordan_documente VALUES (0028, 'asigurare', TO_DATE('12-08-2020','DD-MM-YYYY'), 1018);
INSERT INTO iordan_documente VALUES (0029, 'factura', TO_DATE('10-08-2020', 'DD-MM-YYYY'), 1018);
INSERT INTO iordan_documente VALUES (0030, 'factura', TO_DATE('19-04-2011','DD-MM-YYYY'), 1019);
INSERT INTO iordan_documente VALUES (0031, 'certificat origine', TO_DATE('12-03-2019','DD-MM-YYYY'), 1020);
INSERT INTO iordan_documente VALUES (0032, 'factura', TO_DATE('12-03-2019','DD-MM-YYYY'), 1020);
INSERT INTO iordan_documente VALUES (0033, 'asigurare', TO_DATE('15-03-2019','DD-MM-YYYY'), 1020);
INSERT INTO iordan_documente VALUES (0034, 'factura', TO_DATE('22-12-2023','DD-MM-YYYY'), 1021);
INSERT INTO iordan_documente VALUES (0035, 'factura', TO_DATE('01-01-2024','DD-MM-YYYY'),1023);
INSERT INTO iordan_documente VALUES (0036, 'asigurare', TO_DATE('20-03-2023','DD-MM-YYYY'), 1024);
INSERT INTO iordan_documente VALUES (0037, 'factura', TO_DATE('17-03-2023','DD-MM-YYYY'), 1024);
INSERT INTO iordan_documente VALUES (0038, 'factura', TO_DATE('29-05-2014','DD-MM-YYYY'), 1026);
INSERT INTO iordan_documente VALUES (0039, 'factura', TO_DATE('20-11-2022','DD-MM-YYYY'), 1027);
INSERT INTO iordan_documente VALUES (0040, 'asigurare', TO_DATE('24-11-2022','DD-MM-YYYY'), 1027);
INSERT INTO iordan_documente VALUES (0041, 'certificat origine', TO_DATE('03-01-2024','DD-MM-YYYY'), 1029);
INSERT INTO iordan_documente VALUES (0042, 'factura', TO_DATE('03-01-2024','DD-MM-YYYY'), 1029);
INSERT INTO iordan_documente VALUES (0043, 'asigurare', TO_DATE('05-01-2024','DD-MM-YYYY'), 1029);
INSERT INTO iordan_documente VALUES (0044, 'certificat origine', TO_DATE('18-12-2023','DD-MM-YYYY'), 1030);
INSERT INTO iordan_documente VALUES (0045, 'factura', TO_DATE('18-12-2023','DD-MM-YYYY'), 1030);

CREATE TABLE iordan_produse_bestselling 
AS SELECT ID_produs, denumire, categorie, pret, stoc FROM iordan_produse
WHERE id_produs = 0 ; 

INSERT INTO iordan_produse_bestselling SELECT ID_produs, denumire, categorie, pret, stoc FROM iordan_produse
WHERE stoc <= 5000
ORDER BY pret;


-----STRUCTURI DE CONTROL

SET SERVEROUTPUT ON

--Sa se parcurga fiecare înregistrare din tabela iordan_transporturi și sa se afiseze informațiile referitoare la data expedierii,
--modalitatea de transport și costul total pentru fiecare înregistrare, evitând însă afișarea celor care conțin valori lipsă. 

DECLARE
 v_min NUMBER;
 v_max NUMBER;
 v_data iordan_transport.data_expedierii%TYPE;
 v_modalitate iordan_transport.modalitate%TYPE;
 v_cost iordan_transport.cost_total%TYPE;
 v_test NUMBER;
BEGIN
 SELECT MIN(id_transport), MAX(id_transport)
 INTO v_min, v_max
 FROM iordan_transport;
 
 FOR i IN v_min..v_max LOOP
  -- Verificam daca toate coloanele au valori
  SELECT COUNT(*)
  INTO v_test
  FROM iordan_transport
  WHERE id_transport = i AND modalitate IS NOT NULL AND data_expedierii IS NOT NULL AND cost_total IS NOT NULL;

  IF v_test > 0 THEN 
    -- Daca nu exista valori lipsa, se ruleaza SELECT
    SELECT data_expedierii, modalitate, cost_total
    INTO v_data, v_modalitate, v_cost
    FROM iordan_transport
    WHERE id_transport = i;
    DBMS_OUTPUT.PUT_LINE('Transportul cu id-ul ' || i || ' a fost expediat pe data de ' || v_data || ' pe cale ' || v_modalitate || 'a' || ' , cu un cost total de ' || v_cost || ' RON.');
  ELSE
    -- Dacă exista valori lipsa
    DBMS_OUTPUT.PUT_LINE('Transportul cu id-ul ' || i || ' are valori lipsă!');
  END IF; 
 END LOOP;
END;
/

--Sa se afiseze denumirea, categoria și prețul fiecărui produs din tabela iordan_produse.

DECLARE
 v_denumire iordan_produse.denumire%TYPE;
 v_categorie iordan_produse.categorie%TYPE;
 v_pret iordan_produse.pret%TYPE;
 v_min NUMBER;
 v_max NUMBER;
 i NUMBER;

BEGIN

 SELECT MIN(id_produs), MAX(id_produs) 
 INTO v_min, v_max
 FROM iordan_produse;
 
 i:= v_min;
 
 WHILE i<=v_max LOOP
   SELECT denumire, categorie, pret
   INTO v_denumire, v_categorie, v_pret
   FROM iordan_produse
   WHERE id_produs = i;
   
   DBMS_OUTPUT.PUT_LINE(i|| ' - '|| 'DENUMIRE: '|| v_denumire || ', CATEGORIE: ' || v_categorie || ', PRET: ' || v_pret || ' RON');
 i:=i+1;
 END LOOP;
END;
/

--Sa se afiseze numele si telefonul partenerilor cu id-ul intre 100 si 1500.

DECLARE
    v_nume iordan_parteneri_comerciali.nume%TYPE;
    v_telefon iordan_parteneri_comerciali.telefon%TYPE;
    i NUMBER;
    v_test NUMBER;
BEGIN
    FOR i IN 100..1500 LOOP
     SELECT COUNT(id_partener) INTO v_test FROM iordan_parteneri_comerciali WHERE id_partener=i;
     IF v_test = 1 THEN 
        SELECT nume, telefon
        INTO v_nume, v_telefon
        FROM iordan_parteneri_comerciali WHERE id_partener=i;
        DBMS_OUTPUT.PUT_LINE ('Partenerul '||i|| ' - '|| v_nume||', telefon: '||v_telefon);
    END IF;
    END LOOP;
END;

--Sa se parcurga tabela iordan_documente pentru toate documentele cu numărul documentului între valoarea minimă și valoarea maximă.
--Pentru fiecare document existent, sa se afiseze tipul documentului și vechimea acestuia în ani. Dacă documentul nu există, 
--se va afișa un mesaj corespunzător.

DECLARE
    v_tip iordan_documente.tip_document%TYPE;
    v_vechime NUMBER;
    v_min NUMBER;
    v_max NUMBER;
    v_test NUMBER;
BEGIN
    SELECT MIN(numar_document), MAX(numar_document) 
    INTO v_min, v_max
    FROM iordan_documente;

    LOOP
        SELECT COUNT(numar_document) INTO v_test FROM iordan_documente WHERE numar_document=v_min;
        IF v_test = 1 THEN 
            SELECT tip_document, ROUND((SYSDATE-data)/365)
            INTO v_tip, v_vechime
            FROM iordan_documente WHERE numar_document=v_min;
            DBMS_OUTPUT.PUT_LINE ('Documentul '||v_min||' este o '|| v_tip ||' cu o vechime de '|| v_vechime || ' ani.' );
        ELSE
            DBMS_OUTPUT.PUT_LINE ('Documentul '||v_min|| ' NU EXISTA! ');
        END IF;
	v_min:=v_min+1;
	EXIT WHEN v_min>v_max;
    END LOOP;
END;
/

--Sa se afiseze produsele din intervalul 1-50, cu conditia ca pretul sa fie mai mare decat media.

DECLARE
v_pret iordan_produse.pret%TYPE;
v_pretmediu v_pret%TYPE;
BEGIN
 SELECT AVG(pret) INTO v_pretmediu FROM iordan_produse;
 DBMS_OUTPUT.PUT_LINE('Pretul mediu este '||v_pretmediu || ' RON.');
 
 FOR i IN 1..50 LOOP
  SELECT pret INTO v_pret FROM iordan_produse WHERE id_produs = i;
  DBMS_OUTPUT.PUT_LINE('Produsul cu id-ul '||i||' costa '||v_pret||' RON.');
  EXIT WHEN v_pret < v_pretmediu;
END LOOP;
END;
/

-----CURSORI

SET SERVEROUTPUT ON;

--CURSOR IMPLICIT

--Sa se dubleze pretul produselor bestselling din categoriile 'periferice' si 'laptopuri', daca stocul este < 3000

BEGIN
  UPDATE IORDAN_PRODUSE_BESTSELLING 
  SET pret = pret*2
  WHERE categorie IN ('periferice', 'laptopuri') AND stoc < 3000;
  
  IF SQL%FOUND THEN
    DBMS_OUTPUT.PUT_LINE('S-au modificat '|| SQL%ROWCOUNT||' produse.');
  ELSE 
    DBMS_OUTPUT.PUT_LINE(' Nu exista produse care sa fie modificate.');
  END IF;
END;
/

--CURSORI EXPLICITI
 
--Sa se afiseze denumirea si pretul tuturor produselor ce au stocul mai mare de 10.000

DECLARE
CURSOR c IS SELECT denumire, pret FROM iordan_produse
            WHERE stoc > 10000;
v_denumire iordan_produse.denumire%TYPE;
v_pret iordan_produse.pret%TYPE;
BEGIN
  OPEN c;
  LOOP
    FETCH c INTO v_denumire, v_pret;
    EXIT WHEN  c%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Produsul '||v_denumire||' costa '||v_pret||' RON');
  END LOOP;
  CLOSE c;
END;
/

--Sa se afiseze id-ul, adresa, anul si statutul sediilor infiintate inainte de anul 2010

DECLARE
CURSOR c IS SELECT id_sediu, adresa,EXTRACT(YEAR FROM data_infiintarii) AS an, statut FROM iordan_sedii 
            WHERE EXTRACT(YEAR FROM data_infiintarii) < 2010;
v c%ROWTYPE;
BEGIN
  OPEN c;
  LOOP
    FETCH c INTO v;
    EXIT WHEN c%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Sediul cu id-ul'||v.id_sediu||' din locatia '||v.adresa||', infiintat in anul '||v.an||', este '||v.statut);
  END LOOP;
CLOSE c;
END;
/
    
--Sa se afiseze id-ul exportului, produsul comandat si valoarea exportului pentru primele 5 exporturi dupa valoare
DECLARE
CURSOR c IS SELECT e.id_export, p.denumire, SUM(e.pret*e.cantitate) AS valoare FROM iordan_exporturi e, iordan_produse p
WHERE e.id_produs = p.id_produs
GROUP BY e.id_export, p.denumire
ORDER BY valoare DESC;
v c%ROWTYPE;
BEGIN
  OPEN c;
  LOOP
    FETCH c INTO v;
    EXIT WHEN c%ROWCOUNT>5;
    DBMS_OUTPUT.PUT_LINE('In cadrul exportului cu id-ul '||v.id_export||' s-a comandat produsul '||v.denumire||' si a valorat '||v.valoare||' RON.');
  END LOOP;
CLOSE c;
END;
/

--Sa se afiseze toate punctele de frontiera de tip terestru din Europa.
DECLARE
CURSOR c IS SELECT p.id_punct, p.oras, p.tip
 FROM iordan_puncte_frontiera p 
 JOIN iordan_tari t ON p.id_tara = t.id_tara  
 JOIN iordan_regiuni r ON t.id_regiune = r.id_regiune
 WHERE r.denumire = 'Europa' AND p.tip = 'terestru';

BEGIN
DBMS_OUTPUT.PUT_LINE('Puncte de frontiera de tip terestru din Europa:');
DBMS_OUTPUT.PUT_LINE('==============================================');
FOR v in c LOOP
  DBMS_OUTPUT.PUT_LINE('Punctul de frontiera cu'|| ' id-ul '|| v.id_punct||' se afla in orasul '||v.oras);
END LOOP;
END;
/

----EXCEPTII

--Selectati numele si telefonul partenerului al carui id este introdus de la tastatura. 
--Daca interogarea nu returneaza nicio valoare, tratati exceptia cu o rutina de tratare corespunzatoare si afisati mesajul "Atentie! Partenerul nu exista!"
--Daca interogarea returneaza mai multe randuri, tratati exceptia cu o rutina de tratare corespunzatoare si afisati mesajul "Mai multe rânduri returnate! Verificați condițiile."
--Tratati orice alta exceptie cu o rutina de tratare corespunzatoare si afisati mesajul “A aparut o alta exceptie!”

DECLARE
  v_id iordan_parteneri_comerciali.id_partener%TYPE := &id;
  v_nume iordan_parteneri_comerciali.nume%TYPE;
  v_telefon iordan_parteneri_comerciali.telefon%TYPE;
BEGIN
    SELECT p.nume, p.telefon 
    INTO v_nume, v_telefon 
    FROM iordan_parteneri_comerciali p
    JOIN iordan_tari t ON p.id_tara = t.id_tara
    JOIN iordan_comenzi c ON p.id_partener = c.id_partener
    WHERE p.id_partener = v_id;

    DBMS_OUTPUT.PUT_LINE('Partener găsit: ' || v_nume || ', Telefon: ' || v_telefon);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Atentie! Partenerul nu exista!');
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE('Mai multe rânduri returnate! Verificați condițiile.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('A aparut o alta exceptie!');
END;
/

--Sa se injumatateasca pretul produsului al carui id este citit de la tastatura.
--Sa se invoce o exceptie in cazul in care acesta nu exista si tratati exceptia prin afisarea unui mesaj.

DECLARE
v_id NUMBER := &id;
nu_exista EXCEPTION;
BEGIN
  UPDATE iordan_produse
  SET pret = pret/2
  WHERE id_produs = v_id;
  
  IF SQL%NOTFOUND THEN
   RAISE nu_exista;
  ELSE 
   DBMS_OUTPUT.PUT_LINE('Pretul a fost modificat!');
  END IF;

  EXCEPTION
  WHEN nu_exista THEN DBMS_OUTPUT.PUT_LINE('Produsul nu exista!');
END;
/

--Sa se citeasca de la tastatura id-ul unui partener comercial. Sa se afiseze numele, telefonul si adresa acestuia. 
--Si, de asemenea, sa se afiseze produsul comandat de acesta.
--Daca partenerul nu exista, tratati exceptia cu o rutina de tratare corespunzatoare
--Daca nu este client/nu a comandat niciun produs, invocati o exceptie, care se va trata corespunzator
--Tratati orice alta exceptie cu o rutina de tratare corespunzatoare

DECLARE
v_id iordan_parteneri_comerciali.id_partener%TYPE := &id;
v_nume iordan_parteneri_comerciali.nume%TYPE;
v_telefon iordan_parteneri_comerciali.telefon%TYPE;
v_adresa iordan_parteneri_comerciali.adresa%TYPE;
v_produs iordan_produse.denumire%TYPE;
v_test NUMBER;
nu_exista_partenerul EXCEPTION;
nu_are_comenzi EXCEPTION;
BEGIN
 SELECT COUNT(id_partener) INTO v_test
 FROM iordan_parteneri_comerciali WHERE id_partener = v_id;
 
 IF v_test = 0 THEN
  RAISE nu_exista_partenerul;
 ELSE 
  BEGIN
   SELECT pc.nume, pc.telefon, pc.adresa, p.denumire 
   INTO v_nume, v_telefon, v_adresa, v_produs 
   FROM iordan_parteneri_comerciali pc
   JOIN iordan_comenzi c ON pc.id_partener = c.id_partener
   JOIN iordan_exporturi e ON c.id_comanda = e.id_comanda
   JOIN iordan_produse p ON e.id_produs = p.id_produs
   WHERE pc.id_partener = v_id;
    
   DBMS_OUTPUT.PUT_LINE('Partenerul '||v_nume||', telefon: '||v_telefon||', adresa: '||v_adresa||', a comandat produsul '||v_produs);

   EXCEPTION
     WHEN NO_DATA_FOUND THEN RAISE nu_are_comenzi;
   END;
 END IF;
 
 EXCEPTION 
  WHEN nu_exista_partenerul THEN DBMS_OUTPUT.PUT_LINE('Nu exista partenerul cautat!');
  WHEN nu_are_comenzi THEN DBMS_OUTPUT.PUT_LINE('Partenerul există, dar nu a comandat niciun produs!');
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('A aparut o alta exceptie: '||SQLERRM);
END;
/

----Să se parcurgă toate produsele din tabelul iordan_produse utilizând un cursor. Să se afișeze denumirea produselor și cantitatea disponibilă.
--Dacă stocul unui produs este insuficient (mai mic de 500 bucati), să se arunce o excepție, care se va trata corespunzător prin afișarea mesajului: 'Un produs are stoc insuficient. Verificați datele din tabel!' .
--Dacă apare orice altă excepție, sa se trateze cu o rutină de tratare corespunzătoare.

DECLARE
  CURSOR c IS
    SELECT id_produs, denumire, stoc
    FROM iordan_produse;
  v_produs c%ROWTYPE;
  stoc_insuficient EXCEPTION;
BEGIN
  OPEN c;
  LOOP
    FETCH c INTO v_produs;
    EXIT WHEN c%NOTFOUND;

    IF v_produs.stoc < 500 THEN
      RAISE stoc_insuficient;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Produsul ' || v_produs.denumire || ' are stoc suficient: ' || v_produs.stoc);
  END LOOP;
  CLOSE c;
EXCEPTION
  WHEN stoc_insuficient THEN
    DBMS_OUTPUT.PUT_LINE('Un produs are stoc insuficient. Verificați datele din tabel!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('A apărut o altă excepție: ' || SQLERRM);
END;
/


--Sa se insereze in tabela produse un nou produs cu id-ul 75 si cu pretul nul. 

BEGIN
 INSERT INTO iordan_produse (id_produs, pret) VALUES (75, NULL);
END;

--Sa se trateze exceptia aparuta (ORA-01400)

DECLARE
exceptie_inserare EXCEPTION;
PRAGMA EXCEPTION_INIT(exceptie_inserare, -01400);
BEGIN
 INSERT INTO iordan_produse (id_produs, pret) VALUES (75, NULL);
EXCEPTION
 WHEN exceptie_inserare THEN DBMS_OUTPUT.PUT_LINE('Pretul nu poate fi nul!');
 DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

--Sa se stearga toate inregistrarile din tabela regiuni.

BEGIN
  DELETE FROM iordan_regiuni;
END;

--Sa se trateze eroarea aparuta si sa se afiseze codul si mesajul acesteia.

DECLARE
nu_sterge EXCEPTION;
PRAGMA EXCEPTION_INIT(nu_sterge, -2292);
BEGIN
 DELETE FROM iordan_regiuni;
EXCEPTION
WHEN nu_sterge THEN DBMS_OUTPUT.PUT_LINE('Produsul nu poate fi eliminat!');
DBMS_OUTPUT.PUT_LINE(SQLCODE||' '||SQLERRM);
END;
/

----PROCEDURI

--Să se definească procedura modifica_pretul, care actualizează prețul unui produs specificat pe baza unui procent transmis ca parametru. 
--Procedura primește doi parametri: ID-ul produsului care urmează să fie modificat și procentul de ajustare a prețului (poate fi pozitiv pentru majorare sau negativ pentru reducere). 
--Înainte și după actualizarea prețului, procedura va afișa valoarea acestuia pentru a reflecta modificările efectuate.

CREATE OR REPLACE PROCEDURE modifica_pretul (p_id_produs IN iordan_produse.id_produs%TYPE, procent IN number)
IS 
v_pret iordan_produse.pret%TYPE;
BEGIN
SELECT pret INTO v_pret FROM iordan_produse WHERE id_produs = p_id_produs;
DBMS_OUTPUT.PUT_LINE('Produsul are pretul '||v_pret);

UPDATE iordan_produse
SET pret = pret*(1+procent/100)
WHERE id_produs = p_id_produs;

SELECT pret INTO v_pret FROM iordan_produse WHERE id_produs = p_id_produs;

DBMS_OUTPUT.PUT_LINE('Produsul are acum pretul '||v_pret);
END;
/

EXECUTE modifica_pretul(75, 5);

--	Se va defini procedura afisare_transport, 
--care va afișa informațiile referitoare la data expedierii și numărul AWB al unui transport din tabela iordan_transporturi, pe baza ID-ului transmis ca parametru.

CREATE OR REPLACE PROCEDURE afisare_transport 
(p_id_transport IN iordan_transport.id_transport%TYPE,
 p_data OUT iordan_transport.data_expedierii%TYPE, 
 p_awb OUT iordan_transport.awb%TYPE)
IS
BEGIN
SELECT data_expedierii, awb INTO p_data, p_awb FROM iordan_transport
WHERE id_transport = p_id_transport;
DBMS_OUTPUT.PUT_LINE('Transportul cu awb-ul '|| p_awb || ' va fi expediat la data de ' || p_data);
END;
/

--Apelare printr-un bloc anonim

DECLARE
v_data iordan_transport.data_expedierii%TYPE;
v_awb iordan_transport.awb%TYPE;
BEGIN
afisare_transport(1015, v_data, v_awb);
END;
/

---	Se dorește crearea unei proceduri stocate denumită valoare_export, 
--care să calculeze și să afișeze valoarea totală a exporturilor pentru o anumită regiune, pe baza prețului și cantității produselor exportate. 

CREATE OR REPLACE PROCEDURE valoare_export(p_regiune iordan_regiuni.denumire%TYPE) IS
CURSOR c IS SELECT e.id_export, r.denumire, SUM(e.pret*e.cantitate) as  valoare
FROM iordan_exporturi e JOIN iordan_sedii s ON e.id_sediu = s.id_sediu
JOIN iordan_tari t ON s.id_tara = t.id_tara
JOIN iordan_regiuni r ON t.id_regiune = r.id_regiune
WHERE r.denumire = p_regiune
GROUP BY e.id_export, r.denumire;

BEGIN
FOR v in c LOOP
 DBMS_OUTPUT.PUT_LINE('Exportul cu id-ul '||v.id_export || ' are valoarea '||v.valoare|| ' RON.');
END LOOP;
END;
/

CALL valoare_export('Asia');

----Se dorește crearea unei proceduri stocate denumită actualizeaza_stoc, care să actualizeze stocul unui produs din tabelul iordan_produse 
--pe baza unui ID de produs și a unei cantități introduse. Procedura va verifica dacă produsul există în baza de date și va actualiza stocul acestuia, 
--adăugând cantitatea specificată. 
--Dacă produsul nu există, se va ridica o excepție și se va afișa un mesaj corespunzător. 
--De asemenea, dacă cantitatea introdusă este mai mare de 1000, se va ridica o excepție și se va afișa un mesaj avertizând despre valoarea prea mare a cantității.


CREATE OR REPLACE PROCEDURE actualizeaza_stoc (
    p_id_produs IN iordan_produse.id_produs%TYPE,
    p_cantitate IN NUMBER
) IS
    v_stoc_curent iordan_produse.stoc%TYPE;
    cantitate_prea_mare EXCEPTION;
    produs_inexistent EXCEPTION;
BEGIN
    BEGIN
        SELECT stoc 
        INTO v_stoc_curent
        FROM iordan_produse
        WHERE id_produs = p_id_produs;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE produs_inexistent;  
    END;
    
    IF p_cantitate > 1000 THEN
        RAISE cantitate_prea_mare;
    END IF;

    UPDATE iordan_produse
    SET stoc = stoc + p_cantitate
    WHERE id_produs = p_id_produs;

    DBMS_OUTPUT.PUT_LINE('Stocul pentru produsul cu ID ' || p_id_produs || 
                         ' a fost actualizat la: ' || (v_stoc_curent + p_cantitate));
EXCEPTION
    WHEN produs_inexistent THEN
        DBMS_OUTPUT.PUT_LINE('Produsul cu ID ' || p_id_produs || ' nu există.');
    WHEN cantitate_prea_mare THEN
        DBMS_OUTPUT.PUT_LINE('Cantitatea introdusă este prea mare. Nu se permite o valoare mai mare de 1000.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('A apărut o eroare: ' || SQLERRM);
END;
/

--Apelarea procedurii

BEGIN
  actualizeaza_stoc(100,500);
  actualizeaza_stoc(101,500);
  actualizeaza_stoc(100,1500);
END;


----FUNCTII

--Sa se creeze o funcție care să calculeze numărul de parteneri comerciali pentru o țară,
--având ca parametru numele țării. Sa se gestioneze prin excepții situațiile în care nu există țara respectivă sau nu există parteneri în acea țară.

CREATE OR REPLACE FUNCTION nr_parteneri (p_tara iordan_tari.nume%TYPE)
RETURN NUMBER
AS
nume_tara VARCHAR2(20);
nr_parteneri NUMBER;
nu_exista_parteneri EXCEPTION;
BEGIN
--Verificam daca exista tara
  SELECT nume INTO nume_tara
  FROM iordan_tari
  WHERE nume = p_tara;
  
  DBMS_OUTPUT.PUT_LINE('Tara: '||nume_tara);
  
--Verificam daca exista parteneri din tara respectiva
  SELECT COUNT(id_partener) INTO nr_parteneri
  FROM iordan_parteneri_comerciali p JOIN iordan_tari t ON p.id_tara = t.id_tara
  WHERE t.nume = p_tara;
  
  DBMS_OUTPUT.PUT_LINE('Numar parteneri: ' || nr_parteneri);
  
  IF nr_parteneri = 0  THEN RAISE nu_exista_parteneri;
  ELSE RETURN nr_parteneri;
  END IF;
  
EXCEPTION
 WHEN NO_DATA_FOUND THEN RETURN -1;
 WHEN nu_exista_parteneri THEN RETURN -2;
END;
/
  
--Apelare functie

DECLARE 
n NUMBER;
BEGIN
  n := nr_parteneri('&m');
  IF n = -1 THEN DBMS_OUTPUT.PUT_LINE('Nu exista tara!');
   ELSIF n = -2 THEN DBMS_OUTPUT.PUT_LINE('Tara exista, dar nu exista parteneri din aceasta tara!');
    ELSE DBMS_OUTPUT.PUT_LINE('Exista '||n||' parteneri in aceasta tara!');
  END IF;
END;
/

--Sa se creeze o funcție care să calculeze valoarea TVA-ului pentru un produs, având ca parametri valoarea produsului și procentul TVA-ului. 
--Ulterior, sa se utilizeze această funcție pentru a calcula și afișa TVA-ul pentru produsele din tabela iordan_produse, împreună cu ID-ul și prețul fiecărui produs.

CREATE OR REPLACE FUNCTION tva(valoare IN NUMBER, procent IN NUMBER)
RETURN NUMBER
AS
BEGIN
RETURN(valoare*procent/100);
END tva;
/

--Apel functie

SELECT id_produs, pret, tva(pret, 20) as tva
FROM iordan_produse;

--Sa se creeze o funcție care să calculeze prețul final al unui produs, având în vedere un preț inițial, un procent de discount și un procent TVA aplicat. 
--Funcția va returna prețul final după aplicarea celor două procente. 
--Ulterior, sa se utilizeze această funcție pentru a selecta ID-ul produsului și prețul final calculat doar pentru produsele a căror valoare finală este mai mare de 1000.

CREATE OR REPLACE FUNCTION pret_final(pret_initial IN iordan_produse.pret%TYPE, procent_discount IN NUMBER, procent_tva IN NUMBER)
RETURN NUMBER
AS
  pret_dupa_discount NUMBER;
  pret_dupa_tva NUMBER;
BEGIN
  pret_dupa_discount := pret_initial - (pret_initial * procent_discount / 100);
  
  pret_dupa_tva := pret_dupa_discount + (pret_dupa_discount * procent_tva / 100);
  
  RETURN pret_dupa_tva;
END pret_final;
/

SELECT id_produs, pret_final(pret, 5, 20) AS pret_final
FROM iordan_produse
WHERE pret_final(pret, 5, 20) > 1000 ;


---	Se cere crearea unei funcții în PL/SQL care să calculeze valoarea medie a comenzilor pentru partenerii comerciali dintr-o anumită țară. 
--Funcția va primi ca parametru numele țării și va returna valoarea medie a comenzilor efectuate de partenerii comerciali din acea țară.

CREATE OR REPLACE FUNCTION valoare_medie_comenzi(p_tara IN iordan_tari.nume%TYPE)
RETURN NUMBER
AS
  v_valoare_totala NUMBER;
  v_numar_comenzi NUMBER;
  v_valoare_medie NUMBER;
BEGIN
  -- Calculăm valoarea totală a comenzilor pentru partenerii din țara specificată
  SELECT SUM(e.pret * e.cantitate)
  INTO v_valoare_totala
  FROM iordan_exporturi e
  JOIN iordan_comenzi c ON e.id_comanda = c.id_comanda
  JOIN iordan_parteneri_comerciali p ON c.id_partener = p.id_partener
  JOIN iordan_tari t ON p.id_tara = t.id_tara
  WHERE t.nume = p_tara;

  -- Calculăm numărul total de comenzi ale partenerilor din țara respectivă
  SELECT COUNT(*)
  INTO v_numar_comenzi
  FROM iordan_comenzi c
  JOIN iordan_parteneri_comerciali p ON c.id_partener = p.id_partener
  JOIN iordan_tari t ON p.id_tara = t.id_tara
  WHERE t.nume = p_tara;

  -- Calculăm valoarea medie a comenzilor
  IF v_numar_comenzi > 0 THEN
    v_valoare_medie := v_valoare_totala / v_numar_comenzi;
  ELSE
    v_valoare_medie := 0;  -- Dacă nu există comenzi, valoarea medie este 0
  END IF;

  RETURN v_valoare_medie;
END valoare_medie_comenzi;
/

-- Apelarea funcției 
SELECT valoare_medie_comenzi('Franta') AS valoare_medie
FROM dual;

