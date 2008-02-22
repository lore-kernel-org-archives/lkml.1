Return-Path: <linux-kernel-owner+w=401wt.eu-S936501AbYBVOFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936501AbYBVOFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936135AbYBVODY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:03:24 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:37053 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936126AbYBVODW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:03:22 -0500
Subject: Re: [PATCH] mac80211: check endianness/types in sparse runs
From: Johannes Berg <johannes@sipsolutions.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, John Linville <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080221211610.GA27894@ZenIV.linux.org.uk> (sfid-20080221_211617_043502_ABA1CB03)
References: <1203503909.17534.14.camel@johannes.berg>
	 <20080220195913.GE21139@uranus.ravnborg.org>
	 <1203597776.20331.5.camel@johannes.berg>
	 <20080221211610.GA27894@ZenIV.linux.org.uk>
	 (sfid-20080221_211617_043502_ABA1CB03)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yaRn8kKNA16UPSKDsKev"
Date: Fri, 22 Feb 2008 15:02:37 +0100
Message-Id: <1203688957.7082.24.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yaRn8kKNA16UPSKDsKev
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > In any case, I would love to have __CHECK_ENDIAN__ enabled by default a=
t
> > least on the wireless code (just caught another bug with it...)
>=20
> So build with make C=3D2 -D__CHECK_ENDIAN__ net/ieee80211/, etc. - it's n=
ot
> that such a script would be tricky...

It's not that I don't know how to do it... it's that I don't want to
educate each person who gives me patches about sparse AND the check
endian stuff etc.

johannes

--=-yaRn8kKNA16UPSKDsKev
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR77V/KVg1VMiehFYAQKdAw//TqzVwtFbixikjqAa+UqaL2joT3vwo6FX
Um9s4k3A9uAZONbb74B2FLA4GBlc7942ZiGb90yLI7nerNqP2tqS1X5sttGBVkeh
c2iE0PP8sEgZSBKgYvW2jST1+TxaVy73e/mg6AVDod4TJcb392L5DsoH8sBNxLD5
EibqqDCXCYgVzc9JpsxFIhU8kRbw0QM+zVPU5NVa5h1C/OkzmHRYxlcehQHX6Jho
2/twhzWNIanOPUBcQcCay9AOvau4EHLUEQZnpfOAU+LFlvKPH2HJbpEpOQ1K4Gax
woBX0Qhdx4QkI2pLzDdKgJpTTAwJWb4LpY3qRkKTiQ+4T0slE+tgGvof1XUwpwF4
VfYFYs4Cc0kFboI6ifsbHbe//Ip3XZ2t+AcIE+YaXAhMjTOFxoNZlKnyA4PUeQ6e
GELlZ4sQKbHHojmdJ0ZwCJQkMmO5AvAO/2la3ceGILWeVfmB5c6hCShOa7LYqp3a
i0SY15Lkf4bIMnr8EaZLm8FcAXHNc4JgS37jO7B4p9lNbpzXbKts2yoGZa3kS9Ah
LrnoB52hvV3uwyzUEhm49jVd7Wxcu8KVYT0VcY9AqZD3jo7lI3UxKsylcW7AMWWZ
NhDlw+OWBlUwLc0Zy7i3FXckgCMFlJywm3FhqcrrLpRgxSddaTczs4+b7vuHVCNK
My3u6f43xMI=
=EmUW
-----END PGP SIGNATURE-----

--=-yaRn8kKNA16UPSKDsKev--

