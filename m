Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbXGROiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbXGROiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbXGROiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:38:09 -0400
Received: from users.crfreenet.org ([81.92.145.1]:34518 "EHLO
	mail.crfreenet.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752319AbXGROiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:38:08 -0400
Date: Wed, 18 Jul 2007 16:38:03 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Michal Januszewski <spock@gentoo.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbdev: find mode with highest refresh rate in fb_find_mode()
Message-ID: <20070718143803.GA5787@localhost.localdomain>
References: <20070718084102.GA22694@spock.one.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <20070718084102.GA22694@spock.one.pl>
X-Operating-System: Debian GNU/Linux 3.1 (Sarge)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 18, 2007 at 10:41:02AM +0200, Michal Januszewski wrote:
> Currently if the refresh rate is not specified fb_find_mode() returns
> the first known video mode with the requested resoluion, which provides
> no guarantees wrt the refresh rate.  Change this so that the mode with
> the highest refresh rate is returned instead.

What refresh rate it sets when used on card or monitor without DDC?

--=20
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org, jabber: santiago@=
njs.netlab.cz)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEARECAAYFAkaeJcsACgkQw1GB2RHercMfpACfb5jkqTVOaFcZYW8s0dKLMRUq
fl8An1eKj5cq3cZ3L3LutKUTHUwKDf2F
=a1NI
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
