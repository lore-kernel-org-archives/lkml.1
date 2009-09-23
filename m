Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZIWHDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZIWHDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZIWHDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:03:08 -0400
Received: from ms01.sssup.it ([193.205.80.99]:39845 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751594AbZIWHDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:03:07 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Raistlin <raistlin@linux.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Daniel Walker <dwalker@fifo99.com>,
       claudio@evidence.eu.com, michael@evidence.eu.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <20090922191117.GB24542@elte.hu>
References: <1253615424.20345.76.camel@Palantir>
	 <1253625878.6575.34.camel@desktop> <1253628061.20345.173.camel@Palantir>
	 <1253637721.18939.3.camel@laptop>  <20090922191117.GB24542@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Sogm41+felhOgKgWxwc6"
Date: Wed, 23 Sep 2009 09:03:07 +0200
Message-Id: <1253689387.5631.22.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Sogm41+felhOgKgWxwc6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-22 at 21:11 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> >=20
> > Don't worry, they are fine.
>=20
> Yes - i was able to save and apply the patch just fine too:
>=20
Ok, fine, thanks for the feedback.

> earth4:~/tip> q push
> Applying patch patches/sched_edf-scheduling-class.patch
> ...
> patching file kernel/sched_rt.c
> patching file kernel/trace/trace_sched_wakeup.c
>=20
> Now at patch patches/sched_edf-scheduling-class.patch
>=20
Cool :-)

> Daniel is a kind of self-elected joker-bot on lkml, running checkpatch=20
> out of .procmailrc and annoying people with trivial comments,=20
> distracting from the real discussion.=20
Ok. Anyway, it could happen --especially to me :P-- to mess something
up... So no problem with me if someone points this out if/when it
happens! :D

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-Sogm41+felhOgKgWxwc6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq5yCsACgkQk4XaBE3IOsRekACcDhRR08UwN0vVvi9FyjDeUg5t
kbgAnAp2A9EuN1hXDvQC/q/qutlc2K7j
=IqrX
-----END PGP SIGNATURE-----

--=-Sogm41+felhOgKgWxwc6--

