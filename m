Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZCIVUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZCIVUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 17:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZCIVUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 17:20:41 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:35934 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbZCIVUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 17:20:40 -0400
Subject: Re: Staging, place holder for better company/community development
	model
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jouni Malinen <j@w1.fi>, Sujith <m.sujith@gmail.com>,
       Sujith <Sujith.Manoharan@atheros.com>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Christoph Hellwig <hch@infradead.org>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <20090309194132.GB15011@kroah.com>
References: <43e72e890903022314o44ae710u834d6207403fd4a2@mail.gmail.com>
	 <1236514065.4205.9.camel@johannes.local> <20090308223304.GB11513@kroah.com>
	 <1236583282.4205.71.camel@johannes.local>
	 <20090309194132.GB15011@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r4vNaWHk8oTfboTlKhQD"
Date: Mon, 09 Mar 2009 22:20:33 +0100
Message-Id: <1236633633.9658.23.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-r4vNaWHk8oTfboTlKhQD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-09 at 12:41 -0700, Greg KH wrote:

> > Staging drivers will typically be an extremely huge amount of crap that
> > just floods mailing lists. I don't care about those I don't read, but I
> > would prefer to not have wireless staging drivers cross the wireless
> > list which makes it seem like somebody is actually interested in those
> > drivers.
>=20
> I was asked by the wireless maintainer and some of the wireless
> developers to send such patches to the list, so that everyone knows
> exactly what is going on in the staging tree.

This is a misrepresentation, a number of people have asked for this on
specific drivers they are actively working on and that already are in
usable shape.

> That's not true, some of them are being reworked as you type, to be a
> "real" wireless driver eventually.
>=20
> Incremental development over time is sometimes a good thing, instead of
> total rewrites :)

Except it doesn't work for most of the wireless drivers you've sucked in
without asking any wireless developers whether that makes any sense or
not.

johannes

--=-r4vNaWHk8oTfboTlKhQD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJtYgfAAoJEKVg1VMiehFYm7UP/jh8Bfn8xauZhduZAUYneEBH
xMceyMzUIvfFO0JHLFN8OoS/X2QN2oo3gkMlikSUINDa4FbfLI3hV41i9QGjGJlG
5tnkmuwvkpfp4s6ejhTouOaRCPiQV2hwB4/yERNwPybCoe7p0AzuRwtY88deMn9q
FttQiql0dTjX67vcFfQn/Hl4M+E4aOk86z70x2il28Shouqc2w0nxl2199AwH/4q
yA1VlP3nf6cD55rk8HxEhb85DrkH35vtTvPZCOrtY3YT3Iil14yfcmZDhJheaLly
okRu56BXr2Wmenmf5vR+ym5ahRRL6HDJ0LinVXSxydtNem6CjvOMr89ePR074alp
WdBhL3HqSb+vnw518sQGzUK3d1IIjXGJM1jLm4ye22Y3hNA/g/ULbukxwWfkye3F
+A+LOZQzODflxMWaDo8fja6RecQU+En4SfvL5hfQ7hum9ZhyWd67ds7q1nbfS5Ir
hevsYBUJkGptG1M7WwvW6rGbRvhgQ40QipdjwH1Z/EUaQWDoIEw5shvd/0nabrPU
HVJpm0/jGlulZCmOmohjTzqwVf7VlE/bLo7ie0e/4YcdqecLBcgQ3wrs28SeLdZV
zR3lyYO3KA+zTytREHIj+QO670ph0wRZe8lW2fXvcRdrAQqn6aMXws6tr45gltcx
6gWKSFkEQyRu8OBN8wOu
=fASU
-----END PGP SIGNATURE-----

--=-r4vNaWHk8oTfboTlKhQD--

