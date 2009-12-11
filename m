Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbZLKOz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbZLKOz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758301AbZLKOzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:55:23 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:57193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZLKOzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:55:23 -0500
Subject: Re: [PATCH 0/2] Add support for Sphairon Homelink 1202 USB WLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stefan Seyfried <stefan.seyfried@googlemail.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091211144221.GA6663@tuxdriver.com>
References: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com>
	 <20091211133603.46bec686@strolchi.home.s3e.de>
	 <20091211144221.GA6663@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-V+UP4/X61yRUgfc80Zws"
Date: Fri, 11 Dec 2009 15:55:23 +0100
Message-ID: <1260543323.2442.287.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V+UP4/X61yRUgfc80Zws
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-12-11 at 09:42 -0500, John W. Linville wrote:

> It strikes me as strange that you are hitting two drivers to support
> one device.  Are you saying that your ar9170usb has the goofy storage
> device thing using the same USB IDs that the zd1211rw devices like that
> used?  I suppose that makes some sense given the shared heritage...

Good catch -- even if ar9170 descended from zd1211 it doesn't seem
appropriate to require two drivers for a single device.

johannes

--=-V+UP4/X61yRUgfc80Zws
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLIl1YAAoJEODzc/N7+QmahOAP+gMVkohKcqOX1DMooJri3FPu
tUy/S4zIEM7yXA7Mi1wo+RRnxVMXT+379XuDLTmVxLgTMAr7roATSKJOqqtydwYf
DjSTyznBADHQL66L7wzmD/y6zGE2MLRD5M9Z5Zl7GDZinP6ZYB5MbfDb1Ed6WfIC
IMW0CK3CgRMkkOGHUP82P+VFgzssbAeyGicvdLDr5oMKOM6iNp8D9Dov7s6MOhCO
14i+judJX/nI16BjGuYCE9emnvQ0e+TSQSnAGrZyaORVcPcMMgYIU8uyZgjfNyQw
alEHzSSew5ZljpgdVvGpLdVh58CtUQQC6FxVuLRoCFgny5rNJoU9LUoQERqrUIou
JBCYgr3qM3zlHzb2Cln1hOcofZlhIgBqREzSj8qUbUpYmledw5aWikPd4A8I8h7K
wC4cK3llmMPTk/rZMJnMv3fm3ajV/SP3l4Im2FWiuC4zUykZyDoXB0Uw5JQQg3TT
E65+EKONJlSknzFjZMERbCWtvB8XgC4hPGSPD1ox17e+mokpFK4VrPZXwhfYLduG
ft7llGVGR/BUmdU0h4yo2OxbIjfsA0A5bz9ClEUUL7HK2/wHOcec+I9nP0xwcdW6
Gl9tKpOR8cA58w/23Ix6pLfLR2lgR5nva/AMsg8jaFluw85zi5DXjR+CxOdO6kNi
3XClmgyp/HdovL+A2U14
=SJjB
-----END PGP SIGNATURE-----

--=-V+UP4/X61yRUgfc80Zws--

