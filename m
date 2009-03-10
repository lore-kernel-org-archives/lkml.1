Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbZCJRBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbZCJRBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbZCJRBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:01:05 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:52870 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbZCJRBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:01:04 -0400
Subject: Re: [PATCH 22/31] i2c: Auto-load i2c_dev module when device opened.
From: Scott James Remnant <scott@canonical.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
In-Reply-To: <20090310175612.7e5b8272@hyperion.delvare>
References: <cover.1236702228.git.scott@canonical.com>
	 <c9e8ec654db2ee34fc9fda29222aee9dd085ddaa.1236702228.git.scott@canonical.com>
	 <20090310175612.7e5b8272@hyperion.delvare>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WOI/W2uT6UJCbBUtKzJw"
Date: Tue, 10 Mar 2009 17:00:57 +0000
Message-Id: <1236704457.6339.0.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WOI/W2uT6UJCbBUtKzJw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-10 at 17:56 +0100, Jean Delvare wrote:

> Your clock is off by a significant number of days, isn't it?
>=20
No, I've just been carefully testing them - and then waited until they
were in the jaunty kernel and a couple of thousand other users
not-so-carefully tested them too <g>

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-WOI/W2uT6UJCbBUtKzJw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm2nMkACgkQSnQiFMl4yK4aVwCfboU8Dr+Bs8RLXQI69kx0fZFH
yBgAn05Cep5h0enafdYzD6NkNhp1aYtf
=zVE8
-----END PGP SIGNATURE-----

--=-WOI/W2uT6UJCbBUtKzJw--

