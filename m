Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbYL3IbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbYL3IbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 03:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYL3IbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 03:31:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47208 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbYL3Ia7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 03:30:59 -0500
Date: Tue, 30 Dec 2008 19:30:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <rdreier@cisco.com>
Cc: general@lists.openfabrics.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Aleksey Senin <alekseys@voltaire.com>
Subject: Re: linux-next: origin tree build failure
Message-Id: <20081230193048.db7ee462.sfr@canb.auug.org.au>
In-Reply-To: <adavdt2ru39.fsf@cisco.com>
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
	<adavdt2ru39.fsf@cisco.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__30_Dec_2008_19_30_48_+1100_SoBxO0UzfJZx1KCT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Dec_2008_19_30_48_+1100_SoBxO0UzfJZx1KCT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Roland,

On Mon, 29 Dec 2008 23:38:18 -0800 Roland Dreier <rdreier@cisco.com> wrote:
>
>  > ERROR: ".ipv6_chk_addr" [drivers/infiniband/core/ib_addr.ko] undefined!
>  > ERROR: ".ip6_route_output" [drivers/infiniband/core/ib_addr.ko] undefi=
ned!
>=20
> OK, I pushed out a change that should fix this, so you can drop the
> revert.  Let me know if you see further issues.

I can drop the revert after your fix goes into Linus' tree (since that is
where the breakage is) ... looking forward to it, thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__30_Dec_2008_19_30_48_+1100_SoBxO0UzfJZx1KCT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklZ3DgACgkQjjKRsyhoI8yoXACbBO8xP4EGslvFECUeRZVm/F2U
I6kAn29khtOL4ntFGXnLEbk6bsYjevfP
=2lqu
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Dec_2008_19_30_48_+1100_SoBxO0UzfJZx1KCT--
