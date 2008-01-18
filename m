Return-Path: <linux-kernel-owner+w=401wt.eu-S1760512AbYARAjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512AbYARAjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760135AbYARAiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:38:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43784 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760411AbYARAiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:38:11 -0500
Date: Fri, 18 Jan 2008 11:38:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jochen Friedrich <jochen@scram.de>
Cc: linuxppc-dev@ozlabs.org, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFCv2] [POWERPC] Add support for freescale watchdog to
 CPM serial driver.
Message-Id: <20080118113804.4d4fdcc5.sfr@canb.auug.org.au>
In-Reply-To: <478F4AE3.5090803@scram.de>
References: <478F4AE3.5090803@scram.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__18_Jan_2008_11_38_04_+1100_hhjUuxYvI1oUHO91"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Jan_2008_11_38_04_+1100_hhjUuxYvI1oUHO91
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Jan 2008 13:32:35 +0100 Jochen Friedrich <jochen@scram.de> wrote:
>
> If a freescale watchdog device node is present, reset the watchdog
> while waiting for serial input.
>=20
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
>  arch/powerpc/boot/Makefile     |    2 +-
>  arch/powerpc/boot/cpm-serial.c |    6 ++++
>  arch/powerpc/boot/cuboot-8xx.c |    1 +
>  arch/powerpc/boot/ops.h        |    2 +
>  arch/powerpc/boot/watchdog.c   |   65 ++++++++++++++++++++++++++++++++++=
++++++

I am just wondering if maybe that file name is to generic.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__18_Jan_2008_11_38_04_+1100_hhjUuxYvI1oUHO91
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHj/TwTgG2atn1QN8RAtjeAJ9OK5TKKqICD1rV+bHfx+HLknUxgACfcp98
hgnGoOHVPdSDbhN0wzfJ7cU=
=2Xdv
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Jan_2008_11_38_04_+1100_hhjUuxYvI1oUHO91--
