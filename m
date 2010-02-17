Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab0BQWan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:30:43 -0500
Received: from clegg.madduck.net ([193.242.105.96]:38129 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0BQWaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:30:39 -0500
Date: Thu, 18 Feb 2010 11:29:59 +1300
From: martin f krafft <madduck@madduck.net>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: david@lang.hm, Volker Armin Hemmann <volkerarmin@googlemail.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
       Neil Brown <neilb@suse.de>,
       "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>
Subject: boot times, not mdadm (was: Linux mdadm superblock question.)
Message-ID: <20100217222959.GD27815@lapse.rw.madduck.net>
Mail-Followup-To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	david@lang.hm, Volker Armin Hemmann <volkerarmin@googlemail.com>,
	Kyle Moffett <kyle@moffetthome.net>,
	Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
	Neil Brown <neilb@suse.de>,
	"Mr. James W. Laferriere" <babydr@baby-dragons.com>,
	Bill Davidsen <davidsen@tmr.com>,
	Michael Evans <mjevans1983@gmail.com>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
 <20100217181016.GA14983@emergent.ellipticsemi.com>
 <201002171927.07051.volkerarmin@googlemail.com>
 <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
 <20100217185105.GA15614@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171317080.4721@asgard.lang.hm>
 <20100217213741.GA16938@emergent.ellipticsemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="cPi+lWm09sJ+d57q"
Content-Disposition: inline
In-Reply-To: <20100217213741.GA16938@emergent.ellipticsemi.com>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.32-1-686 i686
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cPi+lWm09sJ+d57q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Nick Bowler <nbowler@elliptictech.com> [2010.02.18.1037 +1300]:
> > the assembly time would probably be the same, but the initramfs being=
=20
> > proposed did not include that time either.
>=20
> This was the *only* time that was included.  Quoting myself:

If you are discussing boot times rather than mdadm, might I suggest
you change the subject line?

Upstream is keen on finally dropping kernel autoassembly, and
I support that because of the gained flexibility. Boot times are
important for laptops and desktops, which are hardly the primary
target of RAID.

Anyway, this is FLOSS. If you want kernel autoassembly, take over
the code and bring it up to speed.

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"what's your conceptual continuity? --
 well, it should be easy to see:
 the crux of the bisquit is the apopstrophe!"
                                                        -- frank zappa
=20
spamtraps: madduck.bogus@madduck.net

--cPi+lWm09sJ+d57q
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkt8becACgkQIgvIgzMMSnVTZACfcZBPy7jGwATI83NV9Wai5HAy
BaEAoI1JpUjAT6T4nTDRBLAlVz5ymT6+
=CdXY
-----END PGP SIGNATURE-----

--cPi+lWm09sJ+d57q--
