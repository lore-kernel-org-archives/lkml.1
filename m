Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbYFJXss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbYFJXss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbYFJXsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:48:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55543 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbYFJXsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:48:39 -0400
Date: Wed, 11 Jun 2008 09:48:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: kbuild-current build failure
Message-Id: <20080611094827.5ed3e070.sfr@canb.auug.org.au>
In-Reply-To: <20080610190351.GB15983@uranus.ravnborg.org>
References: <20080610110842.30c90c61.sfr@canb.auug.org.au>
	<20080610190351.GB15983@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Jun_2008_09_48_27_+1000_2UG5SqOxCC9Wpg2v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Jun_2008_09_48_27_+1000_2UG5SqOxCC9Wpg2v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Tue, 10 Jun 2008 21:03:51 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> On Tue, Jun 10, 2008 at 11:08:42AM +1000, Stephen Rothwell wrote:
> >=20
> > Reverting commit 68e9b79c8dad5245f28ab4f3527481b730dbdb61 ("kbuild:
> > simplify vmlinux link stage") makes the build work again.
>=20
> Updated kbuild-next.git pushed out with this bug fixed.
> Thanks for reporting/testing it.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_Jun_2008_09_48_27_+1000_2UG5SqOxCC9Wpg2v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhPEssACgkQTgG2atn1QN9upQCfYnhu7WF39/Ojsvqburh0Qpit
ZCgAnA3r2OXRd9u/Uz6LLiC5yXChz6FK
=3EKE
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Jun_2008_09_48_27_+1000_2UG5SqOxCC9Wpg2v--
