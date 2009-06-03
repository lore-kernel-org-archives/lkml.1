Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZFCISW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZFCISW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZFCISL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:18:11 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:52943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbZFCISJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:18:09 -0400
Subject: Re: linux-next: manual merge of the trivial tree with the wireless
 tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matt LaPlante <kernel1@cyberdogtech.com>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <alpine.LNX.2.00.0906031006270.7457@wotan.suse.de>
References: <20090603152247.b52f552e.sfr@canb.auug.org.au>
	 <alpine.LNX.2.00.0906031006270.7457@wotan.suse.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/1pc8Y4Y2br3JrY68qCn"
Date: Wed, 03 Jun 2009 10:14:11 +0200
Message-Id: <1244016851.7176.32.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/1pc8Y4Y2br3JrY68qCn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-03 at 10:07 +0200, Jiri Kosina wrote:
> On Wed, 3 Jun 2009, Stephen Rothwell wrote:
>=20
> > Today's linux-next merge of the trivial tree got a conflict in=20
> > Documentation/rfkill.txt between commit=20
> > c6d660ce29295d344fcdc3654274b4a0aad1a9c8 ("rfkill: rewrite") from the=20
> > wireless tree and commit 9976d9daf91d146724ad9c336f74c60d2195c386=20
> > ("trivial: Miscellaneous documentation typo fixes") from the trivial=20
> > tree.
> > I just used the version from the wireless tree since it has been
> > basically rewritten there (except I applied the "transmiter" to
> > "transmitter" fix - see below).  Maybe the part of the trivial tree pat=
ch
> > that affects this file should be dropped.
>=20
> Hi,
>=20
> thanks for letting me know. I have dropped the Documentation/rfkill.txt=20
> hunk completely.=20
>=20
> Wireless guys, will you please apply the transmiter -> transmitter fix to=
=20
> your tree?

Will do.

johannes

--=-/1pc8Y4Y2br3JrY68qCn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJjDQAAoJEODzc/N7+QmaGpsP/iLhPdelHXIVEdmSff/I89nu
aCAhEalv5SYGAqxz7U3CIKE2OCQf5UdBBopFolPCTKBr7lXfBSPX59Lwui3pm2Px
LaPx4dQT5AeqmdDOu9Z2F4sz9GLubgsHqL9KE2rgm5tnn0yuR5WDxJh0PQ0misAI
iCpI8ltkVDYVsOvqY6Z6KPHyTYo/YBRZUpS3fpbgPZB+wWmcQ6yGgJPUXfaZNrOE
lmO5n7k0Az1uYAhLUGnpZHhDBYwDJF+uVDLvInBKm4ShKebVwYMFqMTlZY9+e/rl
AsKrgXn+LtCkr7MRrtYycm+govwEuJQVqQ81hYeL/WfPkgVWewDBY/N4fXMkp80X
Z6rctUvQK1nVJu/WsKpoHIosnMizeEhmlh7zzHIu50Vf5ZpqTgc+NbwWrYkBdXjC
i92Y+1UcWbgo75DIsUmUh7SUKUFJFYEblOLnFzojnSC1eaTzuaat/k7UYsynhjaN
yvGLPhnoWRpVt5TV7aNdE4AHN84hvKmYjz/+nZHZrrVEQFKkVexDDJtCRX0WoThl
5VeKtgDnIiT3sFB/heyifc3+Znn2vO1uNZmeJFuXnH3qNfPyhYRPxVj4bo5Z9+yR
8aKjA9gCLL/Yt/yWRhKaWtBVBA9B2RI8gVFZnRVKVuRh3JJCptMnBkHuDT74mAXS
42qYcUrwkXsYn8KDW5hW
=TWWK
-----END PGP SIGNATURE-----

--=-/1pc8Y4Y2br3JrY68qCn--

