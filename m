Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbXE3WW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbXE3WW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbXE3WWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:22:20 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:42962 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901AbXE3WWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:22:20 -0400
Subject: Re: Sending signals to a kernel thread, broken in 2.6.22
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0705301050080.2564-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0705301050080.2564-100000@iolanthe.rowland.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lLsql0o3x1SQWeERtWtV"
Date: Thu, 31 May 2007 08:22:18 +1000
Message-Id: <1180563738.6777.8.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lLsql0o3x1SQWeERtWtV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-05-30 at 10:51 -0400, Alan Stern wrote:
> On Wed, 30 May 2007, Nigel Cunningham wrote:
>=20
> > Hmm. Given Oleg's reply, it could pay to check that freezable kernel
> > threads are still being frozen.
>=20
> I don't think we have to worry about this.  See this discussion thread:
>=20
> 	http://marc.info/?t=3D118045713200006&r=3D1&w=3D2
>=20
> and in particular this message:
>=20
> 	http://marc.info/?l=3Dlinux-kernel&m=3D118046964817995&w=3D2

Ok, cool. Thanks both of you for the quick reply.

Nigel

--=-lLsql0o3x1SQWeERtWtV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXfkaN0y+n1M3mo0RAk1LAJ4mUmei2NNpcaU4jQ9OqZ5f/8nuNwCgksu0
k4UVv5DpcA7MLVNfpe5wpEc=
=EJ2y
-----END PGP SIGNATURE-----

--=-lLsql0o3x1SQWeERtWtV--

