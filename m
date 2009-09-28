Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293AbZI1AR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbZI1AR3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 20:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZI1AR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 20:17:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42357 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZI1AR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 20:17:28 -0400
Date: Mon, 28 Sep 2009 10:17:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc1
Message-Id: <20090928101726.74ee3f5f.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.01.0909271650480.3349@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
	<20090928094458.4ad704c2.sfr@canb.auug.org.au>
	<alpine.LFD.2.01.0909271650480.3349@localhost.localdomain>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Sep_2009_10_17_26_+1000_9Nbnf.8sTLJLfXAL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Sep_2009_10_17_26_+1000_9Nbnf.8sTLJLfXAL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 27 Sep 2009 16:52:56 -0700 (PDT) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
> Ok, so it's an extra-special -rc1. It's the "short bus" kind of special=20
> -rc1 release. But quite frankly, I'll just let it be. The git tags etc=20
> look to be ok, it's just my editing of the Makefile itself that was too=20
> complicated for my little mind.

I was going to apply a patch to -next to set it to -rc1, but I won't
do that either.  This way all bug reports are consistently confusing :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Sep_2009_10_17_26_+1000_9Nbnf.8sTLJLfXAL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrAAJYACgkQjjKRsyhoI8x5JwCfVKyc3vGnH6UeyZH6s3H7lzhg
hlwAoK7WnDf1vHhdV1hNTV3Sil7acIwl
=bOuY
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Sep_2009_10_17_26_+1000_9Nbnf.8sTLJLfXAL--
