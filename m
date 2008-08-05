Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbYHEQgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbYHEQgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYHEQgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:36:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52898 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757704AbYHEQf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:35:59 -0400
Date: Wed, 6 Aug 2008 02:35:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-next@vger.kernel.org,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: linux-next: wireless-current tree build failure
Message-Id: <20080806023552.604deebe.sfr@canb.auug.org.au>
In-Reply-To: <20080805160026.GA14186@tuxdriver.com>
References: <20080805162152.2b55ae5c.sfr@canb.auug.org.au>
	<20080805153757.GB22895@cs181140183.pp.htv.fi>
	<20080805160026.GA14186@tuxdriver.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Aug_2008_02_35_52_+1000_msCt9SvUnmol.F5i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Aug_2008_02_35_52_+1000_msCt9SvUnmol.F5i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Tue, 5 Aug 2008 12:00:26 -0400 "John W. Linville" <linville@tuxdriver.co=
m> wrote:
>
> I imagine that we would be happy to do that.  Anyone have a clue as to ho=
w?

I think that "not yet" is the answer :-(

If we don't get a useful answer soon, we may just have to merge the
driver with appropriately commented negative "depends on" in Kconfig for
the arches it breaks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_Aug_2008_02_35_52_+1000_msCt9SvUnmol.F5i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiYgWgACgkQjjKRsyhoI8wSjACeKVR1n7yBBXpaIISHU5xayr0B
owQAnRjx12+Puvto7jbu5eWtRPMjXFaH
=KdQo
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Aug_2008_02_35_52_+1000_msCt9SvUnmol.F5i--
