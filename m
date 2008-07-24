Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYGXLkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYGXLkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYGXLkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:40:04 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43004 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYGXLkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:40:03 -0400
Subject: Re: 22bb1be4d27... breaks hal (and NM)
From: Johannes Berg <johannes@sipsolutions.net>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Jean Tourrilhes <jt@hpl.hp.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080724115805.5466c217@mjolnir.drzeus.cx>
References: <20080724115805.5466c217@mjolnir.drzeus.cx>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9LSTArbNWi01dX/HSDZs"
Date: Thu, 24 Jul 2008 13:38:40 +0200
Message-Id: <1216899520.13587.49.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9LSTArbNWi01dX/HSDZs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-24 at 11:58 +0200, Pierre Ossman wrote:
> From commit 22bb1be4d27...:
>=20
> "The /sys/class/net/*/wireless/ direcory is, as far as I know, not used
> by anyone."
>=20
> Can't have been much of an investigation as HAL uses these to determine
> if a card is a wireless one. Without this option, you cannot get
> wireless support in NetworkManager, stranding most laptops.

Bzzzzt. You suck. Go check again. Hint: try hal's git tree.

johannes

--=-9LSTArbNWi01dX/HSDZs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIiGm9AAoJEKVg1VMiehFYQIwQAJ+0xPEhYncyNSx29+Vq1nfy
5L1HDmIbbUdOW8h7Ca54h5EqRaeTwV7DMEJLse3ca4x+DtziggfahL+yucDEE+I8
MK6wQvbJ65gI/n7GzVB2/lbbc5NEVi2ADaDsWPRXXPgSbsT0do8VU69FnXyDpWqg
NxmXau7bm5h801IfTyYRDrTqRyiP1bQ5QZd0XUbRxlyGYU44dXK31FjgtlD3Yi0x
FQHmgAswTiAMlbIbLmkNCf1Wp+AsZicU3+N6+RibqwPHi8AGd8pTFpxnjbGikRQj
XjIFz79LG9dDtQzOEfFKYfZfWu8l/tMhHldrU7vhmBISEfAJAEupWZ7sXqCGfGdb
zByp2jnePI7plnYWQfTL/aY/BRTmBx+Az+bDHxhtcNOSm2AJXkiRxbfZHr7mskUx
XciT56ZOtGSeORGLFS0jjcK7ETOxs9sSR/n2x75IolEiB/+GXyoqQj4a+T1FtlEW
yb/S4jVLxACCVk4vKxBpjLG7UXSaGK6G7EAiZ6cf3grMoKFjNYsEH28dAjBkKEvu
sipvxaY0d0RwlI97LXgmLk/k2QfP2IvwcUo625n9QAq6o4qLhmYBc756haDedlqF
rYmIoo3gXAe75v98LC2G8OJB3gLdk+wrZHyKQtN3nxnITwutgSAaDwvecWGQs5Qa
wVwC7/E7q27GdKpSElrv
=YfaU
-----END PGP SIGNATURE-----

--=-9LSTArbNWi01dX/HSDZs--

