Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbYAOX66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbYAOX66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758494AbYAOXwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:52:08 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33496 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758166AbYAOXwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:52:07 -0500
X-Sasl-enc: QJP/pC5ArKD5kUFC6/zc6o02RbKuJICLFW/Zg6qmTvE5 1200441125
Message-ID: <478D4723.5000407@imap.cc>
Date: Wed, 16 Jan 2008 00:52:03 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Folkert van Heusden <folkert@vanheusden.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Fw: G965 & on-board serial port
References: <20080109130242.GD8331@vanheusden.com>
In-Reply-To: <20080109130242.GD8331@vanheusden.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC7C763EAB0001ADAE2A2C94F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC7C763EAB0001ADAE2A2C94F
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 09.01.2008 14:02 schrieb Folkert van Heusden:
> (no-one with a g965 mobo who uses the serial port?)

I am using the on-board serial port of a Intel DQ965GF board for
ongoing test and development of the ser_gigaset driver, which is
implemented as a line discipline on top of the standard serial
driver. The port works purrfectly fine, including non-trivial
use of the modem control lines. I'm sure I would have noticed
any existing problems by now.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigC7C763EAB0001ADAE2A2C94F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHjUckMdB4Whm86/kRAoF2AJ9JOGAqhCWR74t0dcUPAjh7/pNBrQCcC/tZ
z2SmZOv3pWE3IbqdumnLTXw=
=WA7G
-----END PGP SIGNATURE-----

--------------enigC7C763EAB0001ADAE2A2C94F--
