Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZIHDWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZIHDWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 23:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZIHDWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 23:22:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44449 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbZIHDWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 23:22:53 -0400
Date: Tue, 8 Sep 2009 13:22:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: security-testing tree build failure
Message-Id: <20090908132244.3785a8a8.sfr@canb.auug.org.au>
In-Reply-To: <20090908104012.ff4bd25f.sfr@canb.auug.org.au>
References: <20090907234028.6728eb5e.sfr@canb.auug.org.au>
	<20090907234331.58140be8.sfr@canb.auug.org.au>
	<20090908104012.ff4bd25f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Sep_2009_13_22_44_+1000_MP5w_YSLMTYQONsu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Sep_2009_13_22_44_+1000_MP5w_YSLMTYQONsu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James, David,

On Tue, 8 Sep 2009 10:40:12 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> This also broke the alpha and mips builds.  I am going to use the version

And cris :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Sep_2009_13_22_44_+1000_MP5w_YSLMTYQONsu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqlzgQACgkQjjKRsyhoI8xypgCeNkHA+fN8iPAtD6lquH5orq7D
i/sAnRa+ijKcDz7+aOKTsb5P5bTJk2+k
=/pY7
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Sep_2009_13_22_44_+1000_MP5w_YSLMTYQONsu--
