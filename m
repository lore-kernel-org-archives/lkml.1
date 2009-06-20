Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZFTX7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZFTX7P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 19:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbZFTX7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 19:59:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35496 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZFTX67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 19:58:59 -0400
Date: Sun, 21 Jun 2009 09:58:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Kallsyms problems (was: Re: linux-next: arm build
 failures)
Message-Id: <20090621095855.3462fc23.sfr@canb.auug.org.au>
In-Reply-To: <20090620124152.GI32531@uranus.ravnborg.org>
References: <20090617162612.703adfd9.sfr@canb.auug.org.au>
	<tnx3a9ztg14.fsf@pc1117.cambridge.arm.com>
	<20090617230804.5e353ec9.sfr@canb.auug.org.au>
	<20090619151321.GA6223@flint.arm.linux.org.uk>
	<20090620155440.a7dfb2d4.sfr@canb.auug.org.au>
	<20090620124152.GI32531@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__21_Jun_2009_09_58_55_+1000_1VcHkt2ftF.wKNgl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__21_Jun_2009_09_58_55_+1000_1VcHkt2ftF.wKNgl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Sat, 20 Jun 2009 14:41:52 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> Just sent it. Overloaded with day-time stuff (again).

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__21_Jun_2009_09_58_55_+1000_1VcHkt2ftF.wKNgl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko9d78ACgkQjjKRsyhoI8xx0QCfV3uIBqoNZMNxDZZuH3NTtShp
i7oAn2y4Dfrgwe/66FD4ST+Q3MDeYfow
=xWRO
-----END PGP SIGNATURE-----

--Signature=_Sun__21_Jun_2009_09_58_55_+1000_1VcHkt2ftF.wKNgl--
