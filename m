Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZGNSUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZGNSUC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZGNSUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:20:01 -0400
Received: from ms01.sssup.it ([193.205.80.99]:34794 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752537AbZGNSUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:20:00 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Friesen <cfriesen@nortel.com>, Douglas Niehaus <niehaus@ittc.ku.edu>,
       Henrik Austad <henrik@austad.us>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1247569415.7500.95.camel@twins>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	 <4A5B61DF.8090101@nortel.com>  <1247568455.9086.115.camel@Palantir>
	 <1247569415.7500.95.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3X2Clk+TyzyyA86ngRt/"
Date: Tue, 14 Jul 2009 20:19:52 +0200
Message-Id: <1247595592.4839.41.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3X2Clk+TyzyyA86ngRt/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-14 at 13:03 +0200, Peter Zijlstra wrote:=20
> On Tue, 2009-07-14 at 12:47 +0200, Raistlin wrote:
> > [1] http://feanor.sssup.it/%7Elipari/papers/rtss2001-bwi.ps.gz
>=20
> That link seems to require a user/pass combination.
>=20
Oh, damn, sorry about that!

I thought I downloaded the paper once from Peppe's website, but I
suppose I'm wrong. Now I see there's also a disclaimer about that IEEE
copyright stuff there, but I did not notice it! :-(

Anyway, here are two working links to all the BWI details for UPs:
 http://feanor.sssup.it/~faggioli/lipari_lamastra_abeni_bwi.pdf
 http://feanor.sssup.it/~faggioli/rtss2001-bwi.ps.gz

Sorry again and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-3X2Clk+TyzyyA86ngRt/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpczEgACgkQk4XaBE3IOsRJHQCgqAnu1nuPoDaOdYLm/GxPDjyr
/EcAn1hVnRUKoTRXe4i740V3302Y+gD9
=t82s
-----END PGP SIGNATURE-----

--=-3X2Clk+TyzyyA86ngRt/--

