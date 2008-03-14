Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYCNJ7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYCNJ7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 05:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYCNJ7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 05:59:05 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:3256 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYCNJ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 05:59:04 -0400
Message-ID: <47DA4C39.2030304@imap.cc>
Date: Fri, 14 Mar 2008 10:58:17 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Zhao Yakui <yakui.zhao@intel.com>
CC: Dave Jones <davej@codemonkey.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc5-mm1] WARNING: at drivers/base/sys.c:173
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>	 <47D87238.8080305@imap.cc> <20080313195656.GA32463@codemonkey.org.uk>	 <47D9C04E.3060208@imap.cc> <1205456231.4082.2.camel@yakui_zhao.sh.intel.com>
In-Reply-To: <1205456231.4082.2.camel@yakui_zhao.sh.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0805B2AAF6E7448CC847E1BD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0805B2AAF6E7448CC847E1BD
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Mar 2008 08:57:11 +0800, Zhao Yakui wrote:
> Please set CONFIG_ACPI_DEBUG and boot the system with the option of
> "acpi.debug_layer=3D0x01010000 acpi.debug_level=3D0x1f".

CONFIG_ACPI_DEBUG is already set, but I cannot reboot the machine
right now. I'll probably get a chance for that in about 12 hours.

> It will be great if the acpidump output is attached.

Available now at
http://gollum.phnxsoft.com/~ts/linux/acpidump.out

HTH
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig0805B2AAF6E7448CC847E1BD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH2kw5Q3+did9BuFsRAiQfAJ9ktPJAi7bfpWv+cejecN2unJs+VACeLvtV
LpkxqJ7GwcPKg8Xj5VOaYQE=
=Cdst
-----END PGP SIGNATURE-----

--------------enig0805B2AAF6E7448CC847E1BD--
