Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZI3WAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZI3WAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZI3WAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:00:23 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34601 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751657AbZI3WAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:00:21 -0400
X-Sasl-enc: x+w7xpoVH6/foYTb58hjSa6PWwtxaX1txJTcxG9wj1Ks 1254348025
Message-ID: <4AC3D4EB.1060301@imap.cc>
Date: Thu, 01 Oct 2009 00:00:11 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: N_PPP_SYNC ldisc BUG: sleeping function called from invalid context
References: <4AC37032.4030901@imap.cc> <20090930174704.796b24b9@lxorguk.ukuu.org.uk> <4AC3A986.4080808@imap.cc> <4AC3BF62.9020706@gmail.com>
In-Reply-To: <4AC3BF62.9020706@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4BF63BA4072024B7D88C2FAB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4BF63BA4072024B7D88C2FAB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jarek Poplawski schrieb:
> Tilman Schmidt wrote, On 09/30/2009 08:55 PM:
> ...
>> Why then does mutex_lock() complain?
>=20
>=20
> Maybe it doesn't matter here, but this:=20
>=20
>> INFO: lockdep is turned off.
> suggests there was some lockdep issue/warning earlier.

That's just because some <deleted> decided that tainted kernels don't des=
erve lockdep.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig4BF63BA4072024B7D88C2FAB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKw9T1Q3+did9BuFsRAjH0AJ9jgFQ7hHEoyv1QsH7HMbOFuQTyugCfbeZX
oa6MFIzFkqgto8Qh6ktAiJk=
=nbSo
-----END PGP SIGNATURE-----

--------------enig4BF63BA4072024B7D88C2FAB--
