Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbZFIH1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbZFIH1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756697AbZFIH1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:27:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49634 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240AbZFIH1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:27:42 -0400
Date: Tue, 9 Jun 2009 17:27:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, tj@kernel.org, vapier@gentoo.org
Subject: Re: linux-next: manual merge of the vfs tree with the  tree
Message-Id: <20090609172729.0217dfd2.sfr@canb.auug.org.au>
In-Reply-To: <E1MDvHY-0006N1-06@pomaz-ex.szeredi.hu>
References: <20090609110815.0abd1de0.sfr@canb.auug.org.au>
	<E1MDvHY-0006N1-06@pomaz-ex.szeredi.hu>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Jun_2009_17_27_29_+1000_G+CRR8zfKwutohg2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jun_2009_17_27_29_+1000_G+CRR8zfKwutohg2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Miklos,

On Tue, 09 Jun 2009 08:58:04 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Hmm, looks like that CUSE_SUPER_MAGIC is an unused remnant from an
> earlier version of the CUSE patchset.  I'll fix that up in the fuse
> tree.

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Jun_2009_17_27_29_+1000_G+CRR8zfKwutohg2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkouDuEACgkQjjKRsyhoI8ygygCfb6VF2RL4KAe7SGIf2A9vQ4Jm
GroAoLKKVAkfkpXQFueLBDsrxAEE1xn1
=eP04
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jun_2009_17_27_29_+1000_G+CRR8zfKwutohg2--
