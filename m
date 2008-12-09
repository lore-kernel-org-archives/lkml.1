Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYLIRu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYLIRu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYLIRuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:50:18 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:50358 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbYLIRuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:50:17 -0500
X-Greylist: delayed 2268 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 12:50:17 EST
Subject: Re: [RFC PATCH] waitfd: file descriptor to wait on child processes
From: Scott James Remnant <scott@netsplit.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081209170543.59b4fb73@lxorguk.ukuu.org.uk>
References: <493EA441.1070706@redhat.com>
	 <20081209170543.59b4fb73@lxorguk.ukuu.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zoHKHOidtwX0JR2YI235"
Date: Tue, 09 Dec 2008 09:12:13 -0800
Message-Id: <1228842733.6602.3.camel@warcraft>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zoHKHOidtwX0JR2YI235
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 17:05 +0000, Alan Cox wrote:

> Here is a more elegant suggestion - use epoll, inotify and friends  fully
> on /proc process nodes.
>=20
Could you give an example?

What is supported?

Scott
--=20
Have you ever, ever felt like this?
Had strange things happen?  Are you going round the twist?

--=-zoHKHOidtwX0JR2YI235
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk+pu0ACgkQIexP3IStZ2x5vQCff2ZTaSmCPlBQEanw1yUgNFGZ
614AnjuY90roGcjLvszFJMYCtzC4IQ07
=YYQB
-----END PGP SIGNATURE-----

--=-zoHKHOidtwX0JR2YI235--

