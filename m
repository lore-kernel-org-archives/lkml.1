Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYBQTZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYBQTZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYBQTZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:25:09 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58504 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbYBQTZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:25:08 -0500
X-Sasl-enc: wnCTOWUqTntJlNrY2ROM2cI9F+ZhF+FTllsu4bUf2u/O 1203276306
Message-ID: <47B88A08.2070902@imap.cc>
Date: Sun, 17 Feb 2008 20:24:56 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
References: <200802171025.30590.elendil@planet.nl> <20080217131611.GA1403@cs181133002.pp.htv.fi>
In-Reply-To: <20080217131611.GA1403@cs181133002.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCD08D46D595C318C980832B8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCD08D46D595C318C980832B8
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 17.02.2008 14:16 schrieb Adrian Bunk:
> The real problem is that the kernel seems to lack functionality you=20
> require for doing some work.
>=20
> Why does your work on the Debian Installer depend on VirtualBox and
> can't be done with what the kernel already ships?

No, that's not the real problem. Even if the kernel didn't lack
any required functionality and it could all be done today without
VirtualBox, pulling the rug from underneath it like that leaves
all those who are currently relying on it without the ability to
continue testing newer kernels until they find the time to redesign
their working environment. Sticking to the removal schedule could
have avoided that.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enigCD08D46D595C318C980832B8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHuIoQMdB4Whm86/kRAnetAJ9gN1nBrcRI81OvkPoXIIsyO+46CgCfdmpr
1w2VvZ4fdjgSmm0hZHTepiM=
=VrLr
-----END PGP SIGNATURE-----

--------------enigCD08D46D595C318C980832B8--
