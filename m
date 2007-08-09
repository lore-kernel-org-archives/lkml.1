Return-Path: <linux-kernel-owner+w=401wt.eu-S937737AbXHIBps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937737AbXHIBps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 21:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbXHIBpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 21:45:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56189 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbXHIBpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 21:45:38 -0400
Date: Thu, 9 Aug 2007 11:45:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>
Subject: Re: [PATCH 2/7] Added generic lg.h in lguest directory.
Message-Id: <20070809114528.da47fd77.sfr@canb.auug.org.au>
In-Reply-To: <20070809003343.310187242@goodmis.org>
References: <20070809003211.373543702@goodmis.org>
	<20070809003343.310187242@goodmis.org>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__9_Aug_2007_11_45_28_+1000__.5Xh9pSJ57R84Bw"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Aug_2007_11_45_28_+1000__.5Xh9pSJ57R84Bw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 08 Aug 2007 20:32:13 -0400 Steven Rostedt <rostedt@goodmis.org>
wrote:
>
> Add a generic lg.h file to call the architecture specific one.

Please combine this with the previous patch so that the tree will build
at each step.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__9_Aug_2007_11_45_28_+1000__.5Xh9pSJ57R84Bw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGunG9TgG2atn1QN8RAioJAJ9p5h6gDXW4eWXWRwDPs8xk3E9t+wCfQq0c
d67gd6OOfnFFWOLocv8GUr4=
=cjeU
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Aug_2007_11_45_28_+1000__.5Xh9pSJ57R84Bw--
