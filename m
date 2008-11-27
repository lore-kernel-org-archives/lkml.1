Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYK0W6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYK0W6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 17:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYK0W6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 17:58:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53353 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbYK0W6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 17:58:32 -0500
Date: Fri, 28 Nov 2008 09:58:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: linux-next: trivial tree
Message-Id: <20081128095814.8c3a2b43.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LNX.1.10.0811271145180.19853@jikos.suse.cz>
References: <alpine.LNX.1.10.0811271145180.19853@jikos.suse.cz>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_Nov_2008_09_58_14_+1100_63c+KDuE01P.4YqW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Nov_2008_09_58_14_+1100_63c+KDuE01P.4YqW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Thu, 27 Nov 2008 11:49:59 +0100 (CET) Jiri Kosina <jkosina@suse.cz> wrot=
e:
>
> I have taken over trivial patches maintainership from Jesper. I will=20
> process all the patches in Jesper's queue when he sends them over to me.=
=20
> Could you please re-introduce trivial tree into linux-next lineup? It is=
=20
> 'for-next' branch of
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-next

Added from today.

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

--Signature=_Fri__28_Nov_2008_09_58_14_+1100_63c+KDuE01P.4YqW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkvJgYACgkQjjKRsyhoI8yEfACfQ0Uv3rIgdm9pqP2uQvdcXunn
6sgAoLCtLjhFrVraWnjS2DioKuzy00GW
=sPck
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Nov_2008_09_58_14_+1100_63c+KDuE01P.4YqW--
