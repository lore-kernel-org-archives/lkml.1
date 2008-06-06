Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYFFLMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYFFLMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 07:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYFFLMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 07:12:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43703 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbYFFLL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 07:11:59 -0400
Date: Fri, 6 Jun 2008 21:11:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 6
Message-Id: <20080606211151.b36ed703.sfr@canb.auug.org.au>
In-Reply-To: <4848F9E5.20005@movial.fi>
References: <20080606183527.d3b39ecd.sfr@canb.auug.org.au>
	<4848F9E5.20005@movial.fi>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Jun_2008_21_11_51_+1000_l41DKGgG_x2ackU+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jun_2008_21_11_51_+1000_l41DKGgG_x2ackU+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitri,

On Fri, 06 Jun 2008 11:48:37 +0300 Dmitri Vorobiev <dmitri.vorobiev@movial.=
fi> wrote:
>
> Please see http://lkml.org/lkml/2008/6/4/152 where you'll find the
> description of how I built a MIPS cross-toolchain and a working MIPS conf=
ig.

Thanks for that.  Sorry I didn't respond sooner.

We have managed to make a working tool chain and I will
add some MIPS builds soon.  Was the attached config just the
malta_defconfig in the kernel tree, or there something special about it.
I noticed that a straight defconfig build works for mips and mipsel.
Would you expect all{no,mod}config to work?  What would be a good 64 bit
test config?

It is easier for us if we just use the configs out of the kernel tree,
but others are possible (its just harder to keep them up to date).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Jun_2008_21_11_51_+1000_l41DKGgG_x2ackU+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhJG3cACgkQTgG2atn1QN/4rwCeIK21eMXoV6K+IrVs0RZFFHl2
qsUAn3dvozdP4Ji6PkyrojYK9Hs+QzkE
=+F3E
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jun_2008_21_11_51_+1000_l41DKGgG_x2ackU+--
