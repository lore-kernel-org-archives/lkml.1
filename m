Return-Path: <linux-kernel-owner+w=401wt.eu-S932627AbZJaMEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbZJaMEM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 08:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932355AbZJaMEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 08:04:11 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41240 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932140AbZJaMEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 08:04:10 -0400
X-Sasl-enc: Z7ekLypEg+TZvozi3ZrzvtY8ru3oP9l6Zttdwb2wm7Dp 1256990654
Message-ID: <4AEC27AD.9060400@imap.cc>
Date: Sat, 31 Oct 2009 13:03:57 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
CC: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/16] trivial: fix assorted "success" typos
References: <b8bf37780910310240i55ec5e0ag74fee707bb4f5a8a@mail.gmail.com>
In-Reply-To: <b8bf37780910310240i55ec5e0ag74fee707bb4f5a8a@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC17F9138E4B671CD817B61EA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC17F9138E4B671CD817B61EA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 31.10.2009 10:40 schrieb Andr=E9 Goddard Rosa:
> Subject: [PATCH 01/16] trivial: fix assorted "success" typos
>=20
> Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
>=20
> diff --git a/Documentation/ABI/testing/procfs-diskstats

Please provide a diffstat for that kind of patches in the future.
I don't want to scan sixteen patches in their entirety just to
make sure none of them touches the little driver I maintain.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigC17F9138E4B671CD817B61EA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFK7Ce3Q3+did9BuFsRAjmMAJ0f3yYiicISXbT1sFKtnd9zINax9QCcD+On
ZXD00145xXaiPNoBT1Kp9W4=
=nYTk
-----END PGP SIGNATURE-----

--------------enigC17F9138E4B671CD817B61EA--
