Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbZHJJBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbZHJJBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZHJJBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:01:47 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:58772 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbZHJJBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:01:46 -0400
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
From: Scott James Remnant <scott@ubuntu.com>
To: Al Boldi <a1426z@gawab.com>
Cc: Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>
In-Reply-To: <200908062318.05478.a1426z@gawab.com>
References: <20090805171513.GA10443@kroah.com>
	 <200908062006.16263.a1426z@gawab.com> <20090806183653.GC28433@kroah.com>
	 <200908062318.05478.a1426z@gawab.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-F/DZjZP0eIwkoKCvr9TX"
Date: Mon, 10 Aug 2009 10:01:36 +0100
Message-Id: <1249894896.4431.6.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F/DZjZP0eIwkoKCvr9TX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-06 at 23:18 +0300, Al Boldi wrote:

> Maybe they are using the same trick as Ubuntu and Debian, as they run ude=
v in=20
> the background to hide the slowness.  Both Fedora and Mandriva run udev i=
n=20
> the foreground where the slowness is visible.
>=20
Ubuntu does not run udev in the background.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-F/DZjZP0eIwkoKCvr9TX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp/4fAACgkQSnQiFMl4yK79KACdE6MAjER1advzr/yMEisXGeE3
fC8AoLAQZeKnHl0siN6v9nhe7nXkLevx
=Q2gd
-----END PGP SIGNATURE-----

--=-F/DZjZP0eIwkoKCvr9TX--

