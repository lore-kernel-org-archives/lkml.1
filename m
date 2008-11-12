Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbYKLG5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbYKLG5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 01:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYKLG5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 01:57:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53790 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbYKLG5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 01:57:34 -0500
Date: Wed, 12 Nov 2008 17:57:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, travis@sgi.com,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 0/7] cpu alloc stage 2
Message-Id: <20081112175717.4a1fd679.sfr@canb.auug.org.au>
In-Reply-To: <20081105231634.133252042@quilx.com>
References: <20081105231634.133252042@quilx.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Nov_2008_17_57_17_+1100_5RjKAKZ.3LbmM6=8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Nov_2008_17_57_17_+1100_5RjKAKZ.3LbmM6=8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Wed, 05 Nov 2008 17:16:34 -0600 Christoph Lameter <cl@linux-foundation.o=
rg> wrote:
>
> The second stage of the cpu_alloc patchset can be pulled from
>=20
> git.kernel.org/pub/scm/linux/kernel/git/christoph/work.git cpu_alloc_stag=
e2
>=20
> Stage 2 includes the conversion of the page allocator
> and slub allocator to the use of the cpu allocator.
>=20
> It also includes the core of the atomic vs. interrupt cpu ops and uses th=
ose
> for the vm statistics.

I have seen some discussion of these patches (and some fixes for the
previous set).  Are they in a state that they should be in linux-next yet?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__12_Nov_2008_17_57_17_+1100_5RjKAKZ.3LbmM6=8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkafk0ACgkQjjKRsyhoI8x0LQCgndfW9F523hxXsVIO3QXMRIBM
DkYAnjtoJJ/37qfEPc963t/g/B8qFh/G
=rT4/
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Nov_2008_17_57_17_+1100_5RjKAKZ.3LbmM6=8--
