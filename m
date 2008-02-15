Return-Path: <linux-kernel-owner+w=401wt.eu-S934332AbYBOA61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332AbYBOA61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbYBOA6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:58:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50229 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbYBOA6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:58:12 -0500
Date: Fri, 15 Feb 2008 11:58:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: Olof Johansson <olof@lixom.net>, Becky Bruce <becky.bruce@freescale.com>,
       sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4]: Respun LMB patches.
Message-Id: <20080215115806.bc939114.sfr@canb.auug.org.au>
In-Reply-To: <20080214232152.GB15724@lixom.net>
References: <20080213.170938.34536425.davem@davemloft.net>
	<38133B3C-75A2-4465-9484-7BF8E7E85D1D@freescale.com>
	<20080214232152.GB15724@lixom.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Feb_2008_11_58_06_+1100_yZ0DtZqfjWfL+0JM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2008_11_58_06_+1100_yZ0DtZqfjWfL+0JM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Feb 2008 17:21:52 -0600 Olof Johansson <olof@lixom.net> wrote:
>
> On Thu, Feb 14, 2008 at 02:58:22PM -0600, Becky Bruce wrote:
>=20
> > Thanks for picking up the patches from Kumar and myself and fitting =20
> > them into your series - this is much appreciated.  FYI, I applied the =
=20
> > entire patch series to my local tree and test-booted both mpc8641 and =
=20
> > mpc8568mds and both build and boot cleanly. I also built pasemi and =20
> > ebony, those build cleanly as well.
>=20
> pasemi_defconfig boots happily on my boards here. I've kicked off my
> "build all powerpc defconfigs" script while I leave the house for a
> couple of hours, but as others have said, no problems are expected...

It builds and boots on legacy iSeries (and seems to be working ok) as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__15_Feb_2008_11_58_06_+1100_yZ0DtZqfjWfL+0JM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtOOiTgG2atn1QN8RAuQpAJ9zgf45DLdeF0/578j/kQ+sChxJywCfRm/+
ydPF4M9DeFIqzx70j6++WN8=
=BEsK
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2008_11_58_06_+1100_yZ0DtZqfjWfL+0JM--
