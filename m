Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbYGOEFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbYGOEFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 00:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYGOEEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 00:04:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51619 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbYGOEEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 00:04:47 -0400
Date: Tue, 15 Jul 2008 14:04:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm tree reorganisation for merge window
Message-Id: <20080715140439.4cfcd808.sfr@canb.auug.org.au>
In-Reply-To: <alpine.DEB.0.82.0807142207010.3936@skynet.skynet.ie>
References: <alpine.DEB.0.82.0807140147500.9419@skynet.skynet.ie>
	<20080715012153.a3bb9df0.sfr@canb.auug.org.au>
	<alpine.DEB.0.82.0807142207010.3936@skynet.skynet.ie>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Jul_2008_14_04_39_+1000_8bc5G=Uw+vX_BMel"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Jul_2008_14_04_39_+1000_8bc5G=Uw+vX_BMel
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 14 Jul 2008 22:08:39 +0100 (IST) Dave Airlie <airlied@linux.ie> wro=
te:
>
> > > Please pull the 'drm-reorg' branch from
> > > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git =
drm-reorg
> > >=20
> > > This contains a moving around of a lot of the DRM into a more Linux l=
ike=20
> > > tree and makes it a lot nicer going forward for merging new features.
> >=20
> > Does this tree have a fix for the x86_64 allmodconfig build failures I
> > reported against linux-next?
>=20
> Yes I rolled them into the patch instead of cluttering up the history.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Jul_2008_14_04_39_+1000_8bc5G=Uw+vX_BMel
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh8IdcACgkQjjKRsyhoI8yfAQCfezh/QOQNqhRMIA/N++NF8myX
viUAn05aNnfUA5NVhp/3OTq4mIsdwX9d
=5Iug
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Jul_2008_14_04_39_+1000_8bc5G=Uw+vX_BMel--
