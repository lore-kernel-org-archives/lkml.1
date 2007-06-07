Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbXFGI3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbXFGI3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbXFGI2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:28:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63433 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbXFGI2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:28:54 -0400
Date: Thu, 7 Jun 2007 10:26:09 +0200
From: Mario Guenterberg <mg@havelsoft.com>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: some iwlwifi problems
Message-ID: <20070607082609.GA4603@/bin/dnsdomainname>
Reply-To: linux-kernel@vger.kernel.org
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
Organization: havelsoft.com
X-Operating-System: GNU/Linux (Kernel 2.6.22-z61m)
X-PGP-Key: http://www.havelsoft.com/misc/mg_pubkey.asc
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Provags-ID: V01U2FsdGVkX18ijS7uT0JzXkmmJgMa6rcgM1GZ2EY+yXvYCVY
 VKDPJKguDcRz6AjZJ4CKxpXyqtqWs46dhWRtvtpiCDltubkDgl
 0lXOGgzMes52A3TbrkNTw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi...

I have compiled the 2.6.22-rc4 kernel with the mm1 patchset.
It works fine for my z16m lenovo laptop. The only mistake I have is
the iwlwifi driver for the Intel Corporation PRO/Wireless 3945ABG
network controller. The bitrate settings are sometimes very different.
Sometimes it says 6 Mb/s, sometimes 11 Mb/s or 54 Mb/s and maybe=20
sometimes 5.5 Mb/s.

The other thing is the message in log:
wlan0: duplicate address detected!
I have no machine with the same address in my network and no other
accesspoint in the range of my wlan.

With the 2.6.22.3 kernel and the iwp3945 driver the bitrate settings=20
only 54 Mb/s and the message never found in logs.

Thanks
Mario

--=20
 -----------------------------------------------------
| havelsoft.com - Ihr Service Partner f=FCr Open Source |
| Tel:  033876-21 966                                 |
| Notruf: 0173-277 33 60                              |
| http://www.havelsoft.com                            |
|                                                     |
| Inhaber: Mario G=FCnterberg                           |
| M=FCtzlitzer Strasse 19                               |
| 14715 M=E4rkisch Luch                                 |
 -----------------------------------------------------

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iQIVAwUBRmfBIDUZahlMISn3AQLhfQ//ZYxclS/ylF+Z9ANWs004k0DoaNdUH84W
GJPvr/hbfLuFRSL2ZQHAwLf7YJnhmnyR1kYKk8B2PC2CELX0BWtAil257RALxX3y
RHO73PlU+WU3BKAIVWjopXI+Z9q4yLe+sD6pMX+fV3AulmyJewm6U80uAz4wOI3p
+q3z27YLKS6IGxPBTlTy/hAAsO5sYCovMLAD90L376wxx7zAFb2jCqIBfwgTKp2N
hkr9PogcAhul7OL6tvJgRCBkkPuMwQbxVJ4okrTlEcvhgLD4E31Us10bav66uIJu
pFKOEqUo/5jgf2jhgtEN3kCGjPJSXOIYgjlMEDh/Pe7wioeu09sftlg2xqSQHwmS
FGzZWGO+QWYgErFeb5SU0l4B8VRnx3B2+6hAlZ+8VdCtq00c/wVj3e7Nv1S80UmT
LGPVOUKPJ+xXLYZNgLCOnQQu3PyRtQ67q0ykKE6gkPgVTfrYCNcAUnrJ0FrtQ2Ws
J/+qweOGaxGfK5xVXjLZP05PuuYs4UOSYWBn+lRuO/UpEyF3c5ZvZE8tBZhpfu4F
DtHvmS3T6zl/vOLHtSeDtLsQc2hPJj6Q8n3wOAysS9z/gckdnB0Z5RttdIyfR80M
CoQ/SPpvVTPHgTOqqjHjx6SH1wxz5B+xhqWL53vV01TpD5i1JrHnKYROm+8+WrDH
+TTNsb2+jmk=
=r5PZ
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
