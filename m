Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbZG3J5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbZG3J5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbZG3J5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:57:09 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:36561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZG3J5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:57:08 -0400
Subject: Re: [wireless] rt2870sta BUGs on shutdown,
 2.6.30.2->git.today+git.wireless.today
From: Johannes Berg <johannes@sipsolutions.net>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1248947099.8396.6.camel@marge.simson.net>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <1248946195.8925.9.camel@johannes.local>
	 <1248947099.8396.6.camel@marge.simson.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-R1PjQfvNwWiXGaIZHnnV"
Date: Thu, 30 Jul 2009 11:55:40 +0200
Message-Id: <1248947740.8925.12.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.4 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-R1PjQfvNwWiXGaIZHnnV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 11:44 +0200, Mike Galbraith wrote:
> On Thu, 2009-07-30 at 11:29 +0200, Johannes Berg wrote:
> > On Thu, 2009-07-30 at 11:22 +0200, Mike Galbraith wrote:
> >=20
> > > drivers/staging/rt2870/../rt2860/sta_ioctl.c
> >=20
> > Sorry, but that '/staging/' thing in there means we cannot support this=
.
> > If you must, take your query to the staging list,
> > devel@driverdev.osuosl.org (according to MAINTAINERS).
>=20
> Forwarded, thanks.
>=20
> ....hm.  Does "If you must" mean reports aren't welcome?

To be honest, I don't know. I'd rather see people use the rt2x00 code
instead of spending time cleaning up that mess (the code you've pasted
was pretty bad!). But you may or may not find somebody who cares about
that, just rather unlikely on this list.

johannes

--=-R1PjQfvNwWiXGaIZHnnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcW4ZAAoJEODzc/N7+Qmaxa4P/iGy79A4gyhyk+R0EWF57X+I
1VX3vTw7LClxkBnFS8aXiLNldnq1rD3tFkepsShc6osCq6iHGPDffAmAQcKkhxb/
zUfc2f+QmVjagvpcm+CVDDXZDxlmAp9ViY8b66cPguxO19fZ0+4dbpVyScs5RI3a
n1TNu6305Lk2+xyUVRLL1TrtCSq1D6FmlbVfF21XAMgDL2i9zULLEq+rrjbkWfEn
SkIBM6WZZNGZKCEbe7xCFHlub8mwROjfDBshj9+ZW4JNZ5mEEqr8yX2Bk8xYuTnn
n02t/d7dsAwBmR13N9LRG3BRXrnBriYIFtvwKLMF0PKpswT8LikKzVQmgeTXBrQU
0DyIQTHJcev8cjJij2Dj88lLUpkSgbhPd759EKWjenmdsXGmrjbmnzkGgFC082Ou
+OqVVhd70UKR4zXlndk1bwYNulLrNyUBson8xdW/P8ZiFKXdgHie/MWqvdR0f//F
WWBtBfV7MSbGVWPWaugFO0QrdO3lTc/UAZokCnuarVhm3M/QbabRR0xwTx7sW4US
AdUjkPBd1r5F2EBx+ZvYuj4b+vVDBzEujt4Iub5+3kEay7ycPLtRj4wrtV9xVqlc
hUhcLSUQGcDpj2L58yfeEZIwN/vqxUO01GjrmnFpvUv8P1nAUsFvQsBbynjYisXe
6idNtoxPWNDuxwdc7U2t
=Jr1n
-----END PGP SIGNATURE-----

--=-R1PjQfvNwWiXGaIZHnnV--

