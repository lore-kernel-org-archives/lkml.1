Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbZFDLit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbZFDLit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZFDLil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:38:41 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:48530 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbZFDLik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:38:40 -0400
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
From: Scott James Remnant <scott@ubuntu.com>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yI6fsDdjAT+pW8KozPg3"
Date: Thu, 04 Jun 2009 12:38:50 +0100
Message-Id: <1244115530.4120.30.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yI6fsDdjAT+pW8KozPg3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-18 at 18:08 +0200, Jan Blunck wrote:

> Here is another post of the VFS based union mount implementation.
>=20
Awesome work, this may just get us out of a tight spot with our LiveCD.
A switch to a devmapper/snapshot based implementation lost the property
that we could rsync the filesystem (squashfs has been nicely rsyncable).

What kind of testing do you need doing, and where would you like the bug
reports/patches? :-)

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-yI6fsDdjAT+pW8KozPg3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkonskkACgkQSnQiFMl4yK4k2gCfW9M/ROu3iGkIVWQ/+loFw36+
2W4AnRSFgC0XyudiD1O7GPlM1TBNyT6T
=Kl+k
-----END PGP SIGNATURE-----

--=-yI6fsDdjAT+pW8KozPg3--

