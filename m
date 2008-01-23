Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYAWW6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYAWW6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYAWW5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:57:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38403 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbYAWW5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:57:53 -0500
Date: Thu, 24 Jan 2008 09:57:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jochen Friedrich <jochen@scram.de>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 7/8] [POWERPC] Rename commproc to cpm1 and
 cpm2_common.c to cpm2.c
Message-Id: <20080124095743.09a442ad.sfr@canb.auug.org.au>
In-Reply-To: <479764F5.1000105@scram.de>
References: <479764F5.1000105@scram.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Jan_2008_09_57_43_+1100_Md2WAUlKrbxk8=fR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Jan_2008_09_57_43_+1100_Md2WAUlKrbxk8=fR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jochen,

On Wed, 23 Jan 2008 17:01:57 +0100 Jochen Friedrich <jochen@scram.de> wrote:
>
> +++ b/arch/powerpc/platforms/8xx/ep88xc.c
> @@ -15,7 +15,7 @@
>   #include <asm/machdep.h>
>   #include <asm/io.h>
>   #include <asm/udbg.h>
> -#include <asm/commproc.h>
> +#include <asm/cpm1.h>
>   #include <asm/mpc8xx.h>

Something has whitespace damaged this patch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Jan_2008_09_57_43_+1100_Md2WAUlKrbxk8=fR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHl8ZtTgG2atn1QN8RAohaAJ9IGF3klbf3wGbuMgTYOeh9RavcDQCdF2Ob
EziIj8DMpQmNEt2Ue+80m4k=
=qrsT
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Jan_2008_09_57_43_+1100_Md2WAUlKrbxk8=fR--
