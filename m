Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZFWIRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZFWIRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZFWIRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:17:36 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:36208 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZFWIRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:17:34 -0400
Subject: Re: can we move USB_DEVICEFS to non-embedded?
From: Scott James Remnant <scott@ubuntu.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <b6a2187b0906222211i4509bc4cu39e9123cba61039a@mail.gmail.com>
References: <b6a2187b0906222211i4509bc4cu39e9123cba61039a@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tpyPIGHS+whPbagdtOZv"
Date: Tue, 23 Jun 2009 09:17:28 +0100
Message-Id: <1245745048.3477.14.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tpyPIGHS+whPbagdtOZv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-23 at 13:11 +0800, Jeff Chua wrote:

> commit cc71329b3b89b4a5be849b617f2c4f151f0b9213 moved USB_DEVICEFS to
> be embedded and marked it as depreciated. Can this be reverted? This
> breaks vmware and those systems not using udev.
>=20
vmware should have been updated to use /dev/bus/usb a long time ago.

I believe that the old devices file is available under debugfs now, if
you need it.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-tpyPIGHS+whPbagdtOZv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpAj5UACgkQSnQiFMl4yK6nJwCfc+1wUY/BlYmKpxkP3WUjYKjU
TSEAoKcO2+W7qyogKUxGeR7pEY8DXlAh
=B0NQ
-----END PGP SIGNATURE-----

--=-tpyPIGHS+whPbagdtOZv--

