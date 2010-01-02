Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686Ab0ABLcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab0ABLcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 06:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616Ab0ABLco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 06:32:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36739 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab0ABLcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 06:32:43 -0500
Date: Sat, 2 Jan 2010 22:32:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Tony Luck <tony.luck@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       jbarnes@virtuousgeek.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: linux-next: Tree for December 31 (kgdb)
Message-Id: <20100102223219.a0373285.sfr@canb.auug.org.au>
In-Reply-To: <4B3EDA94.3040005@windriver.com>
References: <20091231112314.a51e160b.sfr@canb.auug.org.au>
	<20091231110747.5efc1efa.randy.dunlap@oracle.com>
	<12c511ca0912311120i3f60fccas3487c1f47b5cf3c3@mail.gmail.com>
	<4B3EDA94.3040005@windriver.com>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__2_Jan_2010_22_32_19_+1100_=fahe1qgq2Wm1EEE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Jan_2010_22_32_19_+1100_=fahe1qgq2Wm1EEE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Fri, 01 Jan 2010 23:33:08 -0600 Jason Wessel <jason.wessel@windriver.com=
> wrote:
>
> Tony Luck wrote:
> > The kgdb bits break ia64 (and any other architecture without an
> > <asm/kgdb.h> too):
>=20
> Certainly this was not intended.   It is properly fixed now in and
> folded into a number of the kgdb patches so everything will properly
> bisect.  It is updated in kgdb-next.

Thanks, I will pick it up on Monday.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__2_Jan_2010_22_32_19_+1100_=fahe1qgq2Wm1EEE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAks/LsMACgkQjjKRsyhoI8x0owCfWFdSdmWC4/CZR1zNhDIMBM/o
D/gAoK/X1PZcjhJ0S6ggPPJtGFi+Zi3B
=hio6
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Jan_2010_22_32_19_+1100_=fahe1qgq2Wm1EEE--
