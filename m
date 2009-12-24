Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbZLXM1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbZLXM1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZLXM1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:27:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60865 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbZLXM1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:27:03 -0500
Date: Thu, 24 Dec 2009 23:26:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Mattia Dongili <malattia@linux.it>
Subject: Re: linux-next: manual merge of the acpi tree with Linus' tree
Message-Id: <20091224232656.dafb0b1d.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.0912240000530.6541@localhost.localdomain>
References: <20091224091141.fa1cea64.sfr@canb.auug.org.au>
	<20091224093913.4f29f37b.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.0912240000530.6541@localhost.localdomain>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Dec_2009_23_26_56_+1100_6Dd7FdeG1=4.4zyT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Dec_2009_23_26_56_+1100_6Dd7FdeG1=4.4zyT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Thu, 24 Dec 2009 00:02:21 -0500 (EST) Len Brown <lenb@kernel.org> wrote:
>
> Simpler to just drop the offending patch:
>=20
> a287e9f941cf4bb8c167802c0f1cf04a93bc4e4c
> sony-laptop: remove private workqueue, use keventd instead
>=20
> and get a properly refreshed version of that from Dmitry/Mattia later.

Yep, that would work, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Dec_2009_23_26_56_+1100_6Dd7FdeG1=4.4zyT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkszXhAACgkQjjKRsyhoI8zuVQCfaT66nnkz9NYA/t40DTdp7mZJ
PvgAoJRbG1hiNzjMS5bLpNTFZxTiAvax
=r54E
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Dec_2009_23_26_56_+1100_6Dd7FdeG1=4.4zyT--
