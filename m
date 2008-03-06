Return-Path: <linux-kernel-owner+w=401wt.eu-S933610AbYCFR5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610AbYCFR5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbYCFR5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:57:30 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56313 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbYCFR53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:57:29 -0500
X-Sasl-enc: s7hrE7CHW6DaBKAOQqwTuPn3YmVpSYyuOBfyINAKWMZe 1204826248
Message-ID: <47D03086.3000806@imap.cc>
Date: Thu, 06 Mar 2008 18:57:26 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
References: <200803030316.07165.rjw@sisk.pl>
In-Reply-To: <200803030316.07165.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3A3E5983C337F26F1C18C5CD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3A3E5983C337F26F1C18C5CD
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable

On 03.03.2008 03:16 Rafael J. Wysocki wrote:

> Unresolved regressions
> ----------------------

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D10021
> Subject		: Linux 2.6.25-rc2 regression: LVM cannot find volume group
> Submitter	: Tilman Schmidt <tilman@imap.cc>
> Date		: 2008-02-16 20:14
> References	: http://lkml.org/lkml/2008/2/16/208
> Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 		  Jiri Slaby <jirislaby@gmail.com>

Fixed in 2.6.25-rc4 by the introduction of CONFIG_SYSFS_DEPRECATED_V2.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig3A3E5983C337F26F1C18C5CD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH0DCGMdB4Whm86/kRAqG9AJwOQopwi64Q8eVgcIWTeJK8EpcU8QCcCcv1
EJFdJKwZdLdhOO4TuSDIi5c=
=poDj
-----END PGP SIGNATURE-----

--------------enig3A3E5983C337F26F1C18C5CD--
