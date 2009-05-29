Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZE2XO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZE2XO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 19:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZE2XOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 19:14:48 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:37020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbZE2XOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 19:14:47 -0400
Subject: Re: [PATCH] ath5k: added initial RFKILL support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tobias Doerffel <tobias.doerffel@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, Jiri Slaby <jirislaby@gmail.com>,
       ath5k-devel@venema.h4ckr.net, mickflemm@gmail.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200905300033.12204.tobias.doerffel@gmail.com>
References: <1242850139-25438-1-git-send-email-jirislaby@gmail.com>
	 <200905260124.03287.tobias.doerffel@gmail.com>
	 <1243294366.29222.10.camel@johannes.local>
	 <200905300033.12204.tobias.doerffel@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GVi3sAu+qdZspZuck9qG"
Date: Sat, 30 May 2009 01:14:30 +0200
Message-Id: <1243638870.13863.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GVi3sAu+qdZspZuck9qG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-30 at 00:33 +0200, Tobias Doerffel wrote:

> > Could you try to work against v11
> > of my rfkill patch, or better even against the cfg80211 rfkill instead?
> I didn't look at both of them yet. However I think we first should try to=
 get=20
> current rfkill support into mainline as fast as possible. Improvements an=
d=20
> adaptations to reworked rfkill framework can follow.

No other comments from me -- but since the v11 of the rfkill rewrite
will certainly hit the tree before your patch (it's almost in) you
_will_ have to work against it. I'll also try to make the cfg80211
rfkill hit the tree very soon for reasons I'll explain elsewhere -- you
would be better off working against that because then your rfkill code
is very very very simple and doesn't need to do much at all.

johannes

--=-GVi3sAu+qdZspZuck9qG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKIGxTAAoJEODzc/N7+QmajhUP/RvPIxcrxrKmDxKiHuLMhGlo
n9j158LT9golqaDamkl1Qg5sP83M6plQk3dLp87dT63qzb82uQYzN660CpsGHREE
Y0BGzOFt0Fb61vjRhUJrL4yu0Hi6WnyCDeDntXTXiw8tfR/WYy+7v4lGu5ia0BnX
n5LBfAddcbdp00eBDpLMVuSr4RbYrOTPfrTLn3UaptEu/Ol03sBF/VgNOqrErgBa
laUcoF37bNoBq3Mkb4LpJ6eq3uYKUOR+LSnqeE66vNpNhyqEMR5r4uYI6KqTS8CF
WYd08WK9zIapq5JFULv01+ta+iWj/sxGY1yqFY0v1KUVu8nCs4nlmY3waBn/yoqh
xTW7gaaCbXTOSJGAzJSfZKxXt0MTPbklAefQ7B7X8HT2Sjrxg2Q87tfZXpvvm+4F
3yM9mlp6cBtONzj5/MTi+tKXINVbaegDMjyMxgJdB7owwDm7syO1FvhQ4VPvo42Z
pBLY9rkOTZ0wd2y23zC/msRUlLvaR4fMt8bdyfEmbh2P72CerIijBcCypZccoMIt
0eXWe8mrs3rCOZHc7w0lrDQ7y38PTtAmkhTjxBuyFmfYOgICmeqhLl8lbah3b7kf
l3xiTNUONzjnsr/Mf7h8mhY2iipv8NaJrJ261mdDL9D7PfH+gRQdRKEPx8EAduVV
kAvhDieG+W7OHQH75f8N
=2o9a
-----END PGP SIGNATURE-----

--=-GVi3sAu+qdZspZuck9qG--

