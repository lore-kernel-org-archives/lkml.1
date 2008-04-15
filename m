Return-Path: <linux-kernel-owner+w=401wt.eu-S1764911AbYDQRbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764911AbYDQRbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYDQRb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:31:28 -0400
Received: from mout0.freenet.de ([195.4.92.90]:42088 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbYDQRb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:31:27 -0400
Date: Wed, 16 Apr 2008 00:15:08 +0200
From: Michelle Konzack <linux4michelle@freenet.de>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm <linux-arm@vger.kernel.org>
Subject: =?iso-8859-1?B?SbJD?= and 1-Wire modules
Message-ID: <20080415221508.GO2895@freenet.de>
Mail-Followup-To: linux4michelle@freenet.de, linux-arm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpgPcFyQO6wM49Um"
Content-Disposition: inline
X-Message-Flag: Improper configuration of Outlook is a breeding ground for viruses. Please take care your Client is configured correctly. Greetings Michelle.
X-Disclaimer-DE: Eine weitere Verwendung oder die Veroeffentlichung dieser Mail oder dieser Mailadresse ist nur mit der Einwilligung des Autors gestattet.
Organisation: Tamay Dogan Network
X-Operating-System: Linux tp570.private 2.4.27-2-686
X-Uptime: 23:33:11 up 1 day,  3:02,  9 users,  load average: 0.38, 0.54, 1.04
X-Homepage: http://www.debian.tamay-dogan.homelinux.net/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IpgPcFyQO6wM49Um
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

########################################################################
NOTE: since I do not know, whether my subscription was successful,
      please keep me in the MFT or Cc: me to all replies.
########################################################################

Hello Developers and Contributors,

Currently I am building my own ARM922T and ARM11 based computers (for my
needs) and have the HEAVY use for I=B2C and 1-Wire  stuff.  Furtunately  I
have Evaluation Kits/Boards for most stuff from NXP, Maxim and Dallas.

My question is now, HOW to start coding Modules for the various I=B2C  and
1-Wire chips?

Note:   I am talking about 20-40 modules since, e.g. for the  1-Wire
        I have found only a temperature sensor but  I  need  support
        for:

       *DS18B20     Programmable Resolution 1-Wire Digital Thermometer
        DS18S20     High-Precission 1-Wire Digital Thermometer
       *DS1372      I=B2C, 32-Bit, Binary Counter Clock with 64-bit
        DS1825      Programmable Resolution 1-Wire Digital Thermometer with=
 4-Bit ID
        DS1904      RTC iButton
       *DS1923      Hygrochron Temperature/Humidity Logger iButton with 8kB=
 Data Log memory
       *DS2401      Silicon Serial Number
       *DS2405      Addressable Switch
        DS2406      Dual Addressable Switch Plus 1 kbit Memory
       *DS2408      1-Wire 8-Channel Adressable Switch
       *DS2413      1-Wire Dual Channel Addressable Switch
       *DS2415      1-Wire Time Chip
        DS2417      1-Wire Time Chip with Interrupt
       *DS2438      1-Wire Smart Battery Monitor
       *DS2450      1-Wire A/D Converter
        DS2480B     Serial 1-Wire Line Driver with Load Sensor
       *DS2482-100  Single-Channel 1-Wire Master
        DS2502-E48  48-Bit Node Address Chip
       *DS3502      High-Voltage, NV, I=B2C POT with Temp Sensor and Lookup=
 Table
        DS4412      Dual-Channel, I=B2C Adjustable Sink/Source Current DAC
        DS4422      Two-Channel, I=B2C, 7-Bit Sink/Source Current DAC
        DS4424      Four-Channel, I=B2C, 7-Bit Sink/Source Current DAC

       *MAX3421E    USB Peripherial/Host Controller with SPI Interface
       *MAX7367/8/9 4-Channel I=B2C Switches/Multiplexer

       *ISP1160     Embedded Universal Serial Bus Host Controller
        ISP1582     Hi-Speed Universal Serial Bus peripherial Controller
        ISP1760     Hi-Speed Universal Serial Bus Host Controller for embed=
ded applications
        PCA8575     Remote 16-bit I/O expander for I=B2C-bus with interrupt
        PCA9510/1   Hot swappable I=B2C-bus and SMBus buffer
       *PCA9513/4   Hot swappable I=B2C and SMBus buffer
       *PCA9546A    4-channel I=B2C-bus switch with reset
       *PCA9548     8-channel I=B2C-bus switch with reset
        PCA9564     Parallel bus to I=B2C-bus controller
       *PCF8574     Remote 8-bit I/O expander for I=B2C-bus
       *PCF8575     Remote 16-bit I/O expander for I=B2C-bus
       *PCF8584     I=B2C-bus controller
        TDA8030/1   USB smart card Reader (OTP and ROM)

        (the with * maked one are the most importand for me and need
        to be coded first)

        Also I should note, that for the most chips I have Evaluation
        Boards/Kits and currently I am using a NXP LH7A404 (ARM922T) to
        try out the stuff

        And of course, the working modules will be GNU GPL version 3.

Since currently I live in a place where I can not get ADSL, I can only
reply 2-3 times per week.

Thanks, Greetings and nice Day
    Michelle Konzack
    Systemadministrator
    24V Electronic Engineer
    Tamay Dogan Network
    Debian GNU/Linux Consultant


--=20
Linux-User #280138 with the Linux Counter, http://counter.li.org/
##################### Debian GNU/Linux Consultant #####################
Michelle Konzack   Apt. 917                  ICQ #328449886
+49/177/9351947    50, rue de Soultz         MSN LinuxMichi
+33/6/61925193     67100 Strasbourg/France   IRC #Debian (irc.icq.com)

--IpgPcFyQO6wM49Um
Content-Type: application/pgp-signature; name="signature.pgp"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD4DBQFIBSjsC0FPBMSS+BIRAoe2AJdhtaR12YZ4d3cD00mFzlDGbnViAJ9nlGmj
BCcsecNKvbmThLErVP06pA==
=2sZa
-----END PGP SIGNATURE-----

--IpgPcFyQO6wM49Um--

