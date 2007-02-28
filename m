Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbXB1Uh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbXB1Uh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932222AbXB1Uh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:37:26 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:36540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbXB1UhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:37:25 -0500
Subject: Re: Problem with freezable workqueues
From: Johannes Berg <johannes@sipsolutions.net>
To: nigel@nigel.suspend2.net
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <1172625254.8580.37.camel@nigel.suspend2.net>
References: <200702272251.28844.rjw@sisk.pl>
	 <200702280057.36198.rjw@sisk.pl> <1172620896.3681.19.camel@johannes.berg>
	 <200702280108.57988.rjw@sisk.pl>
	 <1172625254.8580.37.camel@nigel.suspend2.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-69tb9FVsiuqKqOB2vtqj"
Date: Wed, 28 Feb 2007 21:36:47 +0100
Message-Id: <1172695007.5015.97.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-69tb9FVsiuqKqOB2vtqj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 12:14 +1100, Nigel Cunningham wrote:

> Controversy is no reason to give in! Nevertheless, I think you're right
> - I believe the XFS guys said they fixed the issue that had caused I/O
> to be submitted post-freeze. Well, we'll see if it appears again, won't
> we?

I get to be the guinea pig, right? :P Unfortunately I was sick for the
better part of the past few days and can only test all this stuff early
next week.

johannes

--=-69tb9FVsiuqKqOB2vtqj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5eff/ETPhpq3jKURAjIPAJ9HqN1EGU1KslQ1T2OF1HXPDUxqwgCfQu1v
27AQ9mv3m6zxAimclOLoD+Y=
=cWm1
-----END PGP SIGNATURE-----

--=-69tb9FVsiuqKqOB2vtqj--

