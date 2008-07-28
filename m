Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYG1Pxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYG1Pxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYG1Pxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:53:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58928 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbYG1Pxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:53:38 -0400
Date: Tue, 29 Jul 2008 01:53:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Please pull powerpc.git merge branch
Message-Id: <20080729015330.39aff7a5.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.1.10.0807280838580.3486@nehalem.linux-foundation.org>
References: <1217239117.11188.187.camel@pasglop>
	<alpine.LFD.1.10.0807280838580.3486@nehalem.linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Jul_2008_01_53_30_+1000_otV=jz8EaQGALWEd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Jul_2008_01_53_30_+1000_otV=jz8EaQGALWEd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 28 Jul 2008 08:40:44 -0700 (PDT) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
> On Mon, 28 Jul 2008, Benjamin Herrenschmidt wrote:
> >=20
> > It's all in:
> >=20
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge
>=20
> It doesn't really seem to be. I get "Already up-to-date.", and the top=20
> commit there seems to be from July 3..
>=20
> Forgot to push?

It should be

	git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Ben seems to have copied from one of Paul's pull requests.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Jul_2008_01_53_30_+1000_otV=jz8EaQGALWEd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiN63oACgkQjjKRsyhoI8z3RQCfUvfYXEWwAfDrjZlUX/rD7Zjo
IEMAoInTZg5TsnWFGxBZ4caAKTlNKTxd
=H+1v
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Jul_2008_01_53_30_+1000_otV=jz8EaQGALWEd--
