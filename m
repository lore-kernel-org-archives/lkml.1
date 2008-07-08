Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbYGHLlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbYGHLlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 07:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYGHLln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 07:41:43 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:52059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbYGHLlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 07:41:42 -0400
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works
	with ancient rt2500-1.1.0
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
       rt2400-devel@lists.sourceforge.net,
       Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1ba2fa240807071525m222efa91uf2ed009eb7b039b5@mail.gmail.com> (sfid-20080708_002612_572710_E45278A7)
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de>
	 <200807072308.57529.IvDoorn@gmail.com>
	 <69e28c910807071410h17cd6815jd6577673f73dc092@mail.gmail.com>
	 <200807072319.44733.IvDoorn@gmail.com>
	 <1ba2fa240807071525m222efa91uf2ed009eb7b039b5@mail.gmail.com>
	 (sfid-20080708_002612_572710_E45278A7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qTfKJbfyt/IRlbDLR87F"
Date: Tue, 08 Jul 2008 13:40:47 +0200
Message-Id: <1215517247.9610.24.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qTfKJbfyt/IRlbDLR87F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This is bug is reported very often mostly on ubuntu based distoros.
> There is no linkage dependency so it doesn't produce entry in the
> depmod.
> mac should somehow request these modules dynamically.

Wouldn't help. Bug reporter has a broken config with CONFIG_KMOD unset.

johannes

--=-qTfKJbfyt/IRlbDLR87F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIc1I7AAoJEKVg1VMiehFYnzwP/3n9lQUKix3Ul+0QvxvZHELb
bA1RwhC9POLKGiQ2qjqBVg7pGtq+Yz06c7xnkeufX4lrMXyYRPrcQY7nHjOHr5tg
0zV03NIwJjELD7gLzi47s3SlhJDdK4qrpS0F9uVVMHaNvZLZubmzjxNvWbvFy99Y
HA4FwFHlwjHhumLALEACBXiE4hsXMqw8N2dHd/U0vFlruNn7OUz0JkuUiIuN5Eid
XAlv8ImmrfOOqnLh4Ov+lUQ67fXDzXQg5K1rPFunkABHIblo2NwwUto9zhxmGAls
n82zcXmYbBh0qw1/VRJunav6MScvpIcSda0Wlt23qp37mQg3xewgmsCP29W/iWro
qRASlxL1L8pZ1F4x1Y1/05YrmP0UPIgb0jV0h2O1efKqGwWPTSH2pcc0UTv/plh+
8lDY/NGhJHse7KT5dyFUvChUggzgJa95RbAMHap0Al0ecfqiePv6WS/McEcGnSbc
USQZiMrePfGwz69dQp97Ws3IGJ58SLe/5bmgIQILyxhu7PFcVHe3tpaSCukPw7OR
RxrCL9nOTyFfyI1L5y0ZwxJj+ScRbVCML1LbVhFoMXzWZanJNWmt/ISfWv96I6iH
4qSQxeG5hkmsSaudzIIOi4ovWVuVpCGn8D27xkRp0TELH4JD6n7ZtS3XpzUu1DIX
NUbPh5VxVI1kwREzdRYg
=X1xQ
-----END PGP SIGNATURE-----

--=-qTfKJbfyt/IRlbDLR87F--

