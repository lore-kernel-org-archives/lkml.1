Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbYHKPf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbYHKPf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYHKPfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:35:18 -0400
Received: from ms01.sssup.it ([193.205.80.99]:33638 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751348AbYHKPfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:35:17 -0400
Subject: Re: [RFC 1/1][PATCH] POSIX SCHED_SPORADIC implementation for tasks
	and groups
From: Dario Faggioli <raistlin@linux.it>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@osdl.org>,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <20080811080545.d8f42601.randy.dunlap@oracle.com>
References: <1218465906.6450.42.camel@Palanthas>
	 <20080811080545.d8f42601.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YQYVs/LKnaI1GfyAz/lh"
Date: Mon, 11 Aug 2008 17:35:07 +0200
Message-Id: <1218468907.6450.46.camel@Palanthas>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YQYVs/LKnaI1GfyAz/lh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-11 at 08:05 -0700, Randy Dunlap wrote:
> > +	  to schedule aperiodic or sporadic tasks in periodic-based fixed
> > +	  priorit real-time systems.
>=20
> 	  priority

> > +	help
> > +	  Let you chose the maximum number of recharges that can be
>=20
> 	  Lets you choose

Thank you very much, I'll aplly your fixes right now! :-)

> > +	  Anyway, since this is going to cause some memory overhead, it is
> > +	  wise to not set this to a too much high value.
>=20
> 	  wise not to set this to a very high value.	// or some other rewording

Yep, I agree... I will rephrase it to something better.

Thank you very much for your review! :-D
Dario

--=20
<<This happens because I choose it to happen!>>
(Raistlin Majere, DragonLance Chronicles -Dragons of Spring Drawning-)
----------------------------------------------------------------------
Dario Faggioli
GNU/Linux Registered User: #340657
Web: http://www.linux.it/~raistlin
Blog: http://blog.linux.it/raistlin
SIP Account: dario.faggioli@sipproxy.wengo.fr or
             raistlin@ekiga.net
Jabber Account: dario.faggioli@jabber.org/WengoPhone
GnuPG Key ID: 4DC83AC4
GnuPG Key Fingerprint: 2A78 AD5D B9CF A082 0836 08AD 9385 DA04 4DC8 3AC4

--=-YQYVs/LKnaI1GfyAz/lh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIoFwrk4XaBE3IOsQRAgZ+AKCvaDC0y8KIWJAsTgjK/GxO0MyOXwCgnctd
KL8KKrNp3VhO32cOz9l5dic=
=Sisg
-----END PGP SIGNATURE-----

--=-YQYVs/LKnaI1GfyAz/lh--

