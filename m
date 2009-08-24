Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbZHXNOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbZHXNOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 09:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZHXNOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 09:14:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44754 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZHXNOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 09:14:18 -0400
Date: Mon, 24 Aug 2009 23:14:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Syed Rafiuddin <rafiuddin.syed@ti.com>,
       Russell King <rmk@arm.linux.org.uk>, Kalle Valo <kalle.valo@iki.fi>
Subject: Re: linux-next: manual merge of the omap tree with the arm tree
Message-Id: <20090824231415.79c6909f.sfr@canb.auug.org.au>
In-Reply-To: <20090824130718.GC5165@atomide.com>
References: <20090819150433.4c12c612.sfr@canb.auug.org.au>
	<20090820102004.GD12309@atomide.com>
	<20090824130718.GC5165@atomide.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_Aug_2009_23_14_15_+1000_vOsNeYunizt0oiU7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Aug_2009_23_14_15_+1000_vOsNeYunizt0oiU7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Mon, 24 Aug 2009 16:07:18 +0300 Tony Lindgren <tony@atomide.com> wrote:
>
> The merge conflict should be gone now, Kevin realized we don't need the
> platform_data any longer. Will remove that for board-4430sdp.c and serial=
.h
> as a fix once the other pending changes have been merged.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_Aug_2009_23_14_15_+1000_vOsNeYunizt0oiU7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqSkicACgkQjjKRsyhoI8yd3wCgk3zLj6rV9lUEKmB7ZX9FkhKw
ELQAn38MgMIkjWQd/6LIHhJyCMNC0xgx
=0/6H
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Aug_2009_23_14_15_+1000_vOsNeYunizt0oiU7--
