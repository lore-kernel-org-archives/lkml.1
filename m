Return-Path: <linux-kernel-owner+w=401wt.eu-S1759778AbXK0Wkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778AbXK0Wkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbXK0Wka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:40:30 -0500
Received: from mail.vapor.com ([85.114.133.49]:47459 "EHLO mail.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbXK0Wk3 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:40:29 -0500
Subject: [SKY2] Problems (2.6.24-rc3-git1)
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Linux-kernel <Linux-kernel@vger.kernel.org>
In-Reply-To: <20071002215914.13d1e8cf@freepuppy.rosehill>
References: <1191372129.26233.12.camel@localhost>
	 <20071002180209.47c350a3@freepuppy.rosehill>
	 <1191375274.26233.17.camel@localhost>
	 <20071002215914.13d1e8cf@freepuppy.rosehill>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sOWQBCDg3XI8GF53fcGA"
Date: Tue, 27 Nov 2007 23:40:22 +0100
Message-Id: <1196203222.27041.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sOWQBCDg3XI8GF53fcGA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[Repost, no reply has been recived]

Hi,

A little while ago, something went horribly wrong.

I could still use my mouse and the desktop was still alive more or
less... everything using networking was dead AND the keyboard was
dead... So i composed commands using existing text on the screen.

The device:
sky2 0000:02:00.0: v1.20 addr 0xdbffc000 irq 17 Yukon-EC (0xb6) rev 2
sky2 0000:02:00.0: PCI Express Advanced Error Reporting not configured or M=
MCONFIG problem?
sky2 0000:02:00.0: No interrupt generated using MSI, switching to INTx mode=
.
sky2 eth0: addr 00:15:f2:aa:8b:3e

=46rom dmesg:
sky2 eth0: hung mac 124:39 fifo 195 (185:180)
sky2 eth0: receiver hang detected
sky2 eth0: disabling interface
NETDEV WATCHDOG: eth0: transmit timed out
sky2 eth0: tx timeout
sky2 eth0: transmit ring 442 .. 461 report=3D442 done=3D442
NETDEV WATCHDOG: eth0: transmit timed out
sky2 eth0: tx timeout
sky2 eth0: transmit ring 442 .. 461 report=3D442 done=3D442
NETDEV WATCHDOG: eth0: transmit timed out
sky2 eth0: tx timeout
sky2 eth0: transmit ring 442 .. 461 report=3D442 done=3D442
NETDEV WATCHDOG: eth0: transmit timed out
sky2 eth0: tx timeout
sky2 eth0: transmit ring 442 .. 461 report=3D442 done=3D442
NETDEV WATCHDOG: eth0: transmit timed out
sky2 eth0: tx timeout
sky2 eth0: transmit ring 442 .. 461 report=3D442 done=3D442
NETDEV WATCHDOG: eth0: transmit timed out
sky2 eth0: tx timeout
sky2 eth0: transmit ring 442 .. 461 report=3D442 done=3D442
NETDEV WATCHDOG: eth0: transmit timed out
sky2 eth0: tx timeout
sky2 eth0: transmit ring 442 .. 461 report=3D442 done=3D442
NETDEV WATCHDOG: eth0: transmit timed out
sky2 eth0: tx timeout
sky2 eth0: transmit ring 442 .. 461 report=3D442 done=3D442

And it continues until i press the reset button.


--=20
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net

--=-sOWQBCDg3XI8GF53fcGA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7-ecc0.1.6 (GNU/Linux)

iD8DBQBHTJzT7F3Euyc51N8RAvlKAJ91HoLaaATJKp8+ILQzkLytCdc6EgCfVI6f
NpF7ZCLguDIdIeaqvCrYS/s=
=BvGe
-----END PGP SIGNATURE-----

--=-sOWQBCDg3XI8GF53fcGA--

