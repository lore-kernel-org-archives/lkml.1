Return-Path: <linux-kernel-owner+w=401wt.eu-S935952AbYBVAKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935952AbYBVAKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbYBVAKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:10:31 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49111 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755333AbYBVAK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:10:29 -0500
X-Sasl-enc: vl6SVX80wAsAD9QXT7DGc7G/CvJK+OFxiZmvZY8oPUeu 1203639027
Message-ID: <47BE12F1.4040201@imap.cc>
Date: Fri, 22 Feb 2008 01:10:25 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: 2.6.25-rc2-mm1 - several bugs and a crash
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47BC982C.7050402@imap.cc> <20080221043828.bcd5cbce.akpm@linux-foundation.org> <20080221164632.GA31784@lst.de>
In-Reply-To: <20080221164632.GA31784@lst.de>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig80681417681A066A35A0EC8D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig80681417681A066A35A0EC8D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 21.02.2008 17:46 schrieb Christoph Hellwig:
> On Thu, Feb 21, 2008 at 04:38:28AM -0800, Andrew Morton wrote:
>> (net-related cc's removed)
>>
>> This look like a startup ordering bug in mnt_want_write().
>=20
> Do you have CONFIG_ACPI_CUSTOM_DSDT_INITRD set?

Negative.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig80681417681A066A35A0EC8D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHvhLxMdB4Whm86/kRAqMzAJ4yZfR1tO0W+XHeTlatuoz5VA80oQCfXFkw
iSidJK/r2N47bDH/+zH+n0Y=
=80jo
-----END PGP SIGNATURE-----

--------------enig80681417681A066A35A0EC8D--
