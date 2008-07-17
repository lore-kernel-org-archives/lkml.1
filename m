Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbYGQI2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbYGQI2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 04:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYGQI2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 04:28:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48609 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbYGQI2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 04:28:44 -0400
Date: Thu, 17 Jul 2008 18:28:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs-masters@oss.sgi.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: linux-next: Tree for June 24 (XFS x2)
Message-Id: <20080717182835.55405e63.sfr@canb.auug.org.au>
In-Reply-To: <487ED7F2.3040505@sgi.com>
References: <20080624175612.cdf29651.sfr@canb.auug.org.au>
	<20080624171809.42bbdf68.randy.dunlap@oracle.com>
	<20080625003751.GP29319@disturbed>
	<20080627132317.GB23854@lst.de>
	<20080716071922.GA16777@lst.de>
	<487ED7F2.3040505@sgi.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Jul_2008_18_28_35_+1000_hPccPYELA=A9DKCS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Jul_2008_18_28_35_+1000_hPccPYELA=A9DKCS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Jul 2008 15:26:10 +1000 Timothy Shimmin <tes@sgi.com> wrote:
>
> Christoph Hellwig wrote:
> > On Fri, Jun 27, 2008 at 03:23:17PM +0200, Christoph Hellwig wrote:
> >> The tree is still messed up.  This original [XFS] commit is still ther=
e,
> >> but also a revert of it.  but no patch with the actual changes again (=
?)
> >>
> >> Also my patch to switch to the generic xattr code is attributed to
> >> Lachlan and appears twice in the commit list.  I think this whole git
> >> tree needs to be regenerated.
> >=20
> > Could this please get fixed before the 2.6.27 pull?  The xfs.git tree
> > now has Linus' latest changes pulled but this still doesn't look
> > fixed up.
>=20
> Yep, I believe Lachlan is planning to regenerate the xfs git tree before
> the pull request.

When that happens, could you please make sure that the linux-next tree is
updated as well ... I have had a couple of trees where what was merged to
Linus did not match what is in linux-next - and that causes me no end of
pain when I have to merge the two ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Jul_2008_18_28_35_+1000_hPccPYELA=A9DKCS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh/ArMACgkQjjKRsyhoI8xRWQCfcz+yY6tObbYzrknUZ2UapMzT
DBgAn1rYAsAyCL2H5xRIrIXR/bHyVkNG
=s9sP
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Jul_2008_18_28_35_+1000_hPccPYELA=A9DKCS--
