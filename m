Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZI2Xcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZI2Xcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZI2Xcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:32:51 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZI2Xcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:32:50 -0400
Subject: Re: 2.6.32-rc2: wlan rt73 dead
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <20090929200413.GA5950@fancy-poultry.org>
References: <20090929170615.GA5539@fancy-poultry.org>
	 <20090929191125.GA5640@fancy-poultry.org>
	 <20090929191948.GE2678@tuxdriver.com>
	 <20090929200413.GA5950@fancy-poultry.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4bnWoFeiWKhCgey+Tp0A"
Date: Wed, 30 Sep 2009 01:32:20 +0200
Message-Id: <1254267140.3959.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4bnWoFeiWKhCgey+Tp0A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-29 at 22:04 +0200, Heinz Diehl wrote:
> On 29.09.2009, John W. Linville wrote:=20
>=20
> > Could you do a git bisect?
>=20
> I have never used git in my whole life, but I'll read the documentation
> and try.

While it's a good skill, don't waste your time. You're running opensuse,
I suppose, and having the same problem as Hugh:
http://bugzilla.kernel.org/show_bug.cgi?id=3D14263

Rafael: I'm pretty sure this (14272) is a dupe of 14263.

Heinz: please try a net-2.6 tree, or wait a couple of days until it's
pulled in.

johannes

--=-4bnWoFeiWKhCgey+Tp0A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKwpkAAAoJEODzc/N7+QmaEzEP/0qxjjXBqCSj27oJ06tUg0Y+
CDbCjcoDwpGhWmhR9EwnqnueRQHTsGKHwXbjJDonWEqdZx0D99asvQcJQvTMp9gU
UMLf0oj3MTS1aQ81Ly++5YLftQwhFflaGWvSw/dpMRiCfZHGY12vmX0zvWgzuTIg
4aXMpsL2XCp68opBR2dTgkoVOiYJKWi54C8wuTPK6fmPGkYU7k3nO656aP+cCFqy
f5W3DQ09StnNYg7DWEcvuj7+IGaRTnzNbrtyta9etiIiEUWdlKvvdE9XEpPoV8c1
cYslKNwAE3SeiOgrbNV2Ti6HcABkwFAQrOkbdvs2Ado5f25KPEf7vovr0+KBzEQn
naGAo7TwEPadrJBk9hBBVote0/1SYD1LyWyMnu4bopi34pJOhKy9Zk+yLCVwn3XJ
i6B9OaxfPnCNIamqhZYgvSRFsEmqSS9RfFLgHd8k3xnw0bnMyqsurnVlIiYfYjOK
juJZgOdxRgKRQ0QW49qv/XQIfqAw3P5qy3we2KjVSgjqwtV8rN3a5t7XrhLMFr+p
yqqqHGGba8KNHssKrfT02pts6Zxl1yOyaSUEcBK1ZHb9kndHcyx+MtHMQE1oRHge
IUDFInJ95/ioAaErb1C5pba7usOB90EvV43CesJTLd/tQ+eHilB2CgfN0V3IGRDP
lVSzqB+/fQ3ACSPLzbnp
=3tTW
-----END PGP SIGNATURE-----

--=-4bnWoFeiWKhCgey+Tp0A--

