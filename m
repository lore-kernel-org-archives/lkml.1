Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbXHAEnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbXHAEnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 00:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbXHAEn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:43:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38692 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbXHAEn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:43:26 -0400
Date: Wed, 1 Aug 2007 14:43:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, linuxppc-embedded@ozlabs.org
Subject: Re: [PATCH] [POWERPC] Typo fixes interrrupt -> interrupt
Message-Id: <20070801144318.f81fd988.sfr@canb.auug.org.au>
In-Reply-To: <46AFFB0B.102@googlemail.com>
References: <46AFFB0B.102@googlemail.com>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Aug_2007_14_43_18_+1000_Jsi=DVbnGXmF21Ha"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Aug_2007_14_43_18_+1000_Jsi=DVbnGXmF21Ha
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 01 Aug 2007 05:16:27 +0200 Gabriel C <nix.or.die@googlemail.com> wr=
ote:
>
>  arch/powerpc/platforms/iseries/it_lp_naca.h       |   87 +++++++++++----=
------

NAK this part as it just makes a lot of the lines more than 80 characters
for no real gain on a platform that is moving on ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__1_Aug_2007_14_43_18_+1000_Jsi=DVbnGXmF21Ha
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGsA9qTgG2atn1QN8RAhaxAJ92SCCPf7BTvwaTepP0EvcPVzwqSACfReU3
tekm2LUkU4AWar31EVuoudQ=
=nA2f
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Aug_2007_14_43_18_+1000_Jsi=DVbnGXmF21Ha--
