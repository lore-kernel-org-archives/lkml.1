Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbZCBSzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbZCBSzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbZCBSzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:55:17 -0500
Received: from clegg.madduck.net ([193.242.105.96]:42378 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322AbZCBSzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:55:15 -0500
Date: Mon, 2 Mar 2009 19:55:07 +0100
From: martin f krafft <madduck@madduck.net>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: /proc/sys/net/ip*/conf/all/* does not actually affect
	interfaces
Message-ID: <20090302185507.GA22070@piper.oerlikon.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20090302122718.GA3906@piper.oerlikon.madduck.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20090302122718.GA3906@piper.oerlikon.madduck.net>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.26-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach martin f krafft <madduck@madduck.net> [2009.03.02.1327 +0100]:
> A bit of investigation shows that something fishy is going on, or
> at least it's unexpected to me, because I recall the conf/all/*
> interface to do what it promised to do a while ago. Not anymore
> though.

Sorry for being an idiot and not including the important data: this
happens on Debian kernels 2.6.24-.28 across several machines.
I checked the Debian diff but could not find anything that seems
related, and I reproduced it with 2.6.29-rc6-git5.

Thanks,

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
the security, stability and reliability of a computer system
is reciprocally proportional to
the amount of vacuity between the ears of the admin.
=20
spamtraps: madduck.bogus@madduck.net

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmsK4sACgkQIgvIgzMMSnWT2gCfXOdq9hWx1t2ZQThgrSM1MUAJ
ak4An1xdYsfouqUncFWrznj11jtDSQXO
=6G/5
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
