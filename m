Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562Ab0ARJBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0ARJBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 04:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575Ab0ARJBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 04:01:32 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49480 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab0ARJBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 04:01:32 -0500
Date: Mon, 18 Jan 2010 20:01:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: trivial tree build failure
Message-Id: <20100118200126.0176773d.sfr@canb.auug.org.au>
In-Reply-To: <63386a3d1001180036h2bad24cas8c407edde729678e@mail.gmail.com>
References: <20100118162412.9944c571.sfr@canb.auug.org.au>
	<63386a3d1001180036h2bad24cas8c407edde729678e@mail.gmail.com>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jan_2010_20_01_26_+1100_HJP+253InYon_0g0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jan_2010_20_01_26_+1100_HJP+253InYon_0g0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 18 Jan 2010 09:36:29 +0100 Linus Walleij <linus.ml.walleij@gmail.co=
m> wrote:
>
> I have sent a proper patch to Sam last night, that fix the #ifdef and
> makes the code work.
>=20
> > That file probably just needs to include <linux/seq_file.h> ...
>=20
> Not quite, there was some code rot in the #ifdef:ed code as well.
>=20
> But it should all be fixed now!

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jan_2010_20_01_26_+1100_HJP+253InYon_0g0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktUI2YACgkQjjKRsyhoI8zi2gCdEMIq/2ziFAX6CGLjl6dF64Rb
4kwAoLj1R3GuhIOZdU5lCG9mADHLJXqZ
=nz4B
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jan_2010_20_01_26_+1100_HJP+253InYon_0g0--
