Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZLKJJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZLKJJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZLKJJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:09:46 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:36769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbZLKJJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:09:45 -0500
Subject: Re: mmotm-2009-12-08-17-45 resume slowly
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: kosaki.motohiro@jp.fujitsu.com, hidave.darkstar@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <20091210.142932.78191007.davem@davemloft.net>
References: <a8e1da0912100127k4dcddd65gfe5ff0b1330fe63b@mail.gmail.com>
	 <a8e1da0912100130i2e654796mf899dd27df869673@mail.gmail.com>
	 <20091210184931.257A.A69D9226@jp.fujitsu.com>
	 <20091210.142932.78191007.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ae+dT+zlbIHcDsK9lfYD"
Date: Fri, 11 Dec 2009 10:09:40 +0100
Message-ID: <1260522580.2442.22.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ae+dT+zlbIHcDsK9lfYD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-12-10 at 14:29 -0800, David Miller wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Thu, 10 Dec 2009 18:52:51 +0900 (JST)
>=20
> > (cc to netdev)
> >=20
> > Hi net-folks
> >=20
> >> > [ =1B,A 561.323866] mtrr: type mismatch for e0000000,10000000 old:
> >> > write-back new: write-combining
> >> > [ 2688.500033] No probe response from AP 00:02:2d:08:51:2b after
> >> > 500ms, disconnecting.
> >> > [ 2689.580376] wlan0: direct probe to AP 00:02:2d:08:51:2b (try 1)
> >=20
> > What's mean "No probe response"? Why its point waste 2000sec?
>=20
> I think you'll get more responses from the wireless list,
> replacing netdev with linux-wireless in the CC:...

That is definitely done asynchronously, there's no reason it should
delay the resume.

johannes

--=-Ae+dT+zlbIHcDsK9lfYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLIgxRAAoJEODzc/N7+QmacXoP/RgIvwljnLmZK2XJLofB593H
AUg2du/rTXjsSkK2C2Ge/r2LV5BNPIhCWoq4p+KnGpJnVmAMgfhDs1sf9zJWgTil
knjc4V3Mnuk/Om+AQH6ia1AJhc4K0X9pRZ63cjCHx50qHkvQ2Zf0ZMUyZR/TNPed
QomBQLXj/lKo/DaPN1SUKwuxwN2utdgbOkixcnFKlu76JDePY4wSWVk9C8pL+EuT
O0f1rOw0j5xYQLkxSzTqZETJosK40erbIGHIRnFs2Q21mbd7X9XhVEBfAuPCH8Y9
CbH1DYeYjkZFcCAz2Wfz1HTVqol913pznFXCc9tnL1Vib89QVr/abo++qegAgGQp
+4amjjSfNIlkjgxMSFVtAw7fRTBbAhf2rEoiqXsW3fIohakX4aKgtSr40b3kQVjU
dSfnI/l7EKp1S0Tp1TIMu0aJeN4VsPVF/x3lvlA07F0ujFj9AMayB72GsMLWywy4
nGzrG/RFxQxUmLDgnQTA5dc6G+Pbk5S9R5nMn9oN/2e+dmzm99W50LDH5hB8DseY
4d2xksSk1bmNGofwvJGMoEp7onrG7SURK9Dg3jv0gpMhu5nZQHDTQWoiDM+eYk8m
RcV6OqjTlwN8XdvNxuzLhJ06c28dA1Y6f/yeZhCUO9+sZVMexTAjWL2YVuaDrkhc
uISysPuYoB6eOXvcwyaO
=Rr3d
-----END PGP SIGNATURE-----

--=-Ae+dT+zlbIHcDsK9lfYD--

