Return-Path: <linux-kernel-owner+w=401wt.eu-S968125AbXHMOYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968125AbXHMOYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967287AbXHML0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:26:42 -0400
Received: from mail.samba.org ([66.70.73.150]:45655 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967283AbXHML0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:26:40 -0400
X-Greylist: delayed 1991 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 07:26:40 EDT
Subject: Re: [PATCH] [123/2many] MAINTAINERS - COMMON INTERNET FILE SYSTEM
	(CIFS)
From: Andrew Bartlett <abartlet@samba.org>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, sfrench@samba.org,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, akpm@linux-foundation.org
In-Reply-To: <46bff94b.cqAV08ZZtCVJZMCU%joe@perches.com>
References: <46bff94b.cqAV08ZZtCVJZMCU%joe@perches.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VrSuXxAsudlyV6ESsgRD"
Date: Mon, 13 Aug 2007 20:53:20 +1000
Message-Id: <1187002400.22086.6.camel@dragonlady>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VrSuXxAsudlyV6ESsgRD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-08-12 at 23:25 -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1c014f1..5144e4e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1201,6 +1201,7 @@ L:	samba-technical@lists.samba.org
>  W:	http://us1.samba.org/samba/Linux_CIFS_client.html
>  T:	git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
>  S:	Supported
> +F:	fs/cifs/

No comment on the F:, but the L: entry here is interesting.  Is
samba-technical really the right list for cifs-vfs patches?  Aside from
being CC'ed on such patches, I've never seen discussion of them on the
Samba mailing lists.=20

Steve: Shouldn't that be linux-cifs-client?

Andrew Bartlett

--=20
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
Samba Developer, Red Hat Inc.                  http://redhat.com

--=-VrSuXxAsudlyV6ESsgRD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGwDgfz4A8Wyi0NrsRAk/bAJ0TJmk857RvTQm8074Iq9EOCIe21gCgmsRB
xPD+ec9f5wKvFcUZWE/hWos=
=k1E1
-----END PGP SIGNATURE-----

--=-VrSuXxAsudlyV6ESsgRD--

