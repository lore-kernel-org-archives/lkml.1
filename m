Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbXE0WNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbXE0WNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 18:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbXE0WNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 18:13:06 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41582 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbXE0WNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 18:13:05 -0400
X-Sasl-enc: KkMQiAcAkZf8rkmUIJVrcqYEqlIRwFkn7TfMaVtv8NSX 1180303982
Message-ID: <465A033C.3070400@imap.cc>
Date: Mon, 28 May 2007 00:16:28 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>	<46585953.80200@imap.cc> <20070526090117.dda72286.akpm@linux-foundation.org>
In-Reply-To: <20070526090117.dda72286.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig69B9A30669CC6BE75A7D14F9"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig69B9A30669CC6BE75A7D14F9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 26.05.2007 18:01 schrieb Andrew Morton:
> On Sat, 26 May 2007 17:59:15 +0200 Tilman Schmidt <tilman@imap.cc> wrot=
e:

>> This breaks network initialization on my SuSE 10.0 box [...]
>=20
> Thanks.  I think others have seen similar things and it was attributed =
to
> driver-core-check-return-code-of-sysfs_create_link.patch.

That's it. After reverting that patch, the Ethernet interface
comes up fine again.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig69B9A30669CC6BE75A7D14F9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGWgM8MdB4Whm86/kRAu1ZAJ0adXqJlzde0eRaR35cl+IYe4MVugCggejM
d5qfi5fMIik7eYE7Vt6y8hc=
=WwCW
-----END PGP SIGNATURE-----

--------------enig69B9A30669CC6BE75A7D14F9--
