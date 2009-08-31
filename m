Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZHaSQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZHaSQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbZHaSQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:16:38 -0400
Received: from clegg.madduck.net ([193.242.105.96]:52350 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZHaSQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:16:36 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Aug 2009 14:16:35 EDT
Date: Mon, 31 Aug 2009 20:07:46 +0200
From: martin f krafft <madduck@debian.org>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
       NeilBrown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
       Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Message-ID: <20090831180746.GA32110@piper.oerlikon.madduck.net>
Mail-Followup-To: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
	Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	NeilBrown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
References: <4A947682.2010204@redhat.com>
 <200908262253.17886.rob@landley.net>
 <4A967175.5070700@redhat.com>
 <20090827221319.GA1601@ucw.cz>
 <4A9733C1.2070904@redhat.com>
 <20090828064449.GA27528@elf.ucw.cz>
 <20090828120854.GA8153@mit.edu>
 <20090830075135.GA1874@ucw.cz>
 <20090830152023.GB23828@mit.edu>
 <4807377b0908311049id9a2167r937bc8447c2b3546@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <4807377b0908311049id9a2167r937bc8447c2b3546@mail.gmail.com>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.31-rc3-amd64 x86_64
X-Subliminal-Message: debian/rules!
Organization: The Debian project
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Jesse Brandeburg <jesse.brandeburg@gmail.com> [2009.08.31.1949 =
+0200]:
> In the case of a degraded array, could the kernel be more
> proactive (or maybe even mdadm) and have the filesystem remount
> itself withOUT journalling enabled? =A0This seems on the surface to
> be possible, but I don't know the internal particulars that might
> prevent/allow it.

Why would I want to disable the filesystem journal in that case?

--=20
 .''`.   martin f. krafft <madduck@d.o>      Related projects:
: :'  :  proud Debian developer               http://debiansystem.info
`. `'`   http://people.debian.org/~madduck    http://vcs-pkg.org
  `-  Debian - when you have better things to do than fixing systems
=20
"i can stand brute force, but brute reason is quite unbearable. there
 is something unfair about its use. it is hitting below the
 intellect."
                                                        -- oscar wilde

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREDAAYFAkqcEXEACgkQIgvIgzMMSnWmoQCggF5B5eXZnpgB+Gl3BwXUtEaU
DJEAoL8ml704eMQojLX4Pepo6IajlrUV
=VeIZ
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
