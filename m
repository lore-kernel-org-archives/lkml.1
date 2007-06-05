Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbXFEBYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbXFEBYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 21:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbXFEBYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 21:24:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53365 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbXFEBYe (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 21:24:34 -0400
Date: Tue, 5 Jun 2007 11:24:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Olof Johansson <olof@lixom.net>, Matt Mackall <mpm@selenic.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-Id: <20070605112424.4c116535.sfr@canb.auug.org.au>
In-Reply-To: <1181005320.25878.68.camel@localhost.localdomain>
References: <20070604173710.GR11166@waste.org>
	<20070604225827.GA4280@lixom.net>
	<1181005320.25878.68.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Jun_2007_11_24_24_+1000_g_8AhAGaSA0qxp28"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Jun_2007_11_24_24_+1000_g_8AhAGaSA0qxp28
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Jun 2007 11:02:00 +1000 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> > See b791072ba3c3b29bab1890963bde52eb944a8451 for the changes in questio=
n.
>=20
> Hmm, I thought that was only supposed to happen for "interruptless"
> consoles?

The comment certainly says it only applies to polled mode.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Jun_2007_11_24_24_+1000_g_8AhAGaSA0qxp28
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGZLtMFdBgD/zoJvwRAniQAJ9+Bg2dkD3IWe04W668ZOkmFXbNgACfWH2K
KJXbH+EQ4LZYTdJi6ED1DMA=
=T22m
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Jun_2007_11_24_24_+1000_g_8AhAGaSA0qxp28--
