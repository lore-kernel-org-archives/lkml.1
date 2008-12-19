Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYLSWwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYLSWwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYLSWwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:52:14 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:61353 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYLSWwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:52:14 -0500
Subject: Re: [PATCH 0/6] drm/i915: fix sparse warnings
From: Eric Anholt <eric@anholt.net>
To: Hannes Eder <hannes@hanneseder.net>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <494ad5ce.06e2660a.73b0.ffffd586@mx.google.com>
References: <494ad5ce.06e2660a.73b0.ffffd586@mx.google.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Yz4GIFRXm9oif3k2hX26"
Date: Fri, 19 Dec 2008 14:52:11 -0800
Message-Id: <1229727131.6544.7.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Yz4GIFRXm9oif3k2hX26
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-18 at 23:27 +0100, Hannes Eder wrote:
> This series of patches fixes a couple of sparse warnings in drm/i915.
>=20
> Hannes Eder (6):
>   drm/i915: fix sparse warnings: declare one-bit bitfield as unsigned
>   drm/i915: fix sparse warnings: make symbols static
>   drm/i915: fix sparse warnings: move 'extern' decls to header file
>   drm/i915: fix sparse warnings: returning void-valued expression
>   drm/i915: comment out unused function 'i915_driver_firstopen'
>   drm/i915: add prototype for 'intelfb_panic' to header file

Committed this patch series, except for replacing #5 with just deleting
the function, and using the updated #6 patch.  Thanks!

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-Yz4GIFRXm9oif3k2hX26
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklMJZsACgkQHUdvYGzw6vd+XgCcD2Gpf/NEWNM3KZL7B4ZNwkY2
pLEAoIBK+5UtVrmgmQ0M9XOxOh2UA6CH
=MNBF
-----END PGP SIGNATURE-----

--=-Yz4GIFRXm9oif3k2hX26--

