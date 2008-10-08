Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbYJHJfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbYJHJfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 05:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbYJHJeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 05:34:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:45244 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbYJHJeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 05:34:22 -0400
Date: Wed, 8 Oct 2008 12:35:27 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Message-ID: <20081008093526.GA4986@localhost.localdomain>
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name> <517f3f820810080157j3994ff10j8518178af02e5b22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <517f3f820810080157j3994ff10j8518178af02e5b22@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2008 at 10:57:21AM +0200, Michael Kerrisk wrote:
> Kirill,
>=20
> On Tue, Oct 7, 2008 at 6:15 PM, Kirill A. Shutemov <kirill@shutemov.name>=
 wrote:
> > If SHM_MAP_NOT_FIXED specified and shmaddr is not NULL, then the kernel=
 takes
> > shmaddr as a hint about where to place the mapping. The address of the =
mapping
> > is returned as the result of the call.
> >
> > It's similar to mmap() without MAP_FIXED.
>=20
> Please CC linux-api@vger.kernel.org on patches that change the
> kernel-userspace interface.

Ok, I will.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjsft4ACgkQbWYnhzC5v6ojnACaA+yTJZGysNqJF+gPGEsWJJwR
FU4AniTGA7SoT/IUJoim7mXpb0xHICly
=x+Pb
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
