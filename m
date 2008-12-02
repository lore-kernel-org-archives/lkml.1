Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbYLBXZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbYLBXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 18:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYLBXZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 18:25:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45366 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbYLBXZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 18:25:16 -0500
Date: Wed, 3 Dec 2008 10:25:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nicolas Palix <npalix@diku.dk>
Cc: paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] powerpc/powermac: Add missing of_node_put
Message-Id: <20081203102508.ce955781.sfr@canb.auug.org.au>
In-Reply-To: <20081203101901.4f317425.sfr@canb.auug.org.au>
References: <200812021445.18670.npalix@diku.dk>
	<20081203101901.4f317425.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Dec_2008_10_25_08_+1100_fqL4vZ/Yw__adOxl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Dec_2008_10_25_08_+1100_fqL4vZ/Yw__adOxl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicolas,

On Wed, 3 Dec 2008 10:19:01 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> I think this particular patch is also required against Linus' kernel (not
> just linux-next).

In fact, I think all these patches can apply to Linus' current tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Dec_2008_10_25_08_+1100_fqL4vZ/Yw__adOxl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk1w9QACgkQjjKRsyhoI8w4AgCgqkCoalI22aHYYEelOXPU/+to
erIAnjJkpc5f8aUUu7crYn6O2la0MIj0
=vrfJ
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Dec_2008_10_25_08_+1100_fqL4vZ/Yw__adOxl--
