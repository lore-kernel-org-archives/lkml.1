Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYAJXVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYAJXVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYAJXV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:21:29 -0500
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:35288 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbYAJXV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:21:28 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 18:21:28 EST
Subject: Re: [PATCH 3/7] Move rcutorture to tests/
From: Josh Triplett <josh@freedesktop.org>
To: ananth@in.ibm.com
Cc: lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       mingo@elte.hu, ak@suse.de, sam@ravnborg.org, paulmck@linux.vnet.ibm.com,
       Dipankar Sarma <dipankar@in.ibm.com>, josh@kernel.org, ego@in.ibm.com
In-Reply-To: <20080110115751.GD26577@in.ibm.com> (sfid-20080110_143114_486374_4D0F610B)
References: <20080110115428.GA26577@in.ibm.com>
	 <20080110115751.GD26577@in.ibm.com> (sfid-20080110_143114_486374_4D0F610B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wCKM3ncmkA0jUD4h2rjx"
Date: Thu, 10 Jan 2008 15:14:48 -0800
Message-Id: <1200006888.4704.11.camel@josh-mobile>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wCKM3ncmkA0jUD4h2rjx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-01-10 at 17:27 +0530, Ananth N Mavinakayanahalli wrote:
> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>=20
> Move the rcutorture infrastructure to tests/
>=20
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Fine by me.
Acked-by: Josh Triplett <josh@freedesktop.org>

- Josh Triplett


--=-wCKM3ncmkA0jUD4h2rjx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHhqboGJuZRtD+evsRAsgcAJ9/knXNwKHNABaRoWKnfTMwYAxg1wCfQtb2
pOiqF0yFqxVeZ0FJEllbfzw=
=wosm
-----END PGP SIGNATURE-----

--=-wCKM3ncmkA0jUD4h2rjx--

