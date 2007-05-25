Return-Path: <linux-kernel-owner+w=401wt.eu-S1763277AbXEYTW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763277AbXEYTW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXEYTWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:22:19 -0400
Received: from daemonizer.de ([87.230.16.230]:58470 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbXEYTWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:22:18 -0400
X-Greylist: delayed 1994 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 15:22:18 EDT
From: Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Newsgroups: gmane.linux.kernel.wireless.general,gmane.linux.kernel
References: <20070524195616.234280@gmx.net>
	<200705251559.49807.uwe.bugla@gmx.de> <200705251652.19911.mb@bu3sch.de>
	<200705251759.30065.uwe.bugla@gmx.de>
X-Draft-Attribution: On Fri, 25 May 2007 17:59:29 +0200, Uwe Bugla wrote:
X-Draft-Attribution-Author: Uwe Bugla
	<uwe.bugla-Mmb7MZpHnFY@public.gmane.org>
X-Draft-Attribution-Date: Fri, 25 May 2007 17:59:29 +0200
X-Draft-Attribution-Id: 200705251759.30065.uwe.bugla@gmx.de
MIME-Version: 1.0
X-Length: 1836
To: linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>, mb@bu3sch.de,
       uwe.bugla@gmx.de
Date: Fri, 25 May 2007 20:48:02 +0200
Content-Type: multipart/signed;
  boundary="nextPart2011387.J2bNc92kcN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705252048.11931.maxi@daemonizer.de>
X-Spam-Score: -4.1 (----)
X-Spam-Report: No, hits=-4.1 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.1.7-deb 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.3 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2011387.J2bNc92kcN
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Fri, 25 May 2007 17:59:29 +0200, Uwe Bugla wrote:

>=20
> Perhaps someone reading this could try to reproduce that problem on his
> machine.
> Now who of the readers owes a Broadcom 4401 NIC and can please try to
> test kernel 2.6.22-rc2-mm1?
>=20
> Those NICs have been used very very often as onboard controllers,
> especially on ASUS boards.

I've been using 2.6.22-rc2 for some time and now I compiled 2.6.22-rc2-
mm1 and both work fine with the BCM4401 in my laptop.

Maxi

--nextPart2011387.J2bNc92kcN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGVy9rOimwv528XGERAs01AJ40Pz8pwHToiviKOXvHfMsfgTUQDgCgmogc
INSe0NTxtiGuqL3ew1Ic7Lg=
=72ya
-----END PGP SIGNATURE-----

--nextPart2011387.J2bNc92kcN--
