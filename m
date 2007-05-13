Return-Path: <linux-kernel-owner+w=401wt.eu-S1761186AbXEMVqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186AbXEMVqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758578AbXEMVqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:46:44 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44889 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758437AbXEMVqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:46:43 -0400
X-Sasl-enc: zHHc/xXnizI5MTYqEosvVahGuYkVbTTr69MiKoftzwwT 1179092803
Message-ID: <464787F4.8040708@imap.cc>
Date: Sun, 13 May 2007 23:49:40 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
Subject: Re: undeprecate raw driver.
References: <E1HnHxK-0004CI-00@calista.eckenfels.net> <Pine.LNX.4.64.0705131347450.1144@localhost.localdomain> <464770A0.4070809@s5r6.in-berlin.de>
In-Reply-To: <464770A0.4070809@s5r6.in-berlin.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9C7079BEFF80E4F055FD2D18"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9C7079BEFF80E4F055FD2D18
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 13.05.2007 22:10 schrieb Stefan Richter:
> So why don't we simply say:
>=20
>   - "Users of feature A are urged to migrate to alternative B."
>   - "Feature C will be removed in February 2038."

Because that's too long to add to a Kconfig tag line.
You need a terse label there.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig9C7079BEFF80E4F055FD2D18
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGR4f/MdB4Whm86/kRAgpRAJ9eAti1HoTWFFYwvbyd2RYZfR1Q2QCfVUEX
ZRkKgYYepLXGNJIloVB23ow=
=Goee
-----END PGP SIGNATURE-----

--------------enig9C7079BEFF80E4F055FD2D18--
