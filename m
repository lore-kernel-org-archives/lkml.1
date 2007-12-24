Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbXLXNFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbXLXNFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 08:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXLXNFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 08:05:46 -0500
Received: from virgo.iok.hu ([193.202.89.103]:22092 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXLXNFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 08:05:46 -0500
X-Greylist: delayed 889 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Dec 2007 08:05:46 EST
Date: Mon, 24 Dec 2007 13:50:55 +0100
From: Miklos Vajna <vmiklos@frugalware.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>
Subject: Re: Updated Kernel Hacker's guide to git
Message-ID: <20071224125055.GC23659@genesis.frugalware.org>
References: <200612241807.kBOI746w008739@laptop13.inf.utfsm.cl> <476E42BF.1010300@garzik.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <476E42BF.1010300@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 23, 2007 at 06:13:03AM -0500, Jeff Garzik <jeff@garzik.org> wro=
te:
> Another year, another update!  :)
>=20
> The kernel hacker's guide to git has received some updates:
>=20
> 	http://linux.yyz.us/git-howto.html

one minor note:

i would suggest using:

$ git shortlog master..HEAD

instead of

$ git log master..HEAD | git shortlog

to avoid unnecessary complexity :)

thanks,
- VMiklos

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHb6sve81tAgORUJYRArjKAKCopDkv4T6GaZ/gyZcRbRBvi7wKEACeOb2T
m5UcBatSuM2uIemdHbUNRQw=
=pJZy
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
