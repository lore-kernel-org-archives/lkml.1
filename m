Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbZEVIUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbZEVIUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZEVIUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:20:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52922 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbZEVIUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:20:30 -0400
Date: Fri, 22 May 2009 18:20:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       nhorman@tuxdriver.com, netdev@vger.kernel.org
Subject: Re: linux-next: net tree build warning
Message-Id: <20090522182024.cfe48be4.sfr@canb.auug.org.au>
In-Reply-To: <20090521.233038.195647453.davem@davemloft.net>
References: <20090522151642.e79e22ee.sfr@canb.auug.org.au>
	<20090521.233038.195647453.davem@davemloft.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_May_2009_18_20_24_+1000_qmXu/iGOrEb1uMgG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_May_2009_18_20_24_+1000_qmXu/iGOrEb1uMgG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, 21 May 2009 23:30:38 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> I just pushed the following to fix this:
>=20
> net: Fix arg to trace_napi_poll() in netpoll.

Thanks. I remerged the net tree at the end of linux-next today in case
anyone was doing any testing over the weekend.=20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_May_2009_18_20_24_+1000_qmXu/iGOrEb1uMgG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoWYEgACgkQjjKRsyhoI8yzzwCggJcCGwwm6y/uN97ocrSSazmC
fvEAnR7Bnl/DO72V5yTvZhS3bWOT9kNg
=XhrU
-----END PGP SIGNATURE-----

--Signature=_Fri__22_May_2009_18_20_24_+1000_qmXu/iGOrEb1uMgG--
