Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbYEZIyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbYEZIyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 04:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYEZIyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 04:54:10 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:52992 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbYEZIyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 04:54:09 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Michael Buesch <mb@bu3sch.de>, David Woodhouse <dwmw2@infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <BF546351-0C53-41C4-977A-6A777AF4D602@holtmann.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211724803.17151.36.camel@johannes.berg>
	 <41FE0259-522B-4B9B-A75D-7B97A9FD723F@holtmann.org>
	 <200805252039.17673.mb@bu3sch.de>
	 <BF546351-0C53-41C4-977A-6A777AF4D602@holtmann.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HLcTk4KgqQ3VWRWYlMv6"
Date: Mon, 26 May 2008 10:52:55 +0200
Message-Id: <1211791975.17151.42.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HLcTk4KgqQ3VWRWYlMv6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Again, I don't plan to break any setup. I actually do think it is a =20
> good idea to group firmware files in subdirectories in /lib/firmware, =20
> but this subdirectory name doesn't belong in the kernel.
>=20
> We will update udev to read the driver name and look into /lib/=20
> firmware/<driver>/<filename> and /lib/firmware/<filename> for the =20
> firmware file.

Clearly, you haven't understood the point. It is *NOT* (REPEAT: NOT)
about having the driver name in the firmware key.

johannes

--=-HLcTk4KgqQ3VWRWYlMv6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDp6ZqVg1VMiehFYAQKRnw//V8PDo3XFDrP88FbWUtH6Y17fGPO8tR0h
BIEcms5kJ5C8xwxFFuRzHh7J1gQKZ+ZldPTz8ik52P+XZxqq2J35xPbk3pRYh+/g
2Jj8AFITsO/ABGFDYpnJqSJGN9VnQiB0BMM9Ep0UxLs4KfTX0zYZdPVwD6i75689
GhYJJ19rZmoH1pGfHiCbbDbyBQtf1jOznU+MuNv5lCn0XzOKArumXOYBj+PlToel
7/diFwkNdhYwOZL1VQoCBps94YGHhXxAdySt5ZLNJHUjfy2k8GxcjiPB/j9Q3snT
u2dT8pwshzcOlWe6732F4c8F4VfRllqzwn3mbKdqi4zjKfEIDwpxiv+S0VpywWCL
FxwZcWolaZFjPnuCWsHQk0Y+pahj+THI026apG+5qSj1Si5mntEcIbmp8rOWSQXt
bWm2xPQ1MC+SlHI1M3ImZvzAYv1Lbvp9sX+Rd1yPh35+TPGwhCjSfldnVixhTGH5
52WytT3AbDuIFgSPOHwCmHyDqgjbPzktm0VZd+EFzgjLqrTSFBEXYBCYM0TKkXE9
qdIK2olqNBMrUgSLLV2kw/qi4ReH8WPR5Y0N9irhz7Iih7wPGeLK62ncLCDY8lci
86I6HphCY0BIlje3b3bo8zGw03VxIT0OM8tRevDNM1WkLEJUOWwAtCFukLRBxnnh
0EitKpsT1kw=
=d6R1
-----END PGP SIGNATURE-----

--=-HLcTk4KgqQ3VWRWYlMv6--

