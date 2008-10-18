Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbYJRRGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbYJRRGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 13:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYJRRGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 13:06:23 -0400
Received: from server.drzeus.cx ([85.8.24.28]:40441 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750926AbYJRRGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 13:06:23 -0400
Date: Sat, 18 Oct 2008 19:06:13 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Karsten Keil <kkeil@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: e1000e EEPROM corruption
Message-ID: <20081018190613.3d0ef384@mjolnir.drzeus.cx>
In-Reply-To: <20081017135910.GA18206@pingi.kke.suse.de>
References: <20081017135910.GA18206@pingi.kke.suse.de>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-20605-1224349581-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-20605-1224349581-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Oct 2008 15:59:10 +0200
Karsten Keil <kkeil@suse.de> wrote:

> Hi,
>=20
> so after this ugly bug is finally fixed, here maybe left some victims of
> this bug.
>=20
> If here is still sombody who need help to recover from this issue,
>=20
> I can probably help him, I successful recovered all machines on our side,
> even one which do not longer show the NIC via lspci, so the only resticti=
on
> is, that the machine still boots and we have a NVM image of a similar
> machine.
> You should know the PCI ids of the NIC from the time before it crashed and
> the MAC address.
>=20

I need some assistance here. Machine is a Thinkpad R61 and the device
has fallen off the bus. It used to be at 00:19.0:

00:19.0 Ethernet controller: Intel Corporation 82566DC Gigabit Network Conn=
ection (rev 03)

I can get my hands on a NVM image from an identical machine during the
week.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-20605-1224349581-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkj6F4kACgkQ7b8eESbyJLi9UACgo373GMCEWP6NvS+oPRRddR+J
xKIAn3U0K7kKsDfS/0j0cG/Rx1f3Z9jQ
=vhGH
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-20605-1224349581-0001-2--
