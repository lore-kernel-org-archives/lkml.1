Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbXLLKCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbXLLKCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbXLLKCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:02:36 -0500
Received: from os.eurotux.com ([216.75.63.6]:44170 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbXLLKCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:02:35 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2007 05:02:34 EST
Date: Wed, 12 Dec 2007 09:55:47 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
Message-ID: <20071212095547.GB16469@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Rene Herman <rene.herman@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz,
	andi@firstfloor.org, rol@as2917.net,
	Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
	hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
References: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 12, 2007 at 12:31:18AM +0100, Rene Herman wrote:
>  Good day.
>=20
>  Would some people on x86 (both 32 and 64) be kind enough to compile and =
run=20
>  the attached program? This is about testing how long I/O port access to =
port=20
>  0x80 takes. It measures in CPU cycles so CPU speed is crucial in reporti=
ng.
>=20

$ sudo ./port80
cycles: out 2729, in 1872
$ sudo ./port80
cycles: out 2729, in 1872
$ sudo ./port80
cycles: out 2711, in 1856
$ sudo ./port80
cycles: out 2711, in 1856

model name      : Intel(R) Pentium(R) 4 CPU 1.90GHz
stepping        : 2
cpu MHz         : 1917.229
cache size      : 256 KB

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHX7AjinSul6a7oB8RApWrAJ9J0zOwBU2Kh6NCpPG2kpWR2gxregCbBMUT
0P8smb5N2/n1l3HrH7n1nSM=
=a0da
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
