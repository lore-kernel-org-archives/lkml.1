Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYKZPV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYKZPV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbYKZPVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:21:02 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49877 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336AbYKZPVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:21:00 -0500
Date: Thu, 27 Nov 2008 02:20:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tj@kernel.org
Subject: Re: [linux-next] fuse tree
Message-Id: <20081127022036.1dd0e2e6.sfr@canb.auug.org.au>
In-Reply-To: <E1L5Ia7-0001gb-2X@pomaz-ex.szeredi.hu>
References: <E1L5Ia7-0001gb-2X@pomaz-ex.szeredi.hu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__27_Nov_2008_02_20_36_+1100_kNxGcoupKBlur1uu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Nov_2008_02_20_36_+1100_kNxGcoupKBlur1uu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Miklos,

On Wed, 26 Nov 2008 12:29:19 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Could you please add the following git tree, containing fuse patches
> to be included in 2.6.29, to the linux-next lineup?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-next

I have added it for tomorrow's tree.

What I tell everyone: all patches in that branch must have been
	posted to a relevant mailing list
	reviewed
	unit tested
	destined for the next merge window (or the current release)
*before* they are included.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__27_Nov_2008_02_20_36_+1100_kNxGcoupKBlur1uu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkktaUQACgkQjjKRsyhoI8y4gwCcCA7lEdBzgLe0kg22KjdQPTON
b6IAn2hedVo1UYEJOPwHXnNaxV6rOaEZ
=0V+j
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Nov_2008_02_20_36_+1100_kNxGcoupKBlur1uu--
