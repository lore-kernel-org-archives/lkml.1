Return-Path: <linux-kernel-owner+w=401wt.eu-S1760985AbYGaAni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760985AbYGaAni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbYGaAn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:43:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56474 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbYGaAn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:43:27 -0400
Date: Thu, 31 Jul 2008 10:43:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: eranian@gmail.com
Cc: "stephane eranian" <eranian@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/19] perfmon2 minimal v3: introduction
Message-Id: <20080731104319.1a89d1ee.sfr@canb.auug.org.au>
In-Reply-To: <7c86c4470807301726m7b828621le272400bca6bdf6a@mail.gmail.com>
References: <4868dbf6.0af5660a.1972.52f4@mx.google.com>
	<20080729014730.76b879a4.sfr@canb.auug.org.au>
	<7c86c4470807282320o2d072c7dp7a327f133d5969c5@mail.gmail.com>
	<7c86c4470807301659t232a8dabw5272988d164898e@mail.gmail.com>
	<20080731102154.b06476dd.sfr@canb.auug.org.au>
	<7c86c4470807301726m7b828621le272400bca6bdf6a@mail.gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__31_Jul_2008_10_43_19_+1000_UPpBq7hwGvZsL6hd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Jul_2008_10_43_19_+1000_UPpBq7hwGvZsL6hd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jul 2008 17:26:10 -0700 "stephane eranian" <eranian@googlemail.c=
om> wrote:
>
> > The advantage of using C code for the dummy versions of things is that =
we
> > still get type checking and we eliminate "unused variable" warnings for
> > parameters of the functions.
> >
> Will do the dummy functions as inline then.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__31_Jul_2008_10_43_19_+1000_UPpBq7hwGvZsL6hd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiRCqcACgkQjjKRsyhoI8yNJwCff89k4fGh5ORwA0xFlv5pexq3
3o8AniA5nRHPJaNuwNMQkhrlyZhyi42W
=UCCt
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Jul_2008_10_43_19_+1000_UPpBq7hwGvZsL6hd--
