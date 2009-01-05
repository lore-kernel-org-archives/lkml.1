Return-Path: <linux-kernel-owner+w=401wt.eu-S1759697AbZAEBOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697AbZAEBOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 20:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbZAEBOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 20:14:43 -0500
Received: from b01.ext.isohunt.com ([208.71.112.51]:35259 "EHLO
	mail.isohunt.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751931AbZAEBOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 20:14:42 -0500
Date: Sun, 4 Jan 2009 17:07:10 -0800
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: "Robin H. Johnson" <robbat2@gentoo.org>, viro@zeniv.linux.org.uk,
       Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: reiserfs broken "unknown uniqueness" (commit
	c1eaa26b671299b3ec01d40c6c71ee19a4f81517)
Message-ID: <20090105010710.GZ32364@curie-int.orbis-terrarum.net>
References: <20090104112436.GT32364@curie-int.orbis-terrarum.net> <b6a2187b0901040453rd914823kb5574f432c71f9f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qa+qcrCtlQ17sJ4A"
Content-Disposition: inline
In-Reply-To: <b6a2187b0901040453rd914823kb5574f432c71f9f8@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qa+qcrCtlQ17sJ4A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 04, 2009 at 08:53:29PM +0800, Jeff Chua wrote:
> It's fixed in the link to this one ...
>    reiserfs broken with 2.6.28-17244-gb58602a
Ok, I confirm that Al's patch fixes it, send it to Linus?

--=20
Robin Hugh Johnson
Gentoo Linux Developer & Infra Guy
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

--Qa+qcrCtlQ17sJ4A
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks - The text below is a digital signature. If it doesn't make any sense to you, ignore it.

iEYEARECAAYFAklhXT4ACgkQPpIsIjIzwizpfACfV3kfnuSeoHCsfvAb2uaXPyv4
9pEAnR7OyUu4vmxgzhPHLOORXmDyb9Xd
=Z1gu
-----END PGP SIGNATURE-----

--Qa+qcrCtlQ17sJ4A--
