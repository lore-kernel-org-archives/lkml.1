Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZAFDF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZAFDF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 22:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZAFDFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 22:05:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54683 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbZAFDFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 22:05:04 -0500
Date: Tue, 6 Jan 2009 14:04:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Jonathan Brassow <jbrassow@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Andi Kleen <ak@suse.de>, Cheng Renquan <crquan@gmail.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [git pull] device-mapper patches for 2.6.29
Message-Id: <20090106140448.a4f54d2b.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>
References: <20081010125159.GK5098@agk.fab.redhat.com>
	<20090105191824.GP5098@agk.fab.redhat.com>
	<alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_Jan_2009_14_04_48_+1100_.iX5JcqqJq4DdTcQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Jan_2009_14_04_48_+1100_.iX5JcqqJq4DdTcQ
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair.

On Mon, 5 Jan 2009 18:51:00 -0800 (PST) Linus Torvalds <torvalds@linux-foun=
dation.org> wrote:
>
> Oh no, this is totally broken, and doesn't compile even with my fairly=20
> minimal install:
>=20
>   drivers/md/dm-target.c: In function =E2=80=98dm_unregister_target=E2=80=
=99:
>   drivers/md/dm-target.c:106: error: implicit declaration of function =E2=
=80=98module_refcount=E2=80=99

This is from a patch added to linux-next only yesterday and was
reported by Randy Dunlap from his overnight build testing.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Jan_2009_14_04_48_+1100_.iX5JcqqJq4DdTcQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkliylAACgkQjjKRsyhoI8zb9wCfWOSEjPCUWjxLSj9P0tNdiNUe
v8sAoLoUNxIaR1gnZd03C8jb9RCPo8Q9
=R8nO
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Jan_2009_14_04_48_+1100_.iX5JcqqJq4DdTcQ--
