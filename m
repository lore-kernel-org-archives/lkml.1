Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbZJTGYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbZJTGYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbZJTGYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:24:14 -0400
Received: from k66.ru ([87.224.128.21]:64428 "EHLO k66.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbZJTGYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:24:14 -0400
Date: Tue, 20 Oct 2009 12:21:11 +0600
From: Andrey Rahmatullin <wrar@altlinux.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: drivers/staging/rt2860 doesn't compile
Message-ID: <20091020062111.GF19095@wrars-comp.wrarsdomain>
References: <20091014063824.GD6298@wrars-comp.wrarsdomain>
 <20091014182729.GC19095@wrars-comp.wrarsdomain>
 <20091016085738.GG19095@wrars-comp.wrarsdomain>
 <ada1vl3xixh.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oFMCfUPuRwe/HdF5"
Content-Disposition: inline
In-Reply-To: <ada1vl3xixh.fsf@cisco.com>
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.20 (2009-06-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oFMCfUPuRwe/HdF5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2009 at 12:00:58PM -0700, Roland Dreier wrote:
>  > For the archives: it just means that CONFIG_WIRELESS_EXT should be ena=
bled.
> Which means the driver should probably do "select WIRELESS_EXT" in
> Kconfig.
Yes.

> Would be an easy patch to send if you can test it....
Of course I can :)

--=20
WBR, wRAR (ALT Linux Team)

--oFMCfUPuRwe/HdF5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJK3VbXAAoJEOih81koZvPBU5QH/jZ6NFEOUzyMU6xJjZZWAe4v
yfuEC1zLqU8gVYM8os58pcy55wD+mv/f/4ZP00RK7VqNOp1XUzLJWCu8RiSf7ZCp
zAZQfJ1bjt3yeNiLW03lUfxPs4Tucfqp7NFKPpJs7RB26x5UVAxdDZ15rdh8t43p
rU69uarIDyfzoQK5uIfkD2WB+f01mGEGwUlU8lprpkQ4kvtnzywoFj/1qOU1DVks
gC/geMlEFYTxpVi+5Us+crsadfht8EHEIylMnGaQ4NmpYvNB9fdv+IqS+y6TrQyX
G+WXUeLEdpgc3QK6whvwBTrVlN+gqg9bHYLnSEuJijg5DkMrrg1aa1K1UUviSSk=
=fmKS
-----END PGP SIGNATURE-----

--oFMCfUPuRwe/HdF5--
