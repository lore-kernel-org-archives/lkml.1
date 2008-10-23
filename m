Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbYJWPk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbYJWPk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYJWPkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:40:17 -0400
Received: from home.keithp.com ([63.227.221.253]:35853 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYJWPkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:40:15 -0400
Subject: Re: io resources and cached mappings (was: [git pull] drm patches
	for 2.6.27-rc1)
From: Keith Packard <keithp@keithp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: keithp@keithp.com, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20081023080553.GB14714@elte.hu>
References: <20081022093615.GF12453@elte.hu>
	 <1224746087-13991-1-git-send-email-keithp@keithp.com>
	 <20081023080553.GB14714@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R3CLetumsXip3hkEuVhi"
Date: Thu, 23 Oct 2008 08:39:10 -0700
Message-Id: <1224776350.6738.14.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-R3CLetumsXip3hkEuVhi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 10:05 +0200, Ingo Molnar wrote:

> Any ballpark-figure numbers you can share with us?

For one quake-3 based game we use for performance regression checking,
64-bit kernels run about 18 times faster now. That's the difference
between using a zero-cost dynamic mapping and using ioremap_wc for each
page.

--=20
keith.packard@intel.com

--=-R3CLetumsXip3hkEuVhi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJAJqeQp8BWwlsTdMRAojIAKDGaETafs78wW6WgrR7CDUOUzLspACeIzF2
jYhYDxDrPYpZZx+1d6OtJKs=
=zEkl
-----END PGP SIGNATURE-----

--=-R3CLetumsXip3hkEuVhi--

