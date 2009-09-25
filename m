Return-Path: <linux-kernel-owner+w=401wt.eu-S1752025AbZIYFfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbZIYFfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 01:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZIYFfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 01:35:46 -0400
Received: from ms01.sssup.it ([193.205.80.99]:41810 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751202AbZIYFfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 01:35:45 -0400
Subject: Re: massive_intr on CFS, BFS, and EDF
From: Raistlin <raistlin@linux.it>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4ABC38A3.9060107@jp.fujitsu.com>
References: <4ABC068A.6070704@jp.fujitsu.com>
	 <4ABC38A3.9060107@jp.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7A6cm4IBAjnfjbzV0XZH"
Date: Fri, 25 Sep 2009 07:35:45 +0200
Message-Id: <1253856945.1594.2.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7A6cm4IBAjnfjbzV0XZH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-09-25 at 12:27 +0900, Satoru Takeuchi wrote:
> In addition, aptitude and oocalc are not SCHED_EDF, but SCHED_OTHER
> (SCHED_FAIR). So you probably broke some codes other than sched_edf
> part.
>=20
Strange... It does not happen here, I'll investigate.

Thanks again,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-7A6cm4IBAjnfjbzV0XZH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq8VrEACgkQk4XaBE3IOsTvCACfV7gjuMO+b2UOy5DogBnu7APe
QSwAnRc/LiIPt/C6aVpLu1jNVLyC7f5m
=iVUK
-----END PGP SIGNATURE-----

--=-7A6cm4IBAjnfjbzV0XZH--

