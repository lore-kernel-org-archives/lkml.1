Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYEPOeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYEPOeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbYEPOeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:34:23 -0400
Received: from server4.pinguin-hosting.de ([88.198.11.108]:36151 "EHLO
	server4.pinguin-hosting.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbYEPOeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:34:22 -0400
Date: Fri, 16 May 2008 11:55:29 +0200
From: Michelle Konzack <linux4michelle@tamay-dogan.net>
To: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Hardware designt to prevent Damages... [WAS: [patch 23/37] i2c-piix4: Blacklist two mainboards]
Message-ID: <20080516095529.GS3279@freenet.de>
References: <20080513200453.064446337@mini.kroah.org> <20080513201225.GX31167@suse.de> <20080514195253.GB5673@freenet.de> <Pine.LNX.4.61.0805151346530.14844@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cGfB/trNgB3WtPHu"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0805151346530.14844@chaos.analogic.com>
X-Message-Flag: Improper configuration of Outlook is a breeding ground for viruses. Please take care your Client is configured correctly. Greetings Michelle.
X-Disclaimer-DE: Eine weitere Verwendung oder die Veroeffentlichung dieser Mail oder dieser Mailadresse ist nur mit der Einwilligung des Autors gestattet.
Organisation: Tamay Dogan Network
X-Operating-System: Linux tp570.private 2.4.27-2-686
X-Uptime: 11:50:29 up 14:20,  6 users,  load average: 0.88, 0.57, 0.45
X-Homepage: http://www.debian.tamay-dogan.net/
User-Agent: Mutt/1.5.9i
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri May 16 16:34:22 2008
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 482d9b6d225781071919212
X-DSPAM-Factors: 27,
	once, 0.40000,
	could, 0.40000,
	IRC, 0.40000,
	anything+>, 0.40000,
	anything+>, 0.40000,
	should+replace, 0.40000,
	hurt+anything, 0.40000,
	hurt+anything, 0.40000,
	X-Disclaimer-DE*mit, 0.40000,
	Content-Type*micalg=pgp, 0.40000,
	>+process, 0.40000,
	a+real, 0.40000,
	END+OF, 0.40000,
	shouldn't+be, 0.40000,
	most+of, 0.40000,
	Url*li, 0.40000,
	security+is, 0.40000,
	Date*May, 0.40000,
	an, 0.40000,
	an, 0.40000,
	nice+Day, 0.40000,
	instructions+that, 0.40000,
	linux, 0.40000,
	MSN+LinuxMichi, 0.40000,
	Consultant+Am, 0.40000,
	from, 0.40000,
	to+go, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cGfB/trNgB3WtPHu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Dick,

Thank you for the answer...

Even if I use several times an I2C current Sink/Source converter
=66rom Dallas/Maxim the security is done by Hardware design...

So nobody will burn my Atmel ARM1176.


Thanks, Greetings and nice Day
    Michelle Konzack
    Systemadministrator
    24V Electronic Engineer
    Tamay Dogan Network
    Debian GNU/Linux Consultant



Am 2008-05-15 13:57:35, schrieb linux-os (Dick Johnson):
> Many (perhaps all) modern computers perform the final building
> process upon power up. This usually involves writing bits to
> some gate-arrays and performing hardware initializations with
> registers that disappear once the machine starts acting like
> a real PC. I wrote a BIOS for the AMD SC520 and most of the
> code involved "building" the machine. However, there was an
> unwritten rule that nothing could be done to hurt anything.
>=20
> There is only one CPU that I know of, the 56000 DSP, that
> can be configured with insane instructions that will hurt
> it.
>=20
> Nowadays, more power adjustment stuff is being put where
> it shouldn't be. A bad bit somewhere may cause a power
> supply to go out of regulation and burn out something
> (like the CPU). If you find something like this, the
> machine vendor should replace the machine and/or the
> machine should be black-listed. We can't have computers
> in which a random event such as an alpha-particle upset
> can actually hurt anything.
>=20
> Cheers,
> Dick Johnson
> Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
> My book : http://www.AbominableFirebug.com/
------------------------ END OF REPLIED MESSAGE ------------------------


--=20
Linux-User #280138 with the Linux Counter, http://counter.li.org/
##################### Debian GNU/Linux Consultant #####################
Michelle Konzack   Apt. 917                  ICQ #328449886
+49/177/9351947    50, rue de Soultz         MSN LinuxMichi
+33/6/61925193     67100 Strasbourg/France   IRC #Debian (irc.icq.com)

--cGfB/trNgB3WtPHu
Content-Type: application/pgp-signature; name="signature.pgp"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFILVoRC0FPBMSS+BIRAkA1AJ49AdtEKRUZP0Joxy14PIm2vF8a+QCeJVG7
vT+RZxJCBCsJJm/qW+lMuOo=
=5YUm
-----END PGP SIGNATURE-----

--cGfB/trNgB3WtPHu--


