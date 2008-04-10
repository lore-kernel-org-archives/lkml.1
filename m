Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbYDJPUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbYDJPUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbYDJPUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:20:36 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:4239 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628AbYDJPUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:20:35 -0400
Message-ID: <47FE3020.1070502@imap.cc>
Date: Thu, 10 Apr 2008 17:20:00 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: lkml@rtr.ca, yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
References: <47FD138B.2060801@rtr.ca>	<20080409.152933.132174258.davem@davemloft.net>	<47FD590C.5020003@rtr.ca> <20080409.182228.193699767.davem@davemloft.net>
In-Reply-To: <20080409.182228.193699767.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig001EA754A42113F06C2FF275"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig001EA754A42113F06C2FF275
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

David Miller schrieb:
> From: Mark Lord <lkml@rtr.ca>
> Date: Wed, 09 Apr 2008 20:02:20 -0400
>=20
>> Really, folks.  Bug reports are intended to *help* the developers,
>> not something to be thrown back in their faces.
>=20
> It's a two way street, we asked for a bisect which helps us a lot.
>=20
> In fact, lately I notice a strong unwillingness to bisect on your
> part, in particular.

Bisecting is a time-consuming process. If unwillingness to bisect
is unacceptable in a bug reporter then people who don't have the
time to bisect must stop reporting the problems they encounter.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig001EA754A42113F06C2FF275
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH/jAgQ3+did9BuFsRAmrMAJ9hVadMs4gXgl/sZtszbU8Qnt4XAACcD5Al
iSkk8McO+zjF+yE7HhOqRfI=
=c8i8
-----END PGP SIGNATURE-----

--------------enig001EA754A42113F06C2FF275--
