Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbZD3IhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbZD3IhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbZD3Ig5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:36:57 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:47920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZD3Ig4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:36:56 -0400
Subject: Re: iwlwifi: remove EXPORT_SYMBOL for static symbol
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <m28wlih7sw.fsf@igel.home>
References: <m24ow6vah1.fsf@igel.home>
	 <1241078967.25477.8.camel@johannes.local>  <m28wlih7sw.fsf@igel.home>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/2AfDCD0oDCL+HnpjFPI"
Date: Thu, 30 Apr 2009 10:36:23 +0200
Message-Id: <1241080583.27290.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/2AfDCD0oDCL+HnpjFPI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-30 at 10:20 +0200, Andreas Schwab wrote:

> >> drivers/net/wireless/iwlwifi/iwl3945-base.c:1697: error:
> >> __ksymtab_iwl3945_rx_queue_reset causes a section type conflict

> > At least in my tree the function isn't static...(yet I still got the
> > compiler error)?
>=20
> The static function is iwl3945_rx_queue_free.

Oh. I have to admit to not looking that far, thanks.

johannes

--=-/2AfDCD0oDCL+HnpjFPI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+WMEAAoJEKVg1VMiehFYR8sP/A3IjvGGG4zfsYiO1IfYl2ge
meZxn4Ami5wm/DbPU9Rud1Lt7QanbAkqPstBg0ymB0pM+8lgO4XObTxSi6j8x8Mn
cOw/9McTZXha5bbWJOTgzXGDeyw/LJl1+bEtYvzLbwPVJe1nWs0aa8qasH+nthB1
gBkh2/qAQrsPTsCSovr4u3zzJMAdfaEZFy6kKUBuN2no8qW15mg72lapTRi14+di
myY7CekMdelANQ1E5M3JG3PM/wqa5QZTdJ+SjbEtE951jCDeN7jLmn5YSGEE4mPH
kVSs2BmXcxiTzwvwWywCpNjhXbrApM3Qs7YNdA1RPc6f0cJHMWQO2+Jsz2WSZ1GA
05HLW+KYm3nRe9EXip2ko9HDZCrRqMN1/9V1E9xbKnGTvvn1f4SKCdmEHe+UAiUt
W+sW+kHGqDiZ6L51iNt2mZo8XiWsAhdcWbIboGxyPq6k08PxVrszYU//RMOTG3SR
2gaVIEGh9qgATxN+5WkCbjUfijMa7Q6a6lo+EjfwgjPLPZNqu1+W7mkijpXFgho0
warGupBcJFcfoHLlmM/JTMuVpQ8CQn+FD69CSCH1MlMGhcUQ/AoTShAs78rZPLBx
YMWftKPoqBrUrsET3k2zsFAAQYM3U+qa+ol6VSJh+kGgZzXzygi2Ug8uV0X+i+wz
WgLiCsT3XWpZM8c8k+gQ
=0Zt/
-----END PGP SIGNATURE-----

--=-/2AfDCD0oDCL+HnpjFPI--

