Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZJQXXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZJQXXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 19:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbZJQXXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 19:23:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41543 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbZJQXXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 19:23:07 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <6a3d8d2c4775189d3f854bdd25a87b0d2e37987e.1255811956.git.joe@perches.com>
References: <6a3d8d2c4775189d3f854bdd25a87b0d2e37987e.1255811956.git.joe@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6dxJVV11QnqpKIFUA0qM"
Date: Sun, 18 Oct 2009 00:23:01 +0100
Message-Id: <1255821781.2488.643.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 1/1] scripts/get_maintainer.pl: Add --roles and
 --rolestats
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6dxJVV11QnqpKIFUA0qM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-17 at 13:47 -0700, Joe Perches wrote:
> --roles shows the role of each email address, i.e. why it was selected.
> --rolestats selects --roles and adds git log/blame signers #'s and %
>=20
> Multiple roles are possible (supporter, maintainer, git-signer...)
>=20
> --roles or --rolestats is meant to help identify appropriate maintainers
> to notify and should not be used with "git send-email --cc-cmd"
[...]
> Other changes:
>=20
> Format git-signers email addresses a bit to reduce bad signatures
> Command line bad arguments emitted a verbose usage(), just show --help
> Version number bumped to .22
>=20
> Ben Hutchings <ben@decadent.org.uk> had the idea and created a good deal
> of this implementation.

You're too modest!

> Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Ben.

--=20
Ben Hutchings
It is impossible to make anything foolproof because fools are so ingenious.

--=-6dxJVV11QnqpKIFUA0qM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAStpR0Oe/yOyVhhEJAQLACA//RugQUEXTvWqA2x6JXQYlj2tlKmbfCvZx
hHc1QjePaAbsjTTTNbY1V3mlBO6j+jdbDhR2FDqDiEsfWbELBWiwzl8XtvMotoE1
5pIWKKPq6Nja8FCxg5rDwMmippP8tWlHp05xPMjj7d4OTuSJeEypZbZmMngC1bYh
YMAZTjdCJ+Ke9r5oSoaVa2wrk7rrsMXsbjHrj721TV5yxC0DOkXIdBUFi00HRROv
PjURg3ckFPsDHicf/LvI94z7YlLxC7Fj6kaaNV2dAXhW7U5dgorC0/cLEkcjt8zq
S7tVB871Z9mPAgAVfjWMYkrL4hwaXDhkwm+8kiINaBD4vfJm8Yq4hr7/pUvdkFK3
rYiOvDur8C0ueUB33ecgTGCHHBQqloPNHnXLwM8ZE+mNNyQj2VgITy8ZwbAopevS
N/aPxsuCExAwRHuC+wdmWEd9SRdsiibxRIgNKqxUHd0VjOlEW8dOp679WSRSly6U
W60lqbP1QPEx4DXXr5UreLw0AgBrX4oPOSlQKC0sF7giDETgDiJ0dRB1mXOqEJMQ
W00kHjBxVLghxfD4q8UK+MX9DWoiV4Dwzqx5hcJ7O+2Ymas/1L3iS/ulUNUMR/2u
nJg7lzyNratuuajH8CUWCk9DfTYuaoIEsUYBuafutQTLnzQsT54k9up5c5Z/s1yq
PI1Q+TyN5DA=
=9e03
-----END PGP SIGNATURE-----

--=-6dxJVV11QnqpKIFUA0qM--
