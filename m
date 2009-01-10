Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZAJUVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZAJUVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 15:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZAJUVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 15:21:21 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:43973 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZAJUVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 15:21:20 -0500
Subject: Re: [PATCH] add b+tree library
From: Johannes Berg <johannes@sipsolutions.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <87fxjrgd9s.fsf@basil.nowhere.org>
References: <1231584446.3685.21.camel@johannes>
	 <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com>
	 <1231587428.3803.0.camel@johannes>
	 <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com>
	 <20090110183921.GD20611@logfs.org> <1231613042.3706.16.camel@johannes>
	 <87fxjrgd9s.fsf@basil.nowhere.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x98pdES3JyCT0SuyBu/T"
Date: Sat, 10 Jan 2009 21:22:20 +0100
Message-Id: <1231618940.3706.31.camel@johannes>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-x98pdES3JyCT0SuyBu/T
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-10 at 20:41 +0100, Andi Kleen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > Also, to elaborate on that answer, I'm going to use this as a sort of
> > hash table for wireless, where it ensures better scalability than a pur=
e
> > hashtable from quiet environments (say wireless off on an airplane) to
> > your wireless test lab (100+ access points)
>=20
> Is there any particular reason you can't use the standard rbtrees
> for that?

It just seemed like a lot of overhead, no particular reason I guess.

johannes

--=-x98pdES3JyCT0SuyBu/T
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJaQN5AAoJEKVg1VMiehFY4wQQAIiTB7Gz0vSwFe1DPywx2rk1
7vTTcopdtjyPz7IjWuTbUF6VD33wiGO9AP0NTn7L+ji/Pd5eiEPw+mh758YZ4Fli
AVxQ0IzVRHdEONPe90ERqaT4/ZfXbfcUgNIMRq/grQgHJja6253kE5baZzyyUHjF
e2AkU4ZggI2B7VA4Ampil7eEgChe7I/Z7SXjR6d778SWC+U5FvTMBzMqDz6baC4o
L7lUUkrj/AxB0Kv38PqzHc/dnXa1B4Mr5pmtbZ+iUBv3QnitgtS/a3kBK+Ebb6mo
cLy3oU3onq/dDsR6A3iS4xi7gtvBi7iesEdpoRowKzGyRkpj4HwVmQ2mkAFsn18p
4StN9naYQDsP85nwKPzBbRaczf7qbZtj94SLCyE65RTUeBypVUDecCT34DnESTze
1M83hoxbYPRDW3a1H6a1p4Xxbe0u5gHnUdny0YaT4ZI4gKx7oHCZ0fNwECyXK4Rh
jNCNmAGAgHL01BdPmsFB/o7iUtjqcyb/0gEef0nvCCblo6e26Lh/EHbPTGWFLOGD
TYb1ZMErA71+oyjdgMrVZRsFOtw5hGj/NtrMUE9nBWwG4xx9CFWduUOdQUjDXVYi
kqD9Ff9vYGDWdENVyvW6PVbzy8jFex5IVbzOIJXgAf1qC+W8QInfpd9AMSFOSD0a
Zlq7ubOic7ETpxIoJoqq
=0qC2
-----END PGP SIGNATURE-----

--=-x98pdES3JyCT0SuyBu/T--

