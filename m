Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbYEAB0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbYEAB0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYEAB0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:26:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34307 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479AbYEAB0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:26:39 -0400
Date: Thu, 1 May 2008 11:26:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next build error
Message-Id: <20080501112632.077166f1.sfr@canb.auug.org.au>
In-Reply-To: <200804302050.03950.dhazelton@enter.net>
References: <200804302050.03950.dhazelton@enter.net>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_May_2008_11_26_32_+1000_+6Nwyv2uSe4oM=Ts"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_May_2008_11_26_32_+1000_+6Nwyv2uSe4oM=Ts
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

Thanks for the report.

On Wed, 30 Apr 2008 20:50:03 -0400 Daniel Hazelton <dhazelton@enter.net> wr=
ote:
>
> ld: drivers/media/built-in.o: No such file: No such file or directory
> make[2]: *** [drivers/built-in.o] Error 1
> make[1]: *** [drivers] Error 2
> make[1]: Leaving directory `/home/madman/linux/linux-next'
> make: *** [debian/stamp-build-kernel] Error 2

Known problem in Linus' tree - hopefully fixed today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_May_2008_11_26_32_+1000_+6Nwyv2uSe4oM=Ts
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIGRxMTgG2atn1QN8RAmwzAJ9gKTGc48ed2Ajov9KC97A452YRJQCeI4ys
/gn/ylCnNcbOPbGuApR5ewA=
=waHb
-----END PGP SIGNATURE-----

--Signature=_Thu__1_May_2008_11_26_32_+1000_+6Nwyv2uSe4oM=Ts--
