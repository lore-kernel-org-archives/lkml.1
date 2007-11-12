Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbXKLSZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbXKLSZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbXKLSZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:25:33 -0500
Received: from sitemail2.everyone.net ([216.200.145.36]:36871 "EHLO
	omta14.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbXKLSZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:25:32 -0500
X-Eon-Dm: dm51
X-Eon-Sig: AQF97PZHOJqaeE8GKAIAAAAC,bb5f90e79b257e19fe21eba4175be7f4
Message-ID: <47389A8B.7070405@smsglobal.net>
Date: Tue, 13 Nov 2007 02:25:15 +0800
From: "Rogelio M. Serrano Jr." <rogelio@smsglobal.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Adrian Bunk <bunk@kernel.org>
Subject: Re: [poll] Is the megafreeze development model broken?
References: <fgtfqa$h9j$1@ger.gmane.org> <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com> <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi> <20071112152057.GJ9771@stusta.de> <47387BB5.4090908@smsglobal.net> <20071112171456.GN9771@stusta.de>
In-Reply-To: <20071112171456.GN9771@stusta.de>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig22D99E507072B51C254218B8"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig22D99E507072B51C254218B8
Content-Type: multipart/mixed;
 boundary="------------020705090007020801060109"

This is a multi-part message in MIME format.
--------------020705090007020801060109
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Adrian Bunk wrote:
>>
>> The core libc and supporting libraries is the core. and the toolchain
>> the core dev. Those can be updated twice or even once a year. The kern=
el
>> can be updated once a month if you like.
>>    =20
>
> A new release of the Linux kernel has more than half a million lines of=
=20
> code changed. If you do any estimates based on how many lines of change=
d=20
> code equal one newly introduced bug you see the problem...
>
> And the difference between an upstream kernel and a distribution kernel=
=20
> are 3-6 months of testing and bugfixing.
>
>  =20
True. But the libc and toolchain dont need to be as "dynamic".

>> I stopped using debian myself and used DIY linux based toolchain and
>> libc. Thats the stable core that i have been using for 4 months. If
>> debian can reduce the footprint of the "stable core" and do monthly
>> releases of package bundles i will use it again.
>>    =20
>
> Geeks like you and me want the latest software
> (I'm using Debian unstable/testing).
>
> But most users want a Linux installation that simply works - and this=20
> includes all software on the system at all times.
>  =20
Yeah me too. Sidux and mepis does not do megafreezes. I think whats
needed is to build and test groups of packages that work closely
together and release them frequently as a group.
> cu
> Adrian
>
>  =20


--=20
Democracy is about two wolves and a sheep deciding what to eat for dinner=
=2E


--------------020705090007020801060109
Content-Type: text/x-vcard; charset=utf-8;
 name="rogelio.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rogelio.vcf"

YmVnaW46dmNhcmQNCmZuOlJvZ2VsaW8gTS4gU2VycmFubyBKcg0KbjpNLiBTZXJyYW5vIEpy
O1JvZ2VsaW8NCm9yZzpTTVNHIENvbW11bmljYXRpb25zIFBoaWxpcHBpbmVzO1RlY2huaWNh
bCBEZXBhcnRtZW50DQphZHI6Ozs7Ozs7UmVwdWJsaWMgb2YgdGhlIFBoaWxpcHBpbmVzDQpl
bWFpbDtpbnRlcm5ldDpyb2dlbGlvQHNtc2dsb2JhbC5uZXQNCnRpdGxlOlByb2dyYW1tZXIN
CnRlbDt3b3JrOis2MzI3NTM0MTQ1DQp0ZWw7aG9tZTorNjMyOTUyNzAyNg0KdGVsO2NlbGw6
KzYzOTIwOTIwMjI2Nw0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZlcnNpb246Mi4xDQplbmQ6
dmNhcmQNCg0K
--------------020705090007020801060109--

--------------enig22D99E507072B51C254218B8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHOJqRyihxuQOYt8wRAkyEAKC00S/FRV7xFvF3A1lphiZ1mtjFFgCeN2L7
vxpV8AFrT9x8aHORk/AlwLk=
=uE6b
-----END PGP SIGNATURE-----

--------------enig22D99E507072B51C254218B8--
