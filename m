Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbYL2F0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbYL2F0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 00:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbYL2F02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 00:26:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60413 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbYL2F01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 00:26:27 -0500
Date: Mon, 29 Dec 2008 16:26:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Bernd Schubert <bernd.schubert@fastmail.fm>,
       nfsv4@linux-nfs.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       steved@redhat.com, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com,
       linux-next@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Pull request for FS-Cache, including NFS patches
Message-Id: <20081229162618.e2fea7a9.sfr@canb.auug.org.au>
In-Reply-To: <20081228200726.7b7078b4.akpm@linux-foundation.org>
References: <8930.1229560221@redhat.com>
	<20081218142420.GA16728@infradead.org>
	<20081218123601.11810b7f.akpm@linux-foundation.org>
	<200812190007.34581.bernd.schubert@fastmail.fm>
	<20081218152616.a24c013f.akpm@linux-foundation.org>
	<20081219110539.7e7e230c.sfr@canb.auug.org.au>
	<20081229144533.4a0ab696.sfr@canb.auug.org.au>
	<20081228200726.7b7078b4.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Dec_2008_16_26_18_+1100_iXRUVF.IBG7THewh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Dec_2008_16_26_18_+1100_iXRUVF.IBG7THewh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew, Trond,

On Sun, 28 Dec 2008 20:07:26 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> And that of course means that many many 2.6.28 patches which I am
> maintaining will need significant rework to apply on top of linux-next,
> and then they won't apply to mainline.  Or that linux-next will not apply
> on top of those patches.  Mainly memory management.
>=20
> Please drop the NFS tree until after -rc1.

OK, it is dropped for now (including today's tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Dec_2008_16_26_18_+1100_iXRUVF.IBG7THewh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklYX3oACgkQjjKRsyhoI8x2FgCguLyWN0574cD4ck4JmUOp5yF1
DFoAn0lyhgYZEN6ScB+hVnHaT5xu/8/z
=bgHt
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Dec_2008_16_26_18_+1100_iXRUVF.IBG7THewh--
