Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZDVLsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZDVLsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZDVLsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:48:39 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:1026 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbZDVLsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:48:37 -0400
Message-ID: <49EF040C.6070401@imap.cc>
Date: Wed, 22 Apr 2009 13:48:28 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: isdn4linux@listserv.isdn4linux.de, isdn@linux-pingi.de,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] Documentation/isdn/INTERFACE.CAPI
References: <49E4E9CA.8000802@imap.cc>	<20090421091852.9C31C111815@xenon.ts.pxnet.com> <20090422.023142.222186658.davem@davemloft.net>
In-Reply-To: <20090422.023142.222186658.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA093350EB3E6D3AABE69A46A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA093350EB3E6D3AABE69A46A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Apr 2009 02:31:42 -0700 (PDT), David Miller wrote:
> From: Tilman Schmidt <tilman@imap.cc>
> Date: Tue, 21 Apr 2009 11:18:52 +0200 (CEST)
>=20
>> @@ -8,6 +8,8 @@ INTERFACE
>>  	- description of isdn4linux Link Level and Hardware Level interfaces=
=2E
>>  INTERFACE.fax
>>  	- description of the fax subinterface of isdn4linux.
>> +INTERFACE.CAPI
>> +	- description of kernel CAPI Link Level to Hardware Level interface.=

>>  README
>>  	- general info on what you need and what to do for Linux ISDN.
>>  README.FAQ
>=20
> There is no INTERFACE.fax entry in this file in the current
> tree.
>=20
> I wanted to apply this, but aparently your patch is against
> something other than Linus's tree or net-2.6

It applies on top of my mis-dated patch

Subject: [PATCH v2] update Documentation/isdn/00-INDEX
Date: Mon, 17 Nov 2008 14:01:32 +0100

which I sent in fact on 7 Apr 2009. Somehow I thought you had
already applied that.

If it helps, I can re-send that one with the correct date, or
alternatively merge both of these patches into one.

Regards,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigA093350EB3E6D3AABE69A46A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJ7wQNQ3+did9BuFsRAr7AAJ9bsXYEUaoYEdqm8zh6NnhaK5nWfQCgib42
2FCNELBzwjnTDR3MLPChrPU=
=StOb
-----END PGP SIGNATURE-----

--------------enigA093350EB3E6D3AABE69A46A--
