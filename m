Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab0BSXpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 18:45:12 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51142 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117Ab0BSXpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 18:45:09 -0500
X-Sasl-enc: oQET2pWoNnBNep7qFvp0fQ0aCSqEWf9FyuJ2g4icf1ZT 1266623108
Message-ID: <4B7F2242.6010807@imap.cc>
Date: Sat, 20 Feb 2010 00:44:02 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Uros Bizjak <ubizjak@gmail.com>
Subject: Re: [PATCH 00/12] Clean up code to use native kernel functions when
 	convert or check hex digits
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com> <5ec8ebd51002190341k389064aao4a472e048ed26588@mail.gmail.com>
In-Reply-To: <5ec8ebd51002190341k389064aao4a472e048ed26588@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig027FCC27A2FFAF406B09C4A6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig027FCC27A2FFAF406B09C4A6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 19.02.2010 12:41 schrieb Andy Shevchenko:
> Additionally I'd like to sort out patches for two series - one is
> about clean up code and substitute custom functions by existing ones,
> the other is about introducing hex_to_bin() helper.
>=20
> So, I'm going to prepare mentioned series. Please decline that one,
> but patch #1 which already has been Acked. I will include Cc field as
> well.

I can forward your patch #1 to the ISDN maintainer together with my
own patches for 2.6.34, or you can resubmit it with my ACK. Just
tell me which way you prefer.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enig027FCC27A2FFAF406B09C4A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkt/Ik4ACgkQQ3+did9BuFtyPwCbBCLmgQyjAdoishJNscLPbouG
c+UAnRoRXTWL+SyE5zkHuB/ZnGjBMavc
=3ysX
-----END PGP SIGNATURE-----

--------------enig027FCC27A2FFAF406B09C4A6--
