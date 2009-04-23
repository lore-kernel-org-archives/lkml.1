Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbZDWNCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbZDWNCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZDWNCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:02:36 -0400
Received: from mailout10.t-online.de ([194.25.134.21]:60428 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZDWNCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:02:35 -0400
Message-ID: <49F066D8.5060802@t-online.de>
Date: Thu, 23 Apr 2009 15:02:16 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: forcedeth, 2.6.29.1: no link during initialization
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4F2EA41EF766E686B59AC0B7"
X-ID: TJ2RbsZQrhAYn1U+fCO66ScgXBfkmN5+UskUpxW6IFPtNijADzbj23avTNbPI3VwpK
X-TOI-MSGID: 74bff686-7ae1-402e-92c4-e1a4e112232a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4F2EA41EF766E686B59AC0B7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi folks,

I get these messages on every boot

[   37.413903] eth0: no link during initialization.
[   39.789316] eth0: link up.
[   39.794965] eth0: link down.
[   46.438599] eth0: link up.
[   48.407885] eth0: link down.
[   52.981754] eth0: link up.
[   52.986966] eth0: link down.

After that dhcpclient or network manager give up to try
again, i.e. the network is not set up.


I saw this mentioned several times on Google, but without
a solution. Maybe I could help to track this down?


Regards

Harri



--------------enig4F2EA41EF766E686B59AC0B7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknwZt0ACgkQUTlbRTxpHje08ACeIsTvDOaXRByYUUJTh2hOMj+C
bcwAn07CUTqLllAub86I0zLriZRM8loZ
=gXy1
-----END PGP SIGNATURE-----

--------------enig4F2EA41EF766E686B59AC0B7--
