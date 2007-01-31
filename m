Return-Path: <linux-kernel-owner+w=401wt.eu-S933031AbXAaLiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbXAaLiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 06:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933063AbXAaLiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 06:38:52 -0500
Received: from mail.phnxsoft.com ([195.227.45.4]:2131 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933031AbXAaLiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 06:38:51 -0500
Message-ID: <45C07FBF.3080000@imap.cc>
Date: Wed, 31 Jan 2007 12:38:39 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
References: <20070129204528.eb8d695e.akpm@osdl.org>	<45BFC442.5000903@gmail.com>	<45BFEDFB.6000500@imap.cc> <20070130172525.f32fb9ea.akpm@osdl.org>
In-Reply-To: <20070130172525.f32fb9ea.akpm@osdl.org>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig067A9A7812D5457B3812C790"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig067A9A7812D5457B3812C790
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Jan 2007 17:25:25 -0800, Andrew Morton wrote:
> On Wed, 31 Jan 2007 02:16:43 +0100
> Tilman Schmidt <tilman@imap.cc> wrote:
>=20
>> Am 30.01.2007 23:18 schrieb Maciej Rutecki:
>> > Second problem, power button doesn't work. When I pressed it, I has =
this
>> > error:
>> >=20
>> > ACPI Error (evevent-0305): No installed handler for fixed event
>> > [00000002] [20070126]
>>=20
>> Same here, minus the message. (Or perhaps I just don't know where to l=
ook.)
>> Problem also exists in 2.6.20-rc6-mm2. With 2.6.20-rc6-git1 the power
>> button of this machine works fine.
>=20
> That's significant - in your case at least the 2.6.20-rc6-mm3 ACPI upda=
te
> isn't the cause.

Is there anything specific I should test, or Big Bisect time?

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig067A9A7812D5457B3812C790
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFwH+/MdB4Whm86/kRAvNsAJoCvHBpCbTs+Jf151gdz4FqQ8Cw0ACePSRU
Bcqx7WKbAdEPncxYMdUdg54=
=L29q
-----END PGP SIGNATURE-----

--------------enig067A9A7812D5457B3812C790--
