Return-Path: <linux-kernel-owner+w=401wt.eu-S1761591AbXEMXyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591AbXEMXyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 19:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbXEMXyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 19:54:08 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42272 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754948AbXEMXyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 19:54:07 -0400
X-Sasl-enc: /rmc5U4z2JoefIlhaYIE2gARDEUNzLkCtcdfhFhjrk/G 1179100445
Message-ID: <4647A5D9.3090100@imap.cc>
Date: Mon, 14 May 2007 01:57:13 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.22-rc1
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>	<4647569D.7010709@imap.cc> <20070513.162059.78710763.davem@davemloft.net>
In-Reply-To: <20070513.162059.78710763.davem@davemloft.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig60455DAD210A2E188B118ED5"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig60455DAD210A2E188B118ED5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 14.05.2007 01:20 schrieb David Miller:
>>
>> ESP Scsi Driver Core (SCSI_ESP_CORE) [N/m] (NEW)
>=20
> This one is a case where the option makes no sense by itself,
> it provides the core common code for other front-end drivers.
>=20
> The documentation exists in those front end drivers, which
> in turn auto-matically select and enable this config option.

Thanks for the explanation. I never saw those other front-end
drivers, perhaps because for lack of information I just chose
the default of "N" on this one.

> It would be nice if there was a Kconfig way to not provide
> this thing at all unless one of the front-ends got selected
> but on the otherhand I like how anyone can select it and thus
> test the build of it :-)

Well, as it stands, I am presented with that option but I don't
have the faintest idea what "ESP" is and whether it would even
be worth attempting to compile it. I would have preferred to
see at least a short explanation of the term in order to decide
whether it would be worth trying.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig60455DAD210A2E188B118ED5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGR6XZMdB4Whm86/kRAqGjAJ9IZSCOFbDPtfyeYz22ymAiC4DxVQCfbJWp
ZzOg3SXD42QerOhMfVIof7A=
=B9vP
-----END PGP SIGNATURE-----

--------------enig60455DAD210A2E188B118ED5--
