Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZITRBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZITRBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZITRBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:01:13 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57779 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676AbZITRBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:01:12 -0400
X-Sasl-enc: wbs6bh91gaDG5l8pQofJo/qZ9K9zBCV/ikpGO+9jXwxI 1253466075
Message-ID: <4AB65FD9.3020004@imap.cc>
Date: Sun, 20 Sep 2009 19:01:13 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Status of Bug 8094 -  ipaq oops on connecting "Vodafone VPA-II"
 ?
References: <4AB630AD.90207@imap.cc> <20090920150549.GC11621@kroah.com>
In-Reply-To: <20090920150549.GC11621@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC2A1C99197E352349F4DE7B9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC2A1C99197E352349F4DE7B9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Btw, I just found another bugzilla entry describing essentially
the same problem:

Bug 10868 -  Oops on loading ipaq module since 2.6.26, prevents use of de=
vice
http://bugzilla.kernel.org/show_bug.cgi?id=3D10868

Its status is - you'll never guess - "CLOSED CODE_FIX"!

Quite a persistent little fella, it seems.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigC2A1C99197E352349F4DE7B9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKtl/ZQ3+did9BuFsRAlEsAKCKsQ4l9zCCHGkrUj5C2MJrxe5eygCeK4kg
NUj3mKl2MVc5xcP8xjidw0E=
=xuJi
-----END PGP SIGNATURE-----

--------------enigC2A1C99197E352349F4DE7B9--
