Return-Path: <linux-kernel-owner+w=401wt.eu-S965016AbZKYXvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965016AbZKYXvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 18:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965005AbZKYXvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 18:51:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43945 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965004AbZKYXvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 18:51:04 -0500
Date: Thu, 26 Nov 2009 10:51:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IkrDtnJuIEVuZ2VsIg==?= <joern@logfs.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 0/17] [LogFS] New flash filesystem
Message-Id: <20091126105103.4b2b4408.sfr@canb.auug.org.au>
In-Reply-To: <20091125155510.GE10944@logfs.org>
References: <20091120181113.GA2159@logfs.org>
	<200911231318.39685.arnd@arndb.de>
	<20091125155510.GE10944@logfs.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_Nov_2009_10_51_03_+1100_mvK7wAz0.=Lx4JZ3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Nov_2009_10_51_03_+1100_mvK7wAz0.=Lx4JZ3
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi J=C3=B6rn,

On Wed, 25 Nov 2009 16:55:11 +0100 J=C3=B6rn Engel <joern@logfs.org> wrote:
>
> On Mon, 23 November 2009 13:18:39 +0100, Arnd Bergmann wrote:
> >=20
> > It should definitely be included in linux-next, and I guess it
> > should have been in there for some time, to get better
> > compile-time coverage across architectures, and some
> > more testing.
> >=20
> > I can't find it in linux-next right now, but I could be
> > looking at the wrong stuff again, as I have before.
>=20
> do you have a reason not to add logfs to linux-next?

Apart from not having been asked to do so, no ;-)

i.e. send me a request with the git url and I will add it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__26_Nov_2009_10_51_03_+1100_mvK7wAz0.=Lx4JZ3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksNwucACgkQjjKRsyhoI8wySACfY7xsQV8+dibyJKsEr5cl4NWT
3j0An3DBUGHzFEyGNp43It93lBTWyzWo
=WJtC
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Nov_2009_10_51_03_+1100_mvK7wAz0.=Lx4JZ3--
