Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYJUMOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYJUMOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYJUMOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:14:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35402 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbYJUMOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:14:30 -0400
Date: Tue, 21 Oct 2008 23:14:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 21
Message-Id: <20081021231421.a9cdfcb4.sfr@canb.auug.org.au>
In-Reply-To: <20081021120735.GA10567@yoda.jdub.homelinux.org>
References: <20081021195109.ed83b102.sfr@canb.auug.org.au>
	<20081021120735.GA10567@yoda.jdub.homelinux.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Oct_2008_23_14_21_+1100_Lc/jz3JxT4PpBBrb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Oct_2008_23_14_21_+1100_Lc/jz3JxT4PpBBrb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Josh,

On Tue, 21 Oct 2008 08:07:35 -0400 Josh Boyer <jwboyer@linux.vnet.ibm.com> =
wrote:
>
> On Tue, Oct 21, 2008 at 07:51:09PM +1100, Stephen Rothwell wrote:
> >I have also applied the following patches for known problems:
> >
> >	sparc: qlogicpti fallout from sbus removal
> >	ibm_newemac: Fix new MAL feature handling
>=20
> Did you?  I put that in my next branch, which Ben pulled into his powerpc
> tree, so it shouldn't have needed applying separately.

It got into Ben's tree way after I started building linux-next for
today.  Tomorrow I will indeed not need it any more, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Oct_2008_23_14_21_+1100_Lc/jz3JxT4PpBBrb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj9x50ACgkQjjKRsyhoI8xgJQCeK+e/gtp4xuXJoLI+mm3t9meg
BRMAnjdEx71jjYH47DunCtdMSzCC+lIr
=8aXV
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Oct_2008_23_14_21_+1100_Lc/jz3JxT4PpBBrb--
