Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbZIXGI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbZIXGI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 02:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZIXGI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 02:08:27 -0400
Received: from ms01.sssup.it ([193.205.80.99]:59984 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752486AbZIXGI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 02:08:27 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Raistlin <raistlin@linux.it>
To: GeunSik Lim <leemgs1@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <49b7c2350909231734h936f76fq5cdb056ff6144076@mail.gmail.com>
References: <1253615424.20345.76.camel@Palantir>
	 <49b7c2350909231734h936f76fq5cdb056ff6144076@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sRb7M8tT9zDVrrX+Pv6K"
Date: Thu, 24 Sep 2009 08:08:26 +0200
Message-Id: <1253772506.5710.26.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sRb7M8tT9zDVrrX+Pv6K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-24 at 09:34 +0900, GeunSik Lim wrote:
> Hi Raistlin,
>=20
Hi,

> You have to modify  git address of schedtool-edf at
> http://www.evidence.eu.com/sched_edf.html correctly.
>=20
> before) git clone git://feanor.sssup.it/sched-tool-edf.git
> after   ) git clone git://feanor.sssup.it/schedtool-edf.git
>=20
Oh, I see... Many thanks, we'll fix this! :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-sRb7M8tT9zDVrrX+Pv6K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq7DNMACgkQk4XaBE3IOsSMpgCdFpdFayo7j4lwRtTy91gQJ7eP
KeEAoKQeewX1hZF4IPreC9nzEtyx+aw4
=QSqU
-----END PGP SIGNATURE-----

--=-sRb7M8tT9zDVrrX+Pv6K--

