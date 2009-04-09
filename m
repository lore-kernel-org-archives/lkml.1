Return-Path: <linux-kernel-owner+w=401wt.eu-S937207AbZDIXsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937207AbZDIXsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762290AbZDIXrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:47:53 -0400
Received: from lug-owl.de ([195.71.106.12]:35194 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759572AbZDIXrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:47:52 -0400
Date: Fri, 10 Apr 2009 01:47:50 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>,
       Robin Holt <holt@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
Message-ID: <20090409234750.GE7921@lug-owl.de>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ia64@vger.kernel.org
References: <20090408003921.GA5054@ldl.fc.hp.com> <20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com> <20090407225457.86f8a458.akpm@linux-foundation.org> <20090409003308.GK16602@bilbo.ozlabs.org> <20090408174443.79e71503.akpm@linux-foundation.org> <20090409215207.GN16602@bilbo.ozlabs.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HoGc7FifFwma1EOu"
Content-Disposition: inline
In-Reply-To: <20090409215207.GN16602@bilbo.ozlabs.org>
X-Operating-System: Linux mail 2.6.18-5-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological
	nuclear warfare test the bombastical terror of flooding the spy
	listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear
	warfare test the bombastical terror of flooding the spy listeners
	explosion sex drugs and rock'n'roll
X-message-flag: Please send plain text messages only. Do not send HTML
	emails. Thank you. 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HoGc7FifFwma1EOu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-10 07:52:07 +1000, Tony Breeds <tony@bakeyournoodle.com> wr=
ote:
> On Wed, Apr 08, 2009 at 05:44:43PM -0700, Andrew Morton wrote:
>=20
> > Please do.
>=20
> linux-next is built on powerpc so I needed to rebuild many of the compile=
rs for
> intel.

I've started a build-bot like script for binutils + GCC from CVS/GIT.
If it builds through, I'll start uploading i686 hosted compilers
later on today.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:                   ...und wenn Du denkst, es geht nicht mehr,
the second  :                          kommt irgendwo ein Lichtlein her.

--HoGc7FifFwma1EOu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkneiSYACgkQHb1edYOZ4bswUgCfQlTr6onpcA6ggwT0MTQZiY2J
Ke8AnR0ncRP8sQj1/DK9NaoD56Hu9lHM
=bb10
-----END PGP SIGNATURE-----

--HoGc7FifFwma1EOu--
