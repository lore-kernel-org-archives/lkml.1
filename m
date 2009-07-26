Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbZGZPsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbZGZPsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 11:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZGZPsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 11:48:50 -0400
Received: from mail.open.by ([193.232.92.17]:64361 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbZGZPst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 11:48:49 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000003
X-SpamTest-Info: Profiles 9160 [Jul 26 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
X-SpamTest-Group-ID: 00000000
Date: Sun, 26 Jul 2009 18:51:21 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Frans Pop <elendil@planet.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@linux-foundation.org,
       rjw@sisk.pl, ray-lk@madrabbit.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Subject: Re: [Regression] kdesu broken
Message-ID: <20090726155121.GN3232@localdomain.by>
References: <200907240145.31935.rjw@sisk.pl>
 <2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
 <200907241721.45943.rjw@sisk.pl>
 <20090724164058.21a054e6@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
 <alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
 <20090725124859.530d158b@lxorguk.ukuu.org.uk>
 <200907251602.49918.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hlh2aiwFLCZwGcpw"
Content-Disposition: inline
In-Reply-To: <200907251602.49918.elendil@planet.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hlh2aiwFLCZwGcpw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/25/09 16:02), Frans Pop wrote:
> Date: Sat, 25 Jul 2009 16:02:48 +0200
> From: Frans Pop <elendil@planet.nl>
> To: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: torvalds@linux-foundation.org, rjw@sisk.pl, ray-lk@madrabbit.org,
> 	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
> 	Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> Subject: Re: [Regression] kdesu broken
> User-Agent: KMail/1.9.9
>=20
> Alan Cox wrote:
> > Linus Torvalds wrote:
> >> We don't do regressions. If user space depended on old behavior, we
> >> don't change behavior
> >=20
> > I think there are two bugs being confused here. The first kdesu bug
> > isn't the EIO one. It's just busted userspace code that happened to be
> > lucky.=20
> > It's also impossible to keep that "luck" going. The other problem is the
> > EIO - which is a bug.
> =20
> Just out of curiosity ad for reference.
> Has this issue already been reported to the KDE people? Any links to a bu=
g=20
> report or discussions there?
>=20

Not yet.

Sergey
--Hlh2aiwFLCZwGcpw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpse3kACgkQfKHnntdSXjSdIQQAwKMPM/kPDyPRKb/HMZTtxE8B
b548/FZTyiSa3WJIKltW03F4rDey0BNEqmxXo6a4kk/aWXl0qj/wdQpgPBnIKlRe
M/Z+KH/YJDPJfRJRlMfYm3U+BQC+/fC8GL9dewstqPqsvCQP+JD8thS1nK4MnE91
EHKqPgRo++vC6Olw1IY=
=1wkg
-----END PGP SIGNATURE-----

--Hlh2aiwFLCZwGcpw--
