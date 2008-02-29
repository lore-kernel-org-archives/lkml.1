Return-Path: <linux-kernel-owner+w=401wt.eu-S932376AbYB2Mae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbYB2Mae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbYB2MaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:30:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42738 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbYB2MaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:30:23 -0500
Date: Fri, 29 Feb 2008 23:30:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: linux-next: semaphore update merge conflicts
Message-Id: <20080229233019.780abba7.sfr@canb.auug.org.au>
In-Reply-To: <20080229132514.00d5087e@hskinnemoen.norway.atmel.com>
References: <20080229153958.fc34e281.sfr@canb.auug.org.au>
	<20080229111731.13840877@hskinnemoen.norway.atmel.com>
	<20080229231704.112d8112.sfr@canb.auug.org.au>
	<20080229132514.00d5087e@hskinnemoen.norway.atmel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Feb_2008_23_30_19_+1100_hPOI89nmbANUdAWX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Feb_2008_23_30_19_+1100_hPOI89nmbANUdAWX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Feb 2008 13:25:14 +0100 Haavard Skinnemoen <hskinnemoen@atmel.co=
m> wrote:
>
> On Fri, 29 Feb 2008 23:17:04 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > By the way, is there some place I can get a cross compiler to build avr=
32
> > kernels (or better yet a recipe for crosstool to make one)?
>=20
> You can get the official toolchain from this page:
>=20
> http://www.atmel.com/dyn/products/tools_card.asp?tool_id=3D4118
>=20
> I'm not sure about crosstool, but you can get a patched version of
> buildroot from this page:
>=20
> http://www.atmel.no/buildroot/
>=20
> Maybe you can just grab the patches from buildroot and use them with
> crosstool? Or I can send them to you if you don't want to download the
> whole thing.

I'll have a look and let you know.  Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Feb_2008_23_30_19_+1100_hPOI89nmbANUdAWX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHx/rhTgG2atn1QN8RAkGWAJ4+B3g0Qjf7DsNK2FZi2Uh0Jf7GOgCfWquB
kDx+ScLl3S5fbrCapPS+wNM=
=Ypbd
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Feb_2008_23_30_19_+1100_hPOI89nmbANUdAWX--
