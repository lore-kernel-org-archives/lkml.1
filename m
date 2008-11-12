Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYKLXkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYKLXkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYKLXf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:35:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56529 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059AbYKLXfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:35:24 -0500
Date: Thu, 13 Nov 2008 10:35:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, travis@sgi.com,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 0/7] cpu alloc stage 2
Message-Id: <20081113103510.4a6a1d3a.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0811121406550.31606@quilx.com>
References: <20081105231634.133252042@quilx.com>
	<20081112175717.4a1fd679.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0811121406550.31606@quilx.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Nov_2008_10_35_10_+1100_n9BlKlxVSkxb0gEe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Nov_2008_10_35_10_+1100_n9BlKlxVSkxb0gEe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Wed, 12 Nov 2008 14:07:51 -0600 (CST) Christoph Lameter <cl@linux-founda=
tion.org> wrote:
>
> On Wed, 12 Nov 2008, Stephen Rothwell wrote:
>=20
> > I have seen some discussion of these patches (and some fixes for the
> > previous set).  Are they in a state that they should be in linux-next y=
et?
>=20
> I will push out a new patchset and tree in the next hour or so for
> you to merge into linux-next.

Why not just add these to the cpu_alloc tree I already have?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Nov_2008_10_35_10_+1100_n9BlKlxVSkxb0gEe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkbaC4ACgkQjjKRsyhoI8wulgCgv7WYsE94r4luahE5YkzCllqS
Dl8Ani5U6jiu8ppKr4lCulc1KpfmVIl9
=DBnI
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Nov_2008_10_35_10_+1100_n9BlKlxVSkxb0gEe--
