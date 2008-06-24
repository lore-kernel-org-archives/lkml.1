Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbYFXJpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbYFXJpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYFXJpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:45:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47274 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbYFXJpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:45:21 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] uio-howto.tmpl: use standard copyright/legal markings
Date: Tue, 24 Jun 2008 05:45:18 -0400
User-Agent: KMail/1.9.9
Cc: hjk@linutronix.de, linux-kernel@vger.kernel.org
References: <1214190762-26974-1-git-send-email-vapier@gentoo.org> <20080624002005.defb45d3.akpm@linux-foundation.org>
In-Reply-To: <20080624002005.defb45d3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1246389.0UqnL1IOIK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200806240545.19494.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1246389.0UqnL1IOIK
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 24 June 2008, Andrew Morton wrote:
> On Sun, 22 Jun 2008 23:12:42 -0400 Mike Frysinger <vapier@gentoo.org> wro=
te:
> > The Userspace I/O HOWTO document uses straight <sect1> tags and plain
> > text to describe copyright/legal information.  It should instead use the
> > <copyright> and <legalnotice> tags like all other documents in the
> > kernel.
>
> There are conflicting changes in this file in linux-next.

i'll take a look

> > +	<holder>Hans-J__rgen Koch.</holder>
> > -      Copyright (c) 2006 by Hans-J__rgen Koch.</para>
>
> Oh dear, that got mangled at your end, or in transmission.  It seems to
> be mangled in mainline too.   This happens a lot.

i doubt it was on my end since i didnt modify the code, but i dont think it=
's=20
mangled either.  it looks like a standard UTF8 umlaut to me.
=2Dmike

--nextPart1246389.0UqnL1IOIK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJIYMIvAAoJEEFjO5/oN/WBd6cQANa3h1ewDGzIhxssv5G3ol/s
QN3/I0FoAdrU9izxbBiSMTofuBh7n/U49Y1Efv/TVuStIs3O/tWmh7q/xqyLzReU
WNUbopdOQyigxDz9Xnbqmjq9wmorshJPex62idT9qR5dS9VqHTXnDU7106p4SolR
w2rQUuKd80NBl7As7HZqiN10kCe6xq/hSxljuGTbPQ8b1ftAKWD7v0qdSYrs/3LP
X+Jc8jI9uXvv44SwDzcn6J8Cip7N8jPFaa/e/BdQ1nVR7T0zUIbdDWluwo4xlgwq
KKCfUyVu71Li7oKEFshKENP0QvG/MCjXHgO+1c11TnrG3IYM6G3FMoT59aOsVYH3
lhUtdeUUB2fh5OxJC+DW5yCSWE//lVpdBXUzlVbwz0a/cnC65wKJP38h/HKbRr7t
DzbFflAmePZWH4f0TQSrs0MojcGKg+EnF8AX5ihMVuNu9AKEpHivMk0unqsMLPhJ
hprtCxxrQk4swJkJhMyRH1f6RA5BQAMD1EIY7w6fvwFzRNWPH1reVhl//tVmtoxL
SPc/3v+fI7WBuFQbcq0tHImM9pcUwHv+dVH3JmdocJrkpyLBBnnHvrN6O+jpjeuq
3jG6knhGAh0LgAtVgeugGT5TAsUAhH90QFGTjsTP8Jd4J8jLplBx1k/cKd12OZUT
kWfTXH7yIJ6MP160V2wF
=E0SU
-----END PGP SIGNATURE-----

--nextPart1246389.0UqnL1IOIK--
