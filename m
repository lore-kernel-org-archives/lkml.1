Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbZCIHVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbZCIHVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 03:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZCIHV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 03:21:29 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:37598 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZCIHV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 03:21:29 -0400
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
In-Reply-To: <20090308223304.GB11513@kroah.com>
References: <43e72e890903022314o44ae710u834d6207403fd4a2@mail.gmail.com>
	 <1236514065.4205.9.camel@johannes.local> <20090308223304.GB11513@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D3nx8hRR5oBOMxklDAIO"
Date: Mon, 09 Mar 2009 08:21:22 +0100
Message-Id: <1236583282.4205.71.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-D3nx8hRR5oBOMxklDAIO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-08 at 15:33 -0700, Greg KH wrote:

> > FWIW, I would MUCH prefer if the staging crap never passed any official
> > mailing lists.
>=20
> What do you mean by this?  You don't ever want to see any staging
> patches on any mailing lists?  That doesn't sound helpful.

Staging drivers will typically be an extremely huge amount of crap that
just floods mailing lists. I don't care about those I don't read, but I
would prefer to not have wireless staging drivers cross the wireless
list which makes it seem like somebody is actually interested in those
drivers.

> I can provide a simple procmail rule if you really don't like this kind
> of thing, but that seems pretty extreme...

I can very well filter on my own, thank you; I'm more worried about the
noise for random third parties who then infer that this is something
that somebody is working on and that might be useful to work on for
them. Neither of that is true for any wireless staging driver, they all
require complete rewrites that can, imo, use the old code only for
reference, not for implementation.

johannes

--=-D3nx8hRR5oBOMxklDAIO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJtMNvAAoJEKVg1VMiehFYcy8P/i7rIj7k9gFx6Ig1IuSZL+zD
nT40AZH6Xu+zk1jv4Rg3eVBkvqdh2LDRcocgvWTIegxMhHzR1b6KTeOqY4D1DfeS
xQryrcw3LBf7F9g4NjBdpGZNPI4JBnIpxLHni9IDIRk/GRML/Y0SSdUJkjTmpGzz
KpgVwzbPVgTz/8VT5JdRzFU87nDT6NTN7cCrRHW6usv8SdnEyh+0t7cyu3wfFLZV
g9V3bv8u2V5Y9GRXmvYxnnSvcFjjmu7ohB7xbjI51JbtHOIkFTdnuNB+l9qMhERj
jb/6r8+t58Lr/av+gdiwsU7IvZkR6606ZA6o08QCvKummFOe6oBwuqinC/ZcMLQA
4fHYruW3s9X3XwnjwcGtc0zmKVPJjatYsk5VvXf48XEViFCa5VsQsJKFn9kmjITn
mbHs1n+lXYD12IRteODspWNHLfiS1/ZrRb369kIs76gCyNsgTi8OfiaeNXu1xGCd
1YJmOULzhNt14saVM92usvN6gPLQH44UpGv8xeRsl8WFBLGB1PVZVmg/OPZxtpds
3/B1RRMt6+pP2WSqxIuHMs3Fap3I4HMi2JKoVhjYD8xqdz+dKRL0aVle6+759EcE
ISUjPMz99llTjnecRiO07euV/1NTvz3ZsUqNGUkThY4A/DoRUxE4EFglLNaULCBM
ESe1FNujYNLG4zD53sRO
=b52T
-----END PGP SIGNATURE-----

--=-D3nx8hRR5oBOMxklDAIO--

