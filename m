Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0BVXZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:25:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38229 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab0BVXZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:25:20 -0500
Date: Tue, 23 Feb 2010 10:25:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, monstr@monstr.eu,
       linux-kernel@vger.kernel.org, jeremy.kerr@canonical.com
Subject: Re: [PATCH 2/2] of/flattree: Make unflatten_device_tree() safe to 
 call from any arch
Message-Id: <20100223102514.46369a42.sfr@canb.auug.org.au>
In-Reply-To: <fa686aa41002221511r67c79534od562bef934c4d7a7@mail.gmail.com>
References: <20100222154816.3604.67114.stgit@angua>
	<20100222155059.3604.39718.stgit@angua>
	<20100223095118.bed93bac.sfr@canb.auug.org.au>
	<fa686aa41002221511r67c79534od562bef934c4d7a7@mail.gmail.com>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Feb_2010_10_25_14_+1100_QPBSvCtdVpTrOG+F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Feb_2010_10_25_14_+1100_QPBSvCtdVpTrOG+F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Mon, 22 Feb 2010 16:11:48 -0700 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> No reason, just wasn't thinking of that.  I've changed this.

Thanks.  Andrew Morton says that (unless there is a good reason) we
should program the kernel in C not CPP.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Feb_2010_10_25_14_+1100_QPBSvCtdVpTrOG+F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuDEloACgkQjjKRsyhoI8zHQwCfYX3qluTEv1ODD/poMg+QSsu0
38IAn2mdbz08wt9A7bzvyFQmoB7M0/H4
=c+un
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Feb_2010_10_25_14_+1100_QPBSvCtdVpTrOG+F--
