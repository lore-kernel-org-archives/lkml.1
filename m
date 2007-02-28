Return-Path: <linux-kernel-owner+w=401wt.eu-S1750740AbXB1ACA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750740AbXB1ACA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 19:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbXB1ACA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 19:02:00 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:33428 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXB1AB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 19:01:59 -0500
Subject: Re: Problem with freezable workqueues
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Nigel Cunningham <nigel@suspend2.net>
In-Reply-To: <200702280057.36198.rjw@sisk.pl>
References: <200702272251.28844.rjw@sisk.pl>
	 <20070227232855.GA457@tv-sign.ru>  <200702280057.36198.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-a3P5qI7ARd5LZMpGQ8sO"
Date: Wed, 28 Feb 2007 01:01:35 +0100
Message-Id: <1172620896.3681.19.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a3P5qI7ARd5LZMpGQ8sO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 00:57 +0100, Rafael J. Wysocki wrote:

> Okay, in that case I'd suggest removing create_freezeable_workqueue() and
> make all workqueues nonfreezable once again for 2.6.21 (as far as I know,=
 only
> the two XFS workqueues are affected).

I think Nigel might object but I forgot what specific trouble XFS was
causing him.

johannes

--=-a3P5qI7ARd5LZMpGQ8sO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5MZf/ETPhpq3jKURAoeDAKCIBl9wQ2Re4T8hh8PdF89FrSTyQQCfaYca
1YXVY6Qs5jhSMpgx1ITO5dI=
=qQbe
-----END PGP SIGNATURE-----

--=-a3P5qI7ARd5LZMpGQ8sO--

