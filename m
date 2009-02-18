Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZBRJgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZBRJgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbZBRJgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:36:08 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:39126 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZBRJgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:36:04 -0500
Date: Wed, 18 Feb 2009 10:36:02 +0100
From: Nico Schottelius <nico-kernel@schottelius.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Eric Anholt <eric.anholt@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       Nico Schottelius <nico-linux-20090213@schottelius.org>
Subject: Re: [Bug #12705] X200: Brightness broken since
	2.6.29-rc4-58-g4c098bc
Message-ID: <20090218093602.GA7722@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel@schottelius.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Eric Anholt <eric.anholt@intel.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	Nico Schottelius <nico-linux-20090213@schottelius.org>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <1234911925.9844.89.camel@gaiman> <20090217231313.GA2654@srcf.ucam.org> <200902171523.57612.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <200902171523.57612.jbarnes@virtuousgeek.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc4-ikn-00001-gd5b5623 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Jesse Barnes [Tue, Feb 17, 2009 at 03:23:57PM -0800]:
> On Tuesday, February 17, 2009 3:13 pm Matthew Garrett wrote:
> > This was drm failing to initialise because of incorrect mtrr setup and
> > opregion not working as a result.
>=20
> I sent one out; it just made the ioremap in i915_initialize into an iorem=
ap_wc=20
> for consistency.

If you refer to <200902131104.04318.jbarnes@virtuousgeek.org>,
as stated in <20090216131351.GA4839@denkbrett.schottelius.org>, it does not
fix the problem here.

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmb1oIACgkQuL75KpiFGIwacACg6BGuVlCOJu2Is+pG9KvzbC1G
090AoNlj05w7V/uIRKhZlO7ws9jUKfmp
=wtZ8
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
