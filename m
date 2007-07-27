Return-Path: <linux-kernel-owner+w=401wt.eu-S935144AbXG0Hza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935144AbXG0Hza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 03:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763957AbXG0HzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 03:55:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34034 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763632AbXG0HzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 03:55:10 -0400
Date: Fri, 27 Jul 2007 17:54:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Wei <wei.zhang@freescale.com>
Cc: galak@kernel.crashing.org, mporter@kernel.crashing.org, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5 v3] Add the platform device support with RapidIO to
 MPC8641HPCN platform.
Message-Id: <20070727175449.e8915b5d.sfr@canb.auug.org.au>
In-Reply-To: <11854393753986-git-send-email-wei.zhang@freescale.com>
References: <11854393721520-git-send-email-wei.zhang@freescale.com>
	<11854393733580-git-send-email-wei.zhang@freescale.com>
	<11854393741899-git-send-email-wei.zhang@freescale.com>
	<11854393753986-git-send-email-wei.zhang@freescale.com>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Jul_2007_17_54_49_+1000_fv+hKl.ew.OoBb9j"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Jul_2007_17_54_49_+1000_fv+hKl.ew.OoBb9j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Jul 2007 16:42:50 +0800 Zhang Wei <wei.zhang@freescale.com> wrot=
e:
>
> +#include <asm/of_device.h>
> +#include <asm/of_platform.h>

These should now be <linux/of_device.h> and <linux/of_platform.h>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_Jul_2007_17_54_49_+1000_fv+hKl.ew.OoBb9j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGqaTSTgG2atn1QN8RApDmAJ4j7AQLvOW1eHwSgnUD2NWIXr02qgCcDX/q
mG14ygnsm9uwxnM17BFCCpk=
=2kyQ
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Jul_2007_17_54_49_+1000_fv+hKl.ew.OoBb9j--
