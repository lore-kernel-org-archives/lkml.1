Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbYEPEGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbYEPEGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 00:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbYEPEGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 00:06:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44415 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYEPEGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 00:06:38 -0400
Date: Fri, 16 May 2008 14:06:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Adrian Bunk <bunk@kernel.org>, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: spontaneous reboots and hangs on x86_64
Message-Id: <20080516140625.25fac6a2.sfr@canb.auug.org.au>
In-Reply-To: <20080515203120.GF1936@cs181133002.pp.htv.fi>
References: <200805152201.49154.m.kozlowski@tuxland.pl>
	<20080515203120.GF1936@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__16_May_2008_14_06_25_+1000_RUjaCvG=rtM+/BIN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_May_2008_14_06_25_+1000_RUjaCvG=rtM+/BIN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marius,

On Thu, 15 May 2008 23:31:21 +0300 Adrian Bunk <bunk@kernel.org> wrote:
>
> > ~/linux/linux-next $ git bisect start
> > fatal: ref HEAD is not a symbolic ref
> > Bad HEAD - I need a symbolic ref

This would indicate something wrong with your clone of linux-next.  How
did you create the repository?

> > - how does one bisect on linux-next?

Any day's linux-next tree is a git tree like any other ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_May_2008_14_06_25_+1000_RUjaCvG=rtM+/BIN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFILQhJTgG2atn1QN8RAt25AJ95WtWr6Lip6RpI1wkDFf7KzMc1JwCfZtZp
yFCTpPzmvboB0rEKT6Tfn2Y=
=bdvS
-----END PGP SIGNATURE-----

--Signature=_Fri__16_May_2008_14_06_25_+1000_RUjaCvG=rtM+/BIN--
