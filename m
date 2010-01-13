Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868Ab0AMKmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab0AMKmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835Ab0AMKmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:42:06 -0500
Received: from ms01.sssup.it ([193.205.80.99]:40539 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755833Ab0AMKmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:42:05 -0500
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: core of the scheduling class
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1262089649.7135.140.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707614.6228.453.camel@Palantir>  <1262089649.7135.140.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-86YpH2pDbRf1TxyJxx1S"
Date: Wed, 13 Jan 2010 11:42:02 +0100
Message-ID: <1263379322.3853.76.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-86YpH2pDbRf1TxyJxx1S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-29 at 13:27 +0100, Peter Zijlstra wrote:
> On Fri, 2009-10-16 at 17:40 +0200, Raistlin wrote:
> > +       if (unlikely(task_has_deadline_policy(p) || task_has_rt_policy(=
p))) {
>=20
> small nit, since both task_has_{deadline,rt}_policy() already have
> unlikely()s in, this extra unlikely is not needed.
>=20
Coping. :-)

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-86YpH2pDbRf1TxyJxx1S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktNo3oACgkQk4XaBE3IOsSwCACghtdH4rmD1gDaHxdDE7krHvn9
JNMAn2otUwripQwVGmlyvdXwjRcb87o2
=PY0O
-----END PGP SIGNATURE-----

--=-86YpH2pDbRf1TxyJxx1S--

