Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbXIYEFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbXIYEFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbXIYEFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:05:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41913 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbXIYEFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:05:20 -0400
Date: Tue, 25 Sep 2007 14:04:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anton Blanchard <anton@au1.ibm.com>, paulus <paulus@au1.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] Delay creation of khcvd thread
Message-Id: <20070925140454.566803e5.sfr@canb.auug.org.au>
In-Reply-To: <1190691984.27805.270.camel@localhost.localdomain>
References: <1190691984.27805.270.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__25_Sep_2007_14_04_54_+1000_4.kI66S8qvd_+JFM"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2007_14_04_54_+1000_4.kI66S8qvd_+JFM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Sep 2007 13:46:24 +1000 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> hvc_console used to only be for Power aka pSeries: now lguest and Xen

Also legacy iSeries :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Sep_2007_14_04_54_+1000_4.kI66S8qvd_+JFM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG+IjvTgG2atn1QN8RAuU1AKCG8ej6WQRXxYc2xG2V5GM5251lGQCeK+bV
+sxIBXXJXuX1Z4vtABAY6VU=
=Bua5
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2007_14_04_54_+1000_4.kI66S8qvd_+JFM--
