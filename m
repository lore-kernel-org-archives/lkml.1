Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab0BLQmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:42:18 -0500
Received: from nn7.de ([85.214.94.156]:47522 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab0BLQmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:42:17 -0500
Subject: Re: Brightness control for MacBook Pro - Nvidia 9400
From: Soeren Sonnenburg <sonne@debian.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Julien BLACHE <jb@jblache.org>, nicolas@boichat.ch,
       felipe_alfaro@linuxmail.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100212162810.GA20998@srcf.ucam.org>
References: <1265920725.7103.7.camel@no>
	 <878wayk8hn.fsf@sonic.technologeek.org>
	 <20100212141457.GA18714@srcf.ucam.org>
	 <87zl3eto99.fsf@sonic.technologeek.org>
	 <20100212162810.GA20998@srcf.ucam.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6AI/mmeIP1nqMAYCrsc5"
Date: Fri, 12 Feb 2010 17:42:17 +0100
Message-ID: <1265992937.3485.34.camel@no>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6AI/mmeIP1nqMAYCrsc5
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-12 at 16:28 +0000, Matthew Garrett wrote:
> On Fri, Feb 12, 2010 at 05:25:22PM +0100, Julien BLACHE wrote:
>=20
> > Is it exposed to userspace in any way? Or, better yet, could we have an
> > MBP backlight driver which would hide all of this from userspace?
>=20
> Sure, in nouveau.

OK, great convinced. Any suggestions on where to add printk's to figure
out the cause of the hang? The only thing I noticed was the fans turning
on so the machine is either stuck in a busy loop or ???

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-6AI/mmeIP1nqMAYCrsc5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJLdYToAAoJEH82z1Wqh6p304AP/1tPNE10YohDBH7hQ6UiLMsR
w9s2CtcoENgrJmRiIK1Eipk9Xkyu49CNKk/bTc2WAQ1ftpMwChfhnoPcPxvJRmue
dq6Mx2ESlqdza3BZSOI5iQ/d93n7y+OC2T3e2MlcotMzojrkI8/sOwRqdb4x6HMW
TRdWSEg3U1kVkI0VwJSlaIqGoVAKbwfQdE4TA7XuokhNuwyJMaCIKvq5kSauDhx3
opdNtmBlFpFVtuwTa7igwRc5jf25UqqQB+xrDFSkkOput9pDodcpczv/OjkUFi5+
KNwyKLei2XfnD7BGlPYvBeleMpzBrPIgZG+P3WXccubD41I5ln/eH2uZFkAuP3HY
8Y7hx46jJjKFTS9OSSY/psmMeIQk4AuwHBKt5fKaQvEI2fxTtq9uCf9OZtRQa/QE
JuHjG+xm71+JIv1/J6EOjx6L7ALIAiINcgdJyb2VnGyLRWq1lPY7F2n0QD0crWHs
qEJNlg8HghzkYEdsl2MCp/FjWrmx2O8HD19nlBdv1WiGxqWBgaXXIXMZq6hluHAo
JwGhUM8620FBbXu9yeKyUbY0tyQmBcfQleHzKDwK5n0L0L8hPLy/Lj5XatY9GIeU
hFH5PkIhxjGbd09Wt+k2/WVOCbgrZS2sjouYwwbPfFW1VWvS9XmUl6Ma91q9B78x
J6Hf9VNVQALJHjudYYuc
=1nYU
-----END PGP SIGNATURE-----

--=-6AI/mmeIP1nqMAYCrsc5--
