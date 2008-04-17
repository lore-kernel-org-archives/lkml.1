Return-Path: <linux-kernel-owner+w=401wt.eu-S934623AbYDQQsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934623AbYDQQsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbYDQQru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:47:50 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:33521 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbYDQQrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:47:49 -0400
Subject: Re: [PATCH-mm 1/3] mac80211: tkip.c use get/put_unaligned helpers
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Benc <jbenc@suse.cz>, Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0804171102370.19002@twin.jikos.cz>
References: <1208370570.11920.107.camel@brick>
	 <20080417105859.45092413@griffin.suse.cz>
	 <Pine.LNX.4.64.0804171102370.19002@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MLCqqe8DCdjPwCAI0aIS"
Date: Thu, 17 Apr 2008 18:40:54 +0200
Message-Id: <1208450454.4066.20.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MLCqqe8DCdjPwCAI0aIS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I guess you are going to push this stuff through -mm altogether, right?=
=20
> > I can hardly take this into my tree right now, as the helpers are not i=
n=20
> > Linus' tree yet.
>=20
> yeah, sorry, that's been confusing a few people.
>=20
> Strictly I'd merge the core infrastructure and then send the dependent=20
> patches into the relevant maintainers.  But that can mean than we=20
> needlessly miss the merge window, so it's most parctical to send along an=
=20
> acked-by and I'll merge the dependent patch directly with the appropriate=
=20
> ordering.

I guess what Jiri (Benc) is saying that *I* should ack them, not him.
Jiri (Benc), maybe you care to move yourself down in the maintainers
file?

johannes

--=-MLCqqe8DCdjPwCAI0aIS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAd9laVg1VMiehFYAQLyDg//VHBiVt6/jocSLpe+BtPFeI+iOOCbp3Pp
JuAV7s9dHT27NConvZ0lnqwmL/zgPJPjMtMCbPYJDEI3XLcyeKAr331PFXRcuOGn
124/IQpniRKheOtjAj4r3XFG1gVd+Zl5pv4MP+JZan+AvX86HF3ZFbBr0onUVGmb
e5RGEtZqAeNnt2GFR56cNRdxJbhiQ7Td0ue3VDL0o/FVL9FUIzBGggtQK1sUf5k/
8ZbZHIao2P5Csi0sate/wRQWirFu4oXSZHBQaonCt6jrKNzjM/p+/4+IY+N5kRHU
xJTsdKA76ibkQ9D/s2TmW5q5u5esKM9OvHq9INs5dDlB0Ud0O8mapW1MPF/T6+Gd
xszfDts99oIpAzBQbpYibJQrjPaHdzLbwBX9eLjjre877OYgv3YUdMyT21FQQYnM
Ywd61/QxYJO9Ur8bzJEIGcG44FEHXiTe9bwua+VBeF4EFqzaI07qNcijdn9c62HO
+eGqrC+9iOT6DHaVywRfuCO5beiyjyI5XmEEIKqBxysL04fX9twrZStOK9C5X4Xq
JbWjK9vFDrKSTXaViOZH+KCANq+DyzHAYTRLLVD/nTKYbd+7saaPLbqTXQfzlFxr
V5QS03Qr269+3vFN4W/mpPJI6vZ5uKbg9cuz77Kx7uUoyNzAa5kI1IYiyDpeYTEF
TExk+WlmhyI=
=6zar
-----END PGP SIGNATURE-----

--=-MLCqqe8DCdjPwCAI0aIS--

