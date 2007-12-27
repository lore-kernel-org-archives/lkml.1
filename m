Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbXL0Do2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbXL0Do2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 22:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbXL0DoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 22:44:19 -0500
Received: from sitemail2.everyone.net ([216.200.145.36]:36254 "EHLO
	omta16.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751758AbXL0DoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 22:44:18 -0500
X-Eon-Dm: dm02
X-Eon-Sig: AQF97PZHcx93YMh4SQIAAAAB,f0b55b81ae1802026ff2440035469c9c
Message-ID: <47731F6F.9090000@smsglobal.net>
Date: Thu, 27 Dec 2007 11:43:43 +0800
From: "Rogelio M. Serrano Jr." <rogelio@smsglobal.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
References: <47684DBD.6030502@rtr.ca>
In-Reply-To: <47684DBD.6030502@rtr.ca>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig215D2D22937D82BB2F33AEC4"
To: undisclosed-recipients:;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig215D2D22937D82BB2F33AEC4
Content-Type: multipart/mixed;
 boundary="------------070609060805060707050000"

This is a multi-part message in MIME format.
--------------070609060805060707050000
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Mark Lord wrote:
> Why does link(2) not support hard-linking across bind mount points
> of the same underlying filesystem ?
do we need link(2) at all? bind mounts are supposed to be (hard/soft)
link minus the headaches.

--=20
Democracy is about two wolves and a sheep deciding what to eat for dinner=
=2E


--------------070609060805060707050000
Content-Type: text/x-vcard; charset=utf-8;
 name="rogelio.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rogelio.vcf"

YmVnaW46dmNhcmQNCmZuOlJvZ2VsaW8gTS4gU2VycmFubyBKcg0KbjpNLiBTZXJyYW5vIEpy
O1JvZ2VsaW8NCm9yZzpTTVNHIENvbW11bmljYXRpb25zIFBoaWxpcHBpbmVzO1RlY2huaWNh
bCBEZXBhcnRtZW50DQphZHI6Ozs7Ozs7UmVwdWJsaWMgb2YgdGhlIFBoaWxpcHBpbmVzDQpl
bWFpbDtpbnRlcm5ldDpyb2dlbGlvQHNtc2dsb2JhbC5uZXQNCnRpdGxlOlByb2dyYW1tZXIN
CnRlbDt3b3JrOis2MzI3NTM0MTQ1DQp0ZWw7aG9tZTorNjMyOTUyNzAyNg0KdGVsO2NlbGw6
KzYzOTIwOTIwMjI2Nw0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZlcnNpb246Mi4xDQplbmQ6
dmNhcmQNCg0K
--------------070609060805060707050000--

--------------enig215D2D22937D82BB2F33AEC4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHcx92yihxuQOYt8wRAu/oAJ4uCWeeyq8ugjQjp+6nfF3Rf8Pf5wCdHKY6
CbwIA/CvAHB1IJEXl4jDc3E=
=a/kX
-----END PGP SIGNATURE-----

--------------enig215D2D22937D82BB2F33AEC4--
