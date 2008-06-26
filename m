Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYFZFgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYFZFgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 01:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYFZFgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 01:36:38 -0400
Received: from home.keithp.com ([63.227.221.253]:2512 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbYFZFgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 01:36:37 -0400
Subject: Re: kmap_atomic_pfn for PCI BAR access?
From: Keith Packard <keithp@keithp.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: keithp@keithp.com, Dave Airlie <airlied@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080625213603.0e82805b@infradead.org>
References: <1214242487.11887.35.camel@koto.keithp.com>
	 <4862EE4C.4060009@goop.org>
	 <21d7e9970806251823q3405e192q13d4944bd0cc3291@mail.gmail.com>
	 <20080625213603.0e82805b@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-80sdhAsDrVkVDeFPpM8O"
Date: Wed, 25 Jun 2008 22:36:29 -0700
Message-Id: <1214458589.1044.45.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-80sdhAsDrVkVDeFPpM8O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-25 at 21:36 -0700, Arjan van de Ven wrote:

> well kmap does a tlb flush as well...=20

kmap_atomic

--=20
keith.packard@intel.com

--=-80sdhAsDrVkVDeFPpM8O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIYyrdQp8BWwlsTdMRAjOVAJ9UamtaNzKZ5pvlsn2v/FxG7RIivACgkLO6
yrl4qUhECN/9OuivM9PT1jI=
=JcHd
-----END PGP SIGNATURE-----

--=-80sdhAsDrVkVDeFPpM8O--

