Return-Path: <linux-kernel-owner+w=401wt.eu-S934017AbXKPVLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017AbXKPVLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbXKPVLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:11:45 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:54430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbXKPVLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:11:44 -0500
Subject: Re: [PATCH 1/2] mac80211: add power management support
From: Johannes Berg <johannes@sipsolutions.net>
To: Miguel =?ISO-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, linville@tuxdriver.com,
       yi.zhu@intel.com
In-Reply-To: <200711162002.01972.mboton.lkml@gmail.com> (sfid-20071116_190212_726540_E9A85A6C)
References: <200711161929.36283.mboton.lkml@gmail.com>
	 <200711161953.26801.mboton.lkml@gmail.com>
	 <200711162002.01972.mboton.lkml@gmail.com>
	 (sfid-20071116_190212_726540_E9A85A6C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BS27lmm0qgQr/81lsx8g"
Date: Fri, 16 Nov 2007 22:13:01 +0100
Message-Id: <1195247581.26571.5.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BS27lmm0qgQr/81lsx8g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> +	if (ieee80211_hw_config(local))
> +		return -EINVAL;

-EINVAL seems not right. Doesn't that already return an error code?

johannes

--=-BS27lmm0qgQr/81lsx8g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARz4H3KVg1VMiehFYAQLRCA/+IipQQpYM7dTjwnmJY0Ahcw0s7Z1vrf17
LgQpndp7NBF8txCOXZ77cqAQ7/g/5/HxUZEGFE9DgN5a4ok3d9ZtIGsnAJYvrzBM
cONV7vEcxOZXQiLvUQUMdclL6S2dGeWf2yxDQ0G7enr5TJsZ1Mu+aAzjmre5YNkb
2f6SjHjQbxnEyhSpEeGHl7nRHWyeeZO83o1FeQI64o4pPJ5K1KweJZqujzntoTwW
QS4pgW0y5VEA06p6W5gpYU2Pr5A9+ReHJXLK4ha42Vd2R2PmjSyawKOSPQVCZzAn
ai69y5zu1oXPqoK1dCCS6UovsX++exxCBMt06VWwCtVgM0Gl2a1m/0RQjOp0aEZC
CTNmMPT0rJR2puL7FmjS6S8kGkCfwWBHeUDF/YMVynX4YMtMPjHmQix7V8Vqmy38
ITFOi7wM8lPOcLsZpCnkIKN45FU8a5OMnz9tzONzobBhHHbvYceFJu5jdUvJbxOR
LD4je1L9fdhI5IsNhm70auy83STaj5jCqWuvo+B1pBEE8pO1d95Lc73hxDHtlkbl
uuZ/fU0OeDHsMYRXwTx9DloJFwah/xCFJ17IcPWmbYhybSjP8tfmDLrgUi/QY+/M
CT6y9wsYjhHHJEWIepZqIZ9V159lqL8p8AjbT4Gg7KF0JL/JHXuV34F0pBne8fhq
xiLzljMgTfk=
=2S64
-----END PGP SIGNATURE-----

--=-BS27lmm0qgQr/81lsx8g--

