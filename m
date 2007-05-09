Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbXEIMyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbXEIMyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbXEIMyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:54:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50184 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758161AbXEIMyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:54:39 -0400
Date: Wed, 9 May 2007 22:54:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       rusty@rustcorp.com.au, ak@suse.de, dada1@cosmosbay.com
Subject: Re: [patch 3/9] lguest: the host code
Message-Id: <20070509225436.1fb5dc2d.sfr@canb.auug.org.au>
In-Reply-To: <200705090951.l499pZF8020394@shell0.pdx.osdl.net>
References: <200705090951.l499pZF8020394@shell0.pdx.osdl.net>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_May_2007_22_54_36_+1000_CqaM72uC/0=9vaPs"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_May_2007_22_54_36_+1000_CqaM72uC/0=9vaPs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Wed, 09 May 2007 02:51:35 -0700 akpm@linux-foundation.org wrote:
>
> +++ a/drivers/lguest/core.c
> @@ -0,0 +1,446 @@
> +/* World's simplest hypervisor, to test paravirt_ops and show
> + * unbelievers that virtualization is the future.  Plus, it's fun! */

This may have been asked before, but is there some reason this has no
copyright and license statement?

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_May_2007_22_54_36_+1000_CqaM72uC/0=9vaPs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGQcSRFdBgD/zoJvwRAtuRAJ9pb/uh9r+3SNJ9eTl8zmOyFEJFlwCdGDlG
HhD/khRnW2FQtfgWs3pgWVM=
=86jF
-----END PGP SIGNATURE-----

--Signature=_Wed__9_May_2007_22_54_36_+1000_CqaM72uC/0=9vaPs--
