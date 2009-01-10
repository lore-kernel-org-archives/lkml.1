Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbZAJLgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbZAJLgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 06:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZAJLgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 06:36:12 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:49069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbZAJLgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 06:36:11 -0500
Subject: Re: [PATCH] add b+tree library
From: Johannes Berg <johannes@sipsolutions.net>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
In-Reply-To: <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com> (sfid-20090110_120257_840405_DA86E81A)
References: <1231584446.3685.21.camel@johannes>
	 <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com>
	 (sfid-20090110_120257_840405_DA86E81A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dFXmL879Hnus5Tk8h887"
Date: Sat, 10 Jan 2009 12:37:08 +0100
Message-Id: <1231587428.3803.0.camel@johannes>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dFXmL879Hnus5Tk8h887
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-10 at 20:02 +0900, KOSAKI Motohiro wrote:

> > This adds a b+tree library. The API and memory layout is documented in
> > the header file lib/btree.h. There are tree versions for 32, 64 and
> > 128 bit keys as well as unsigned long (32/64 depending on platform).
>=20
> Can this library remove the btree code in some btree based filesystem?

Joern is going to use it for logfs, that's the point. Not sure about
other filesystems.

johannes

--=-dFXmL879Hnus5Tk8h887
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJaIhiAAoJEKVg1VMiehFY5yoQAKTL6Wi3SED2lPdbIAzDZVgO
SnWguadC821da6o5AKo+cWd9dJHGPxuBgleuse9daepKQewKtbhxGbKWtkp4bmir
3xnpXqxm0h3/2k1mQC1Opg+beSdTq2qnUXOxpePmx6HlMSvBOcmxh6sENZZQQEnG
9Ykue+to/nxYyWU9gU8QOsJPszWmAIGSw4hCtZiI4Tal/jg8br7kvQ6xpO0vMQmt
yteCGX/lDg5jIhP81GQqVs6Zq+joav4o2Wwf9eJRx8Kcx+/Xh8E1HI5Sx6VZ7gbq
Y04fuyw1wUWx0X6km4YchOyweWcYr0m+fJb1hOfYT9fGsWLzauw6IabArOBYkmmT
WLjKycmNcYdH4CgS4zP0v/Brv8ZrbfQ/ppFS2Pd8QihR/RltO1WmiZS8ILGqAvbH
5YGjXqx2C+kf1n3tdUKrlGKDBn7tZQbbWl1iCCOTIG5+UzOUPX63fcvWb1xGfdMy
MSKRhFAVC/CXVEdzZsuj8F7DP5sNtRXckIJy1lh3XuVHTe5+zzTy3FvHcuMBEtCt
PKoQhGMjm8QDiD5CeeBycxBVoxY7p7jP9mbMgrdLX21E1nUp6REAF9LvYmhmeVMa
vRwQ7syowz26rlUh8wa191/yz5rrVF4m1YOfB0nM0ebSzM/zqXWOiGq/CqXkdUkJ
rDYtjeD+RrCAQP8IRZ6b
=v1Bq
-----END PGP SIGNATURE-----

--=-dFXmL879Hnus5Tk8h887--

