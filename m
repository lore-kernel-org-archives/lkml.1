Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbZCENA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbZCENA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZCENAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:00:46 -0500
Received: from clegg.madduck.net ([193.242.105.96]:47329 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZCENAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:00:45 -0500
Date: Thu, 5 Mar 2009 14:00:17 +0100
From: martin f krafft <madduck@debian.org>
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Future of md multipath
Message-ID: <20090305130017.GA1696@piper.oerlikon.madduck.net>
Mail-Followup-To: Neil Brown <neilb@suse.de>,
	Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090303180433.GA27569@lst.de> <18863.15828.150450.275712@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <18863.15828.150450.275712@notabene.brown>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.26-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
Organization: The Debian project
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb@suse.de> [2009.03.05.0349 +0100]:
> I'm in favour of deprecating it.  Whenever I hear of people using it I
> suggest dm-multipath, but there could people I don't here about.
> I think the upcoming mdadm-3.0 will need a compile-time option to
> enable multipath, so people will only get it if they really really
> want it.

How do you propose a distro to deal with this? Keep it enabled for
a certain time (with a deprecation warning?) and then just to close
the doors on users who still need it?

How long will you support it after deprecation?

I understand that dm-multipath is more favourable, but unless
there's a riskless way to convert mdadm multipath into dm-multipath
on old systems, I don't think we have the option of deprecating it,
unless deprecation lasts for several years.

--=20
 .''`.   martin f. krafft <madduck@d.o>      Related projects:
: :'  :  proud Debian developer               http://debiansystem.info
`. `'`   http://people.debian.org/~madduck    http://vcs-pkg.org
  `-  Debian - when you have better things to do than fixing systems
=20
"the perfect gun is an idealist without any ideal."
                                                  -- mc 900 ft jesus

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmvzOAACgkQIgvIgzMMSnWbdgCfYDKm4NPAjlfy6bRGkz90cocD
lloAoKEeOvdfXqE8xkTNENcI6XrpSqmu
=kZ+A
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
