Return-Path: <linux-kernel-owner+w=401wt.eu-S1762041AbXEZP4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041AbXEZP4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 11:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbXEZP4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 11:56:00 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47553 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbXEZPz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 11:55:59 -0400
X-Sasl-enc: ENhrcd38QO2abwPce/OomwIOJRo9RnIQOaVQ0F8osz50 1180194957
Message-ID: <46585953.80200@imap.cc>
Date: Sat, 26 May 2007 17:59:15 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
In-Reply-To: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7B3AD89DE203C34BCDA6F2B9"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7B3AD89DE203C34BCDA6F2B9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 23.05.2007 09:42 schrieb Andrew Morton:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc=
2/2.6.22-rc2-mm1/

This breaks network initialization on my SuSE 10.0 box once
again although I compiled with CONFIG_SYSFS_DEPRECATED=3Dy.
Acquisition of the IP address via DHCP times out.
Manual start (rcnetwork restart) doesn't help either.

I'll start bisecting as soon as the machine is free.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig7B3AD89DE203C34BCDA6F2B9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGWFlaMdB4Whm86/kRAunrAJ9E3LbgpB62gXZxNYpNjpZ609GNjQCfcQKg
8z+exEE91nVjS0afSkDhTqA=
=1ufK
-----END PGP SIGNATURE-----

--------------enig7B3AD89DE203C34BCDA6F2B9--
