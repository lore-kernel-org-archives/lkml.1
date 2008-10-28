Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYJ1XOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYJ1XOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYJ1XNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:13:52 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40733 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYJ1XNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:13:50 -0400
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: Zhu Yi <yi.zhu@intel.com>, Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W.Linville" <linville@tuxdriver.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>
In-Reply-To: <20081028235841.78942d67@mtlp.12.dimension> (sfid-20081028_235928_003125_A4476F93)
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	 <1225157618.2917.215.camel@debian.sh.intel.com>
	 <20081027213217.53558319@infradead.org>
	 <1225171414.2917.229.camel@debian.sh.intel.com>
	 <20081028172418.3c8e91f1@mtlp.12.dimension>
	 <1225218994.3598.41.camel@johannes.berg>
	 <20081028235841.78942d67@mtlp.12.dimension>
	 (sfid-20081028_235928_003125_A4476F93)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6pu5HRzt4sa1KOMec8up"
Date: Wed, 29 Oct 2008 00:06:17 +0100
Message-Id: <1225235177.1369.5.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6pu5HRzt4sa1KOMec8up
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-28 at 23:58 +0100, Mirco Tischler wrote:
> On Tue, 28 Oct 2008 19:36:34 +0100, Johannes Berg wrote:
> > Can we have a dmesg output with the "TX power requested" line posted
> > here?

> You mean the hole output? Cause I posted the wireless part in my initial =
mail.

Sorry, I got confused, the initial mail is fine.

johannes

--=-6pu5HRzt4sa1KOMec8up
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJB5rmAAoJEKVg1VMiehFYLRwP/0vpdoOSco4sADMGjczQVLk1
hosskmojSTVOhxHJktp3pxLW+RVP4cyqOp+/+m/Zu6MyIaOLeYUPoVau1inrmrWs
jEuzbud6KIQPvBIUUcSBGhoEqF+0S966CNDFbqsMeGunaBnIKlKb0QBgKS+vufS4
8mgHVzzNqRDVlDEXL8gnRfldh+kUwxt4wzLFsBlILtLUJd8yiaB/AIDxul/ecSIq
GYk46y0xZtyyhKwOEu9TXnHs7PYNtdhs6jTt+R4MyXXhJMsjsvOe15C1rGiPCxl5
IelHJWtlfP6wYttk/qYNoRQ44Ot+tOsP0M4M3oHmAWM9gaat//c8dxUxoXgac6x5
Mxzj1g/xy65miZjwaHI9kwWL3cwEj1TSIigHVG6PSkQEYuwAmHkWFv8qmrt242ps
nMGYSojzNrmPTYzxGvVSGoOCqgvjgKWPtgmIECDXKV1CLjjPGqA20MSOtM+v9Vti
gpZ6Qh4vccvjIfpAvfkgMwU8gksY1B80s3iajuEEIWcQ6JWzOtn4ywt+mUGVQ+6g
sdNHidYux2GG4fNmjCNjq70nunV8qeSCKz3TWfJ1gQJG4FXSCd1Yj9Jp2+kPjJbi
/+daadcz6HCr56VcYPwcq9N9LNQwBVLYPSfS4tqtUPoVxJf/yCsq28sXtrzKKDD1
lLXqgUycfqqxco/LOBPD
=3ub8
-----END PGP SIGNATURE-----

--=-6pu5HRzt4sa1KOMec8up--

