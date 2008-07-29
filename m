Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYG2MJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYG2MJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757608AbYG2MJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:09:40 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:46179 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145AbYG2MJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:09:38 -0400
Subject: Re: 2.6.27-rc1: zd1211rw association fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
In-Reply-To: <20080729120442.GE9378@mit.edu>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
	 <200807291049.47342.alistair@devzero.co.uk>
	 <1217326195.10489.10.camel@johannes.berg>  <20080729120442.GE9378@mit.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dqFTqhpDYuxtj2ErFIQS"
Date: Tue, 29 Jul 2008 14:09:19 +0200
Message-Id: <1217333359.10489.38.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dqFTqhpDYuxtj2ErFIQS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 08:04 -0400, Theodore Tso wrote:
> On Tue, Jul 29, 2008 at 12:09:55PM +0200, Johannes Berg wrote:
> > This is about the 100 millionth time this is reported. Please try the
> > patch I just posted.
>=20
> Yeah, it's really too bad -rc1 got released just before you were able
> to post the fix to this, since if there were 100 million people who
> were trying out kernels starting with -git7 that use wireless, there
> will probably be 200 million people trying out -rc1.  :-)
>=20
> Thanks for finding and fixing it, though.  I stopped trying out
> kernels after -git6 since I was travelling at OSCON, and not having
> wireless was a show-stopper for me....

If everybody's going to decide now to hit on _me_, I'll point out that
davem's MQ TX changes broke it, I only heard about the problem once that
was out because nobody had found it earlier, and I was also travelling
at OLS.

Maybe the lesson we could learn from this is to not release an rc1 while
a bunch of important people are at various conferences.

johannes

--=-dqFTqhpDYuxtj2ErFIQS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjwhrAAoJEKVg1VMiehFY6dEP/2lg8SaEuRNLLFo2T8H9863W
5n88QtaULrVamQV4F9TCvuWsshGqzWes6DABsONyY426SyvmUwzitUIYRQjV8DHt
HxdfTy0PuK9kEO542koJZEsBPSMLz84biAXOiV6aIVQnl1wbZk/N3MLl/+RM1MJe
QW3cwzWZQUz7PpId/EqkVM3AngMQ5jl/IiuxrR1aRNdGN+yIMr+nquZB4m9LnGlL
CIHZnCZc27FsNY45YSpUIcKqPGN7ptLQsOQfx3u2zDuuaJOvhwdqKlbsVdyYMZIF
wPbMQNOCiphfzp1zNyaa/Gj3plbQJYN4+lTMSCGk4JuXZSZQA62xQlbaEY5E1gjp
vQ/4TI+dRk6xrLH1nG1SZ6OJybyBC316+lt6ocXonNZCqMRqC+u+zArWnYlE8RuE
4jan/bBa/e9AnjF/sAyPzAMfXNQqMFjsLaZxap+QdY1WGXZCeIGlwmUH1UeHGDJ6
hFLz/frZSLn+BhR9iOde//Mni9aAnNHTWDVHW6ZKmUcn2sfeNZEZ3uaIPb6Q3lrv
/AETQ9FBjJNiLm5ApSjrMwQp2vLFIy0iDsGuixRL48vGRXQwZzMvx9Mv7HbvDGHO
fjbFvCPtVVfG+7GXuJ7Cm3FMxX+IwHY8zUdWMDZl+rSe4EUXIaX76UFK7wwSkPhT
lb91bhvsuuCajFtgqLjh
=K2l+
-----END PGP SIGNATURE-----

--=-dqFTqhpDYuxtj2ErFIQS--

