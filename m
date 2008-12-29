Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbYL2ESP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbYL2ESP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 23:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbYL2ER4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 23:17:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38176 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbYL2ER4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 23:17:56 -0500
Date: Mon, 29 Dec 2008 15:17:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: nhorman@tuxdriver.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: linux-next: origin tree build warnings
Message-Id: <20081229151749.8dd82c02.sfr@canb.auug.org.au>
In-Reply-To: <20081228.200145.33502228.davem@davemloft.net>
References: <20081229113525.89450db7.sfr@canb.auug.org.au>
	<20081228.200145.33502228.davem@davemloft.net>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Dec_2008_15_17_49_+1100_nns96nc2=0Xio9lO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Dec_2008_15_17_49_+1100_nns96nc2=0Xio9lO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Sun, 28 Dec 2008 20:01:45 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> I'll take care of all of these issues, along with the

Thanks.

> ibmveth et al. ones you reported seperately.

Linus already took my patches for cifs, ibmveth and ehea (probably
assuming that they were trivial).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Dec_2008_15_17_49_+1100_nns96nc2=0Xio9lO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklYT20ACgkQjjKRsyhoI8ymyQCgl5rqZ3+DGO2TtC1eGRdRguF/
atgAnj8mu4VH5K277YQi9WKueKCOm8Qd
=SU8h
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Dec_2008_15_17_49_+1100_nns96nc2=0Xio9lO--
