Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbYKYSw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbYKYSw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 13:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYKYSwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 13:52:40 -0500
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:42286 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbYKYSwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 13:52:40 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Nov 2008 13:52:39 EST
Subject: Re: ALPS input driver problem with DualPoint on Dell E6400/E6500
From: Alexander Hofbauer <alex@derhofbauer.at>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bUfIO/qYrs4zUXCzyPJL"
Date: Tue, 25 Nov 2008 19:45:42 +0100
Message-Id: <1227638742.5353.5.camel@mobian>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-Df-Sender: 420630
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bUfIO/qYrs4zUXCzyPJL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi!

> I can put together a patch, but it's a non-trivial change... I'm
> interested in hearing whether anyone else has the same problem with
> their E6400/E6500 or other DualPoint laptop, or has better ideas
> regarding how to deal with this.

I'm facing the same problem here on my "Latitude E5500" and 2.6.27.7
with no found workarounds so far ("synclient TouchpadOff=3D0" works until
reset but doesn't avoid the touchpad getting reset eventually).


If there was a patch to test I'd be happy to do so :-).


Thank you,
Alex

--=-bUfIO/qYrs4zUXCzyPJL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkksR84ACgkQER+ES1ZqwmWp5QCeOdHfwauueZchHEtU9eitQJNX
gDgAn3TI66F9Vov0aSBXWgCbHVFp5TmJ
=bcso
-----END PGP SIGNATURE-----

--=-bUfIO/qYrs4zUXCzyPJL--

