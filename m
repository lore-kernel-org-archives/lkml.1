Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYJPKPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYJPKPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYJPKPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:15:11 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:64114 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbYJPKPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:15:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=dQkg6fJ40jjl24+O50+0m+Nw2/EZBT/3yQHcdmoDnGiR+b7kg0oYjXxiKOGV87J2IK
         tu5PRHFImn3SRf+M+cMv1mKdQSKRnA1qhacgMDpukwcnF/WRU+zTEjc9iqNSpV54vh/e
         +Bx+FBZQVe22SrX1pdU5hIGVM1/AObRd5iraE=
Date: Thu, 16 Oct 2008 12:14:42 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: el es <el_es_cr@yahoo.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-Id: <20081016121442.b30f01e4.kristoffer.ericson@gmail.com>
In-Reply-To: <loom.20081016T094113-612@post.gmane.org>
References: <20081016002509.GA25868@kroah.com>
	<loom.20081016T075618-911@post.gmane.org>
	<48F704E6.2010409@zytor.com>
	<loom.20081016T092338-594@post.gmane.org>
	<loom.20081016T094113-612@post.gmane.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Oct_2008_12_14_42_+0200_NztUS10v74t6Tgwv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Oct_2008_12_14_42_+0200_NztUS10v74t6Tgwv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Please don't use time indications inside kernel versions, it just gets conf=
using
(even more so if you use yy mm dd).


On Thu, 16 Oct 2008 10:05:32 +0000 (UTC)
el es <el_es_cr@yahoo.co.uk> wrote:

> el es <el_es_cr <at> yahoo.co.uk> writes:
>=20
> >=20
> > H. Peter Anvin <hpa <at> zytor.com> writes:
> >=20
> > >=20
> > > el es wrote:
> > [snip]
> > > > - informative : the ww and tt numbers are the week numbers of when =
the=20
> > > > actual release HAPPENED, not when it is predicted.
>=20
> > > Which really sucks for dealing with future releases.
> > >=20
> >=20
> > Why ?=20
> > What do you mean by 'future releases' ?=20
>=20
> Oh, I just read your suggestion to move on with 3, 4 and so on. To keep i=
t=20
> simple.
>=20
> How about adopting your scheme (simple counter) with mine (yy.ww.tt) ?
>=20
> Speaking on my own, I think that some indication of WHEN the release actu=
ally
> happened, encoded in the version number, IS desirable. I'm not a develope=
r (my
> field is far, far away) but personally I find the suggestions to put full=
 year
> figure in front, grossly disturbing everything we accustomed to ;)
>=20
> OR.
> If in my idea, we drop the .tt bit, hence, we declare, that the stable te=
am just
> continues the work on the released version, like
>=20
> - 2.08.41 is the currently released 2.6.27,
> - developers continue on 2.08.41-rcX, which gets promoted to 3.yy.ww when=
=20
> released and so on,
> - meanwhile the stable team releases 2.08.[42..52], 2.09.[01..52] and so =
on.=20
>=20
> Being an indication of continuity.
> As well as a revolution too ;)
> > >=20
> >=20
> > Lukasz
> >=20
> >=20
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--=20
Kristoffer Ericson <kristoffer.ericson@gmail.com>

--Signature=_Thu__16_Oct_2008_12_14_42_+0200_NztUS10v74t6Tgwv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj3FBIACgkQPQls10ERAGdpGgCgs+8JuA5TwSdxRONJyGdhgfMo
1VoAnjw5f06ag90ScdbU9x04pDkVv83n
=5KgW
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Oct_2008_12_14_42_+0200_NztUS10v74t6Tgwv--
