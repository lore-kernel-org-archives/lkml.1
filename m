Return-Path: <linux-kernel-owner+w=401wt.eu-S932383AbZHQX0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbZHQX0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbZHQX0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:26:49 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:55941 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZHQX0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:26:49 -0400
X-Loopcount0: from 10.9.160.253
Message-ID: <4A89E763.7010404@dell.com>
Date: Mon, 17 Aug 2009 18:27:31 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090804)
MIME-Version: 1.0
To: cezary.jackiewicz@gmail.com
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Add support for Dell Mini series to compal-laptop
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig216235EA4C3A91763DABF6A1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig216235EA4C3A91763DABF6A1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi:

The Dell Mini series (9, 10, 10v, etc) have not been designed like most
Dell laptops that support libsmbios and dcdbas.  The ODM that designed
these laptops was Compal, and thus a lot of the functionality is like
other Compal laptops.  I'm providing a series of patches to add support
for these laptops as well as to use the rfkill interface instead.

--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enig216235EA4C3A91763DABF6A1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqJ52MACgkQ2CrZjkA73YsrrQCgjqucjZq43Hb2/fb09TX7U201
/JAAnAiDwPbDWry/jVD9Z5OOoWvVW3mA
=rWuQ
-----END PGP SIGNATURE-----

--------------enig216235EA4C3A91763DABF6A1--
