Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZAVLLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZAVLLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 06:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbZAVLLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 06:11:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35901 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbZAVLLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 06:11:39 -0500
Date: Thu, 22 Jan 2009 22:11:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Finish fs/Kconfig split
Message-Id: <20090122221123.ef9bd664.sfr@canb.auug.org.au>
In-Reply-To: <20090122104316.GA3631@x200.localdomain>
References: <20090122104316.GA3631@x200.localdomain>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Jan_2009_22_11_23_+1100_9fid7cjr+xAZnUuc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Jan_2009_22_11_23_+1100_9fid7cjr+xAZnUuc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexey,

On Thu, 22 Jan 2009 13:43:16 +0300 Alexey Dobriyan <adobriyan@gmail.com> wr=
ote:
>
> Linus, please pull from
>=20
> 	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/misc.git Kconfig
>=20
> to get finalization of fs/Kconfig split into individual fs/*/Kconfig file=
s.
> FS maintainers liked the idea overall and patches for ext* et al are alre=
ady in.
>=20
> I can sit here and carefully minimize reject pain for everyone or you can=
 do
> the right thing.

There were a few conflicts against the current linux-next, but they were
all in the nfs tree (and the FS-Cache changes in there) apart from one
small conflict in the nfsd tree.  None looked hard to fix up (as you would
expect).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Jan_2009_22_11_23_+1100_9fid7cjr+xAZnUuc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl4VFsACgkQjjKRsyhoI8w+DQCgqcz4swGhvNEvtg0X7lviTTSF
L9wAn1GhXJMCg4gt2AEaMzIJRtlcku3H
=h/9W
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Jan_2009_22_11_23_+1100_9fid7cjr+xAZnUuc--
